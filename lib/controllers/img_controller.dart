import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/variabel.dart';
import 'package:smart_tv/widgets/widgets.dart';
import 'package:timezone/timezone.dart' as tz;
class ImagesController extends GetxController{
  final timeZone = tz.getLocation('Asia/Jakarta');
  final storage = GetStorage();
  TextEditingController judulIklan = TextEditingController();
  final keyform = GlobalKey<FormState>();
  File? fileImageView;
  var fileImage,email,imgName,imgNameOld;
  String imageURL = "";
  String imageID = "";
  RxBool imgSelect = false.obs;
  RxInt imgChange = 0.obs;
  List ImageData = [];
  RxString slideValue = list.first.obs;
  RxString slideValueOld = "".obs;
  RxString screenValue = screen.first.obs;
  RxString screenValueOld = "".obs;
  bool imgEditData = false;
  RxDouble uploudProgres = 0.0.obs;
  RxInt displayProgres = 0.obs;
  bool editImage = false;

  Stream<List<Images>> getDataImages()=>
      FirebaseFirestore.instance.collection('data-images').where("email", isEqualTo: email).orderBy('no_slide',descending: false).orderBy('judul',descending: false).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Images.fromJson(doc.data())).toList());

  Future getImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image,);
    if (result != null) {
      if(result.files.single.size > 2500000){
        AppAlert.getAlert("INFO", "Maximum image size 2 MB", ()=>Get.back());
      }else{
        fileImage = result.files.single.path;
        await cropImage(File(fileImage));
        // fileImageView = img;

        // AppAlert.loading("Loading", "Compressing Image",false);
        // Timer(Duration(seconds: 1), () {
        //   compressImage();
        // });

        print("-------------------");
        print(result);
        print(fileImage);
        print(result.files.single.size);
      }
    }
  }
  Future<File?>cropImage(File imageFile)async{
    CroppedFile? cropeImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(cropeImage == null){
      imgChange.value = 0;
      imgSelect.value = false;
      return null;
    }else{
      imgChange.value++;
      imgSelect.value = true;
      fileImageView = File(cropeImage.path);
      fileImage = File(cropeImage.path);
    }

    // File(cropeImage.path);
  }
  Future compressImage()async{
    final tempDir = await getTemporaryDirectory();
    String path = tempDir.path;
    int rand = new Math.Random().nextInt(100000);
    Img.Image? iMage = await Img.decodeImage(File(fileImage).readAsBytesSync());
    Img.Image smallerImg =await Img.copyResize(iMage!, width: 500);
    var compressImg = await File("$path/gambar$rand.jpg")..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
    fileImage = compressImg;
    Get.back();
  }
  Future cekKoneksi()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.bottomSheet(
            FormAddImage()
        );
      }
    } on SocketException catch (_) {
      AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
    }
  }
  Future uploudImage()async{
    if(fileImage != null) {
      // compressImage().whenComplete(() {
      //   Get.back();
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Uploud Image",
            content: ProgresUploudImage(message: "Please Wait...")
        );
        String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
        //route uploud ke storage firabase
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child('images');
        // unic name image
        Reference referenceImageNameUploud = referenceDirImage.child(uniqueFileName);

        try {
        UploadTask progres = referenceImageNameUploud.putFile(fileImage);
        progres.snapshotEvents.listen((TaskSnapshot snapshot) async {
          print('Task state: ${snapshot.state}');
          // print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
          uploudProgres.value =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
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
              imageURL = await referenceImageNameUploud.getDownloadURL();
              imgName = uniqueFileName;
              print('------------------------');
              print(imageURL);
              if(editImage == false){
                addImageData(imageURL, imgName);
              }else{
                editImageData(imageID,imageURL,imgName).whenComplete(() {
                  if(fileImage != null){
                    deleteImage(imgNameOld);
                  }
                  editImage = false;
                });
              }
              Get.back();
              Get.back();
              Get.back();
              break;
            case TaskState.canceled:
              Get.back();
              AppAlert.getAlert("Uploud Canceled", "Try Again Later", () => Get.back());
              break;
            case TaskState.error:
              Get.back();
              AppAlert.getAlert("Uploud Error", "Try Again Later", () => Get.back());
              break;
          }
        }, onError: (e) {
          print(progres.snapshot);
          Get.back();
          Get.back();
          AppAlert.getAlert("Uploud Failed", "Usage limit over for this day, please try again later", () => Get.back());
        });
        } catch (error) {
          AppAlert.getAlert("Uploud Failed", "Try Again Later, Code Error", () {Get.back();Get.back();});
        }
      // });
    }else{
      AppAlert.loading("Loading", "Please Wait...", false);
      editImageData(imageID,imageURL,imgName).whenComplete(() {
        editImage = false;
        Get.back();
        Get.back();
      });

    }
  }
  void whenDelete(id){
    AppAlert.getAlertHapus("Delete", "Are You Sure? ", ()=> deleteDataImage(id) );
  }

  addImageData(UrlImage, name)async{
    final firebase = FirebaseFirestore.instance.collection('data-images').doc();
    final sends = Images(
        id: firebase.id,
        nameImg: name,
        screen: screenValue.value,
        judul: judulIklan.text,
        image: UrlImage,
        email: email,
        numberSlide:slideValue.value,
        date: tz.TZDateTime.from(DateTime.now(), timeZone),
        lastupdate: tz.TZDateTime.from(DateTime.now(), timeZone)
    );
    final json = sends.toJson();
    await firebase.set(json);
    judulIklan.clear();
  }
  Future editImageData(id,UrlImage,nameImg)async{
    final data = FirebaseFirestore.instance.collection("data-images").doc(id);
    data.update({
      'judul': judulIklan.text,
      'name': nameImg,
      'screen': screenValueOld.value,
      'image': UrlImage,
      'no_slide': slideValueOld.value,
      'last_update': tz.TZDateTime.from(DateTime.now(), timeZone),
    });
    judulIklan.clear();
  }
  Future deleteImage(name) async{
    Reference referenceRoot = FirebaseStorage.instance.ref();
    final desertRef = referenceRoot.child("images/$name");
    await desertRef.delete();
  }
  void deleteDataImage(String id){
    AppAlert.loading("Delete Data","Please Wait...",false);
    deleteImage(imgName).whenComplete(() {
      final data = FirebaseFirestore.instance.collection("data-images").doc(id);
      data.delete();
    });
    Get.back();
    Get.back();
  }
  validasi() {
    final form = keyform.currentState;
    if (form!.validate()) {
      form.save();
      if(fileImage == null){
        if(Get.isSnackbarOpen)return;
        Get.snackbar("Info", "Please Insert Image",backgroundColor: Colors.white);
      }else{
        uploudImage();
      }
    }
  }
  validasiEdit() {
    final form = keyform.currentState;
    if (form!.validate()) {
      form.save();
      editImage = true;
      uploudImage();
    }
  }
  void pilihAction(String choice)async{
    if(choice == Setting.edit){
      imgEditData == true;
      imgChange.value = 0;
      imgSelect.value = false;
      fileImage = null;
      print(imgChange.value);
      print(imgSelect.value);
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Get.bottomSheet(
              FormEditImage()
          );
        }
      } on SocketException catch (_) {
        AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
      }

    }else if(choice == Setting.hapus){
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          whenDelete(imageID);
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

}