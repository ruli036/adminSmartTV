import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/variabel.dart';
import 'package:smart_tv/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoController extends GetxController{
  final timeZone = tz.getLocation('Asia/Jakarta');
  final keyform = GlobalKey<FormState>();
  TextEditingController judulIklan = TextEditingController();
  PlatformFile? pickFileVideo;
  final storage = GetStorage();
  String videoURL = "";
  RxBool volume = false.obs;
  RxBool volumePlay = false.obs;
  String videoID = "";
  RxBool videoSelect = false.obs;
  bool editVideo = false;
  RxInt videoChange = 0.obs;
  RxString slideValue = list.first.obs;
  RxString slideValueOld = "".obs;
  RxString screenValue = screen.first.obs;
  RxString screenValueOld = "".obs;
  bool imgEditData = false;
  RxDouble uploudProgres = 0.0.obs;
  RxInt displayProgres = 0.obs;
  var fileVideo,email,videoName,videoNameOld;
  var infoFile;
  RxBool playVideo = false.obs;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  Stream<List<Videos>> getDataVideos()=>
      FirebaseFirestore.instance.collection('data-videos').where("email", isEqualTo: email).orderBy("no_slide",descending: false).orderBy('judul',descending: false).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Videos.fromJson(doc.data())).toList());


  closeVideo(){
    videoPlayerController!.dispose();
    chewieController!.dispose();
    Get.back();
    playVideo.value= false;
  }
  Future getVideo()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      if(result.files.single.size > 55000000) {
        AppAlert.getAlert("INFO", "Maximum video size 50 MB", ()=>Get.back());
      }else{
        AppAlert.loading("Loading","Please Wait...",false);
        fileVideo = result.files.single.path;
        infoFile = result.files.single.name;
        videoSelect.value = true;
        videoChange.value++;
        print("=================");
        print(result.files.single.name);
        print(result.files.single.size);
        print(result.files.single.bytes);
        print(fileVideo);
        Get.back();
      }
    }
  }
  Future cekKoneksi()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.bottomSheet(
            FormAddVideo()
        );
      }
    } on SocketException catch (_) {
      AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
    }
  }
  void whenDelete(id){
    AppAlert.getAlertHapus(
        "Delete", "Are You Sure? ",
            ()
        {
          AppAlert.loading("Delete Data","Please Wait...",false);
          deleteDataVideo(id);
        }
    );
  }
  Future uploudVideo()async{
    try{
    if(fileVideo != null){
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Uploud Video",
          content: ProgresUploudVideo(message: "Please Wait...")
      );
      String uniqueFileName =
      DateTime.now().millisecondsSinceEpoch.toString() + infoFile;
      //route uploud ke storage firabase
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('videos');
      // unic name image
      Reference referenceImageNameUploud = referenceDirImage.child(uniqueFileName);
      try{
        UploadTask progres =  referenceImageNameUploud.putFile(File(fileVideo));
        progres.snapshotEvents.listen((TaskSnapshot snapshot) async {
          print('Task state: ${snapshot.state}');
          // print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
          uploudProgres.value = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          displayProgres.value = uploudProgres.value.toInt();

          switch (snapshot.state) {
            case TaskState.paused:
            // TODO: Handle this case.
              break;
            case TaskState.running:
              // uploudProgres.value = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
              print("Progress : ${displayProgres.value} %");
              break;
            case TaskState.success:
              videoURL = await referenceImageNameUploud.getDownloadURL();
              videoName = uniqueFileName;
              if(editVideo == false){
                addVideoData(videoURL, videoName);
              }else{
                editVideoData(videoID,videoURL,videoName).whenComplete(() {
                  Get.back();
                  Get.back();
                  if(fileVideo != null){
                    deleteVideo(videoNameOld);
                  }
                  editVideo = false;
                });
              }
              print('========================');
              print(videoName);
              print(videoURL);
              Get.back();
              Get.back();
              break;
            case TaskState.canceled:
              Get.back();
              AppAlert.getAlert("Uploud Failed", "Try Again Later", () => Get.back());
              break;
            case TaskState.error:
              Get.back();
              AppAlert.getAlert("Uploud Failed", "Try Again Later", () => Get.back());
              break;
          }
        }, onError: (e) {
          print(progres.snapshot);
          Get.back();
          Get.back();
          AppAlert.getAlert("Uploud Failed", "Usage limit over for this day, please try again later", () => Get.back());

        });
      }catch(error){
        AppAlert.getAlert("Uploud Failed", "Try Again Later", () {Get.back();Get.back();});
      }
    }else{
      AppAlert.loading("Loading", "Please Wait...", false);
      editVideoData(videoID,videoURL,videoName).whenComplete(() {
        editVideo = false;
        Get.back();
        Get.back();
      });
    }
    }catch(error){
      AppAlert.loading("Loading", "Please Wait...", true);
    }
  }
  Future getPlayVideo(url)async{
    final fileInfo = await checkCacheFor(url);
    if (fileInfo == null){
      cachedForUrl(url).whenComplete(() {
        videoPlayerController = VideoPlayerController.network(url);
        videoPlayerController!.initialize().then((value)async {
          chewieController = await ChewieController(videoPlayerController: videoPlayerController!,autoPlay: false);
          if(volumePlay.value == false){
            chewieController!.setVolume(0.0);
          }
          playVideo.value = true;
        });
      });
      print("INTERNET");
    }else {
      final file = fileInfo.file;
      videoPlayerController = VideoPlayerController.file(file);
      videoPlayerController!.initialize().then((value)async {
        chewieController = await ChewieController(videoPlayerController: videoPlayerController!,autoPlay: false);
        if(volumePlay.value == false){
          chewieController!.setVolume(0.0);
        }
        playVideo.value = true;
        print("LOCAL");
      });
    }
  }
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  Future cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }
  addVideoData(UrlVideo, name)async{
    final firebase = FirebaseFirestore.instance.collection('data-videos').doc();
    final sends = Videos(
        id: firebase.id,
        volume: volume.value,
        screen: screenValue.value,
        nameImg: name,
        judul: judulIklan.text,
        video: UrlVideo,
        email: email,
        numberSlide:slideValue.value,
        date: tz.TZDateTime.from(DateTime.now(), timeZone),
        lastupdate: tz.TZDateTime.from(DateTime.now(), timeZone),
    );
    final json = sends.toJson();
    await firebase.set(json);
    judulIklan.clear();
  }
  Future editVideoData(id,UrlVideo,nameVideo)async{
    final data = FirebaseFirestore.instance.collection("data-videos").doc(id);
    data.update({
      'judul': judulIklan.text,
      'name': nameVideo,
      'video': UrlVideo,
      'volume': volume.value,
      'screen': screenValueOld.value,
      'no_slide': slideValueOld.value,
      'last_update': tz.TZDateTime.from(DateTime.now(), timeZone),
    });
    judulIklan.clear();
    // Get.back();
  }
  Future deleteVideo(name) async{
    Reference referenceRoot = FirebaseStorage.instance.ref();
    final desertRef = referenceRoot.child("videos/$name");
    await desertRef.delete();
  }
  void deleteDataVideo(String id){
    deleteVideo(videoName).whenComplete(() {
      print("HAPUS DATA");
      final data = FirebaseFirestore.instance.collection("data-videos").doc(id);
      data.delete();
    });
    Get.back();
    Get.back();
  }
  validasi() {
    final form = keyform.currentState;
    if (form!.validate()) {
      form.save();
      if(fileVideo == null){
        if(Get.isSnackbarOpen)return;
        Get.snackbar("Info", "Please Insert Video",backgroundColor: Colors.white);
      }else{
        print("Uploud Video");
        uploudVideo();
      }
    }
  }
  validasiEdit() {
    final form = keyform.currentState;
    if (form!.validate()) {
      form.save();
      editVideo = true;
      uploudVideo();
    }
  }
  void pilihAction(String choice)async{
    if(choice == Setting.edit){
      imgEditData == true;
      videoChange.value = 0;
      videoSelect.value = false;
      fileVideo = null;
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Get.bottomSheet(
              FormEditVideo()
          );
        }
      } on SocketException catch (_) {
        AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
      }

    }else if(choice == Setting.hapus){
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
           whenDelete(videoID);
        }
      } on SocketException catch (_) {
        AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
      }

    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    email = GetStorage().read(AppVariabel.email);

    super.onInit();

  }
  @override
  void dispose() {
    // TODO: implement onInit
     super.dispose();
     videoPlayerController!.dispose();
     chewieController!.dispose();

  }


}