import 'package:get/get.dart';
import 'package:smart_tv/controllers/home_controller.dart';
import 'package:smart_tv/controllers/login_controller.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LoginController());
   }
}
class HomeBindings extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => HomeController());
   }
}