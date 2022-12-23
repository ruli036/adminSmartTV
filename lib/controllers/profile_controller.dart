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
class ProfileController extends GetxController{
  final timeZone = tz.getLocation('Asia/Jakarta');
  var email,fileImage,imageURL,imgName,imgNameOld,idKantor;
  final keyform = GlobalKey<FormState>();
  TextEditingController namaKantor = TextEditingController();
  TextEditingController namaKantor2 = TextEditingController();
  TextEditingController alamat = TextEditingController();
  RxString template = ''.obs;
  TextEditingController teksBerjalan = TextEditingController();
  RxDouble uploudProgres = 0.0.obs;
  RxInt displayProgres = 0.obs;

  Stream<List<DataKantor>> getDataKantor()=>
      FirebaseFirestore.instance.collection('office').where("email", isEqualTo: email).snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => DataKantor.fromJson(doc.data())).toList());
  Future cekKoneksi()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getImage();
      }
    } on SocketException catch (_) {
      AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
    }
  }
  // cekConection();

  Future getImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image,);
    if (result != null) {
      if(result.files.single.size > 5500000){
        AppAlert.getAlert("INFO", "Maximum image size is 5 MB", ()=>Get.back());
      }else {
         fileImage = result.files.single.path;
        await cropImage(File(fileImage));
      }
      print("-------------------");
      print(result);
      print(fileImage);
    } else {
      print("No file selected");
    }

  }
  // Future compressImage()async{
  //   final tempDir = await getTemporaryDirectory();
  //   String path = tempDir.path;
  //   int rand = new Math.Random().nextInt(100000);
  //   Img.Image? iMage = await Img.decodeImage(fileImage.readAsBytesSync());
  //   Img.Image smallerImg =await Img.copyResize(iMage!, width: 500);
  //   var compressImg = await File("$path/gambar$rand.jpg")..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));
  //   fileImage = compressImg;
  //   Get.back();
  // }
  Future<File?>cropImage(File imageFile)async{
    CroppedFile? cropeImage = await ImageCropper().cropImage(sourcePath: imageFile.path);
    if(cropeImage == null){
      return null;
    }else{
      fileImage = File(cropeImage.path);
      uploudImage();
    }
    // File(cropeImage.path);
  }
  Future uploudImage()async{
    // compressImage().whenComplete(() {
      Get.back();
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Uploud Image",
          content: ProgresUploudImageProfile(message: "Please Wait...")
      );
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      //route uploud ke storage firabase
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child('images');
      // unic name image
      Reference referenceImageNameUploud = referenceDirImage.child(uniqueFileName);

      try {
        UploadTask progres = referenceImageNameUploud.putFile(File(fileImage!.path));
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
              imgName = uniqueFileName;
              await referenceImageNameUploud.putFile(File(fileImage.path));
              imageURL = await referenceImageNameUploud.getDownloadURL();
              editLogoKantor(idKantor, imageURL, imgName).whenComplete(() => deleteImage(imgNameOld));

              print('+++++================');
              print(imageURL);
              Get.back();
              Get.back();
              Get.back();
              break;
            case TaskState.canceled:
            // TODO: Handle this case.
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
      } catch (error) {
        AppAlert.getAlert("Uploud Failed", "Try Again Later", () {Get.back();Get.back();});
      }
    // });

  }
  Future deleteImage(name) async{
    Reference referenceRoot = FirebaseStorage.instance.ref();
    final desertRef = referenceRoot.child("images/$name");
    await desertRef.delete();
  }
  Future editLogoKantor(id,UrlImage,nameImg)async{
    final data = FirebaseFirestore.instance.collection("office").doc(id);
    data.update({
      'name_image': nameImg,
      'image': UrlImage,
    });
  }
  Future editInfoKantor(id)async{
    AppAlert.loading("Saving Data","Please Wait...",false);
    final data = FirebaseFirestore.instance.collection("office").doc(id);
    data.update({
      'addreess': alamat.text,
      'last_update': tz.TZDateTime.from(DateTime.now(), timeZone),
      'name_office': namaKantor.text,
      'name_office2': namaKantor2.text,
      // 'run_text': teksBerjalan.text,
      'template': template.value,
    });
    Get.back();
    Get.back();
  }
  Future cekKoneksi2()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.bottomSheet(
            FormEditDataKantor()
        );
      }
    } on SocketException catch (_) {
      AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
    }
  }
  validasi() {
    final form = keyform.currentState;
    if (form!.validate()) {
      form.save();
      editInfoKantor(idKantor);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    email = GetStorage().read(AppVariabel.email);
    super.onInit();

  }
}