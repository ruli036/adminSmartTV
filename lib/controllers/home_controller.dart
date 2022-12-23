import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:smart_tv/views/images_view.dart';
import 'package:smart_tv/views/profile_view.dart';
import 'package:smart_tv/views/videos_view.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/variabel.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin{
  final getStorage = GetStorage();
  final googleSignIn = GoogleSignIn();
  late Animation<Offset> animation;
  late AnimationController animationController;
  final storage = GetStorage();
  var email;
  RxInt current = 0.obs;
  RxInt menuIndex = 0.obs;
   List<Widget> widgetOptions = <Widget>[
    const DataImagesView(),
    const DataVideosView(),
    const ProfileView()
  ];

  void onTapMenu(int index) {
    menuIndex.value = index;
  }
  scrool(notification){
    final ScrollDirection direction = notification.direction;
    if (direction == ScrollDirection.reverse) {
      animationController.forward();
    } else if (direction == ScrollDirection.forward) {
      animationController.reverse();
    }
    return true;
  }

  Future LogOut()async{
    AppAlert.loading("Log Out", "Please Wait",false);
    await googleSignIn.disconnect().whenComplete(() {
      FirebaseAuth.instance.signOut();
      getStorage.erase();
      Get.back();
      Get.offAllNamed("/login");
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    email = GetStorage().read(AppVariabel.email);
     super.onInit();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(end: Offset(0, 2), begin: Offset(0, 0))
        .animate(animationController);
  }

}