import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_tv/controllers/home_controller.dart';
import 'package:smart_tv/controllers/img_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.put(HomeController());
    final ImageC = Get.put(ImagesController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Smart TV'),
        backgroundColor:const Color.fromRGBO(0,55,92,1),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOut,color: Colors.white,),
            onPressed: (){
              homeC.LogOut();
            },
          ),
        ],
      ),
      body:Obx(()=>
          homeC.widgetOptions.elementAt(homeC.menuIndex.value),
      ),
      bottomNavigationBar: Obx(()=>
          Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],

          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[500]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: const Color.fromRGBO(0,55,92,1),
                color: Colors.black54,
                tabs: const [
                  GButton(
                    // style: GnavStyle(),
                    icon: FontAwesomeIcons.images,
                    text: 'Images',
                   ),
                  GButton(
                    icon: FontAwesomeIcons.video,
                    text: 'Videos',
                  ),
                  GButton(
                    icon: FontAwesomeIcons.userCircle,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: homeC.menuIndex.value,
                onTabChange:homeC.onTapMenu
              ),
            ),
          ),
        ),
      ),
    );
  }
}
