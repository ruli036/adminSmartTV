import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_tv/controllers/video_controller.dart';
import 'package:smart_tv/widgets/variabel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Setting{
  static const String edit  = 'Edit';
  static const String hapus  = 'Hapus';

  static const List<String> Pilih = <String>[
    edit,hapus
  ];
}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
class AppAlert {

  static getAlert( String? title, String message, onPressed) {
    return  Get.defaultDialog(
      title: title??"INFO",
      textConfirm: 'OK',
      buttonColor: Colors.blue,
      confirmTextColor: Colors.white,
      onConfirm: onPressed,
      content: Text(message,textAlign: TextAlign.center,),
    );
  }
  static getAlertConnectionLost( String? title, String message, onPressed) {
    return  Get.defaultDialog(
      title: title??"INFO",
      textConfirm: 'Close',
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
      onConfirm: onPressed,
      content: Text(message),
    );
  }
  static getAlertHapus(String? title, String message, onPressed) {
    return  Get.defaultDialog(
      title: title??"INFO",
      textConfirm: 'Yes',
      textCancel: 'Close',
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
      onConfirm: onPressed,
      content: Text(message),
    );
  }
  static loading( String? title, String message,bool back) {
    return  Get.defaultDialog(
      barrierDismissible: false,
      title: title??"INFO",
      content: WillPopScope(
        onWillPop: () async => back,
        child: Column(
          children: [
            const CircularProgressIndicator(),
            Text(message),
          ],
        ),
      ),
    );
  }
  static getAlertUpdateApp( String? title, String message, onPressed) {
    return  Get.defaultDialog(
      title: title??"INFO",
      barrierDismissible: false,
      actions: [
        OutlinedButton(
            onPressed: onPressed,
            child: const Text("Update")
        ),
        OutlinedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.red)
            ),
            onPressed: ()=> SystemNavigator.pop(),
            child: const Text("Close")
        )
      ],
      content: WillPopScope(
          onWillPop: () async => false,
          child: Text(message)
      ),
    );
  }
}


class Helpes{
  static saveLogin(bool isLogin, String email,String name,idLogin,token){
    GetStorage().write(AppVariabel.isLogin, isLogin);
    GetStorage().write(AppVariabel.name, name);
    GetStorage().write(AppVariabel.email, email);
    GetStorage().write(AppVariabel.token, token);
    GetStorage().write(AppVariabel.indexLogin, idLogin);
  }
}





class UsersObject {
  String id;
  final String token;
  final String email;
  final String name;
  final String image;
  final bool isLogin;
  final DateTime date;
  final DateTime lastLogin;

  UsersObject({required this.id,required this.isLogin,required this.date,required this.lastLogin,required this.token,required this.name,required this.email,required this.image});

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'islogin' : isLogin,
    'token' : token,
    'email' : email,
    'name' : name,
    'image' : image,
    'date' : date,
    'lastlogin' : lastLogin
  };
  factory UsersObject.fromJson(Map<String, dynamic> json)=> UsersObject(
      id: json["id"]??'',
      isLogin: json["isLogin"]??false,
      date: (json["date"] as Timestamp).toDate(),
      lastLogin: (json["lastlogin"] as Timestamp).toDate(),
      token: json["token"]??"-",
      email: json["email"]??"-",
      name: json["name"]??"-",
      image: json["image"]??"-"
  );
}
class Images {
  String id;
  String nameImg;
  String image;
  String judul;
  String screen;
  String email;
  String numberSlide;
  DateTime date;
  DateTime lastupdate;

  Images({required this.id,required this.screen,required this.nameImg,required this.judul,required this.date,required this.email,required this.numberSlide,required this.lastupdate,required this.image});

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'name' : nameImg,
    'judul' : judul,
    'screen' : screen,
    'image' : image,
    'email' : email,
    'no_slide' : numberSlide,
    'date' : date,
    'last_update' : lastupdate
  };
  factory Images.fromJson(Map<String, dynamic> json)=> Images(
      id: json["id"]??'',
      nameImg: json["name"]??"-",
      judul: json["judul"]??"-",
      screen: json["screen"]??"default",
      image: json["image"]??"-",
      email: json["email"]??"-",
      numberSlide: json["no_slide"]??"-",
      date: (json["date"] as Timestamp).toDate(),
      lastupdate: (json["last_update"] as Timestamp).toDate(),
  );
}
class Videos {
  String id;
  String nameImg;
  String video;
  String judul;
  String screen;
  bool volume;
  String email;
  String numberSlide;
  DateTime date;
  DateTime lastupdate;

  Videos({required this.id,required this.nameImg,required this.screen,required this.volume,required this.judul,required this.date,required this.email,required this.numberSlide,required this.lastupdate,required this.video});

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'name' : nameImg,
    'judul' : judul,
    'volume' : volume,
    'screen' : screen,
    'video' : video,
    'email' : email,
    'no_slide' : numberSlide,
    'date' : date,
    'last_update' : lastupdate
  };
  factory Videos.fromJson(Map<String, dynamic> json)=> Videos(
      id: json["id"]??'',
      nameImg: json["name"]??"-",
      judul: json["judul"]??"-",
      screen: json["screen"]??"default",
      volume: json["volume"]??false,
      video: json["video"]??"-",
      email: json["email"]??"-",
      numberSlide: json["no_slide"]??"-",
      date: (json["date"] as Timestamp).toDate(),
      lastupdate: (json["last_update"] as Timestamp).toDate(),
  );
}
class DataKantor {
  String id;
  String namaKantor;
  String namaKantor2;
  String email;
  String alamat;
  String nameImage;
  String image;
  String template;
  String textBerjalan;
  DateTime date;
  DateTime lastupdate;

  DataKantor({required this.id,required this.email,required this.template,required this.namaKantor,required this.namaKantor2,required this.nameImage,required this.alamat,required this.textBerjalan,required this.date,required this.lastupdate,required this.image});

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'email' : email,
    'name_office' : namaKantor,
    'name_office2' : namaKantor2,
    'addreess' : alamat,
    'name_image' : nameImage,
    'image' : image,
    'template' : template,
    'run_text' : textBerjalan,
    'date' : date,
    'last_update' : lastupdate
  };
  factory DataKantor.fromJson(Map<String, dynamic> json)=> DataKantor(
      id: json["id"]??'',
      email: json["email"]??"-",
      namaKantor: json["name_office"]??"-",
      namaKantor2: json["name_office2"]??"-",
      alamat: json["addreess"]??"-",
      nameImage: json["name_image"]??"-",
      image: json["image"]??"-",
      template: json["template"]??"1",
      textBerjalan: json["run_text"]??"-",
      date: (json["date"] as Timestamp).toDate(),
      lastupdate: (json["last_update"] as Timestamp).toDate(),
  );
}

