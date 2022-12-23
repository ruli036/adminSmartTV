import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_tv/controllers/login_controller.dart';
import 'package:smart_tv/views/home_views.dart';
import 'package:smart_tv/widgets/variabel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    switch (loginController.loginStatus){
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
              const Center(child: Text("Wellcome!",style: TextStyle(fontSize: 20),)),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: (){
                        loginController.cekKoneksi();
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: FaIcon(FontAwesomeIcons.google),
                          ),
                          Text("Login With Google")
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        );
      case LoginStatus.signIn:
           return HomeView();
    }

  }
}
