import 'package:get/get.dart';
import 'package:smart_tv/bindings.dart';
import 'package:smart_tv/main.dart';
import 'package:smart_tv/views/home_views.dart';
import 'package:smart_tv/views/login_view.dart';

final List<GetPage<dynamic>> route = [
  GetPage(name: '/login', page:()=> const LoginView(), binding: LoginBindings()),
  GetPage(name: '/home', page:()=> const HomeView(), binding: HomeBindings()),

];