import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_tv/widgets/variabel.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:url_launcher/url_launcher_string.dart';
class LoginController extends GetxController{
  final timeZone = tz.getLocation('Asia/Jakarta');
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  RxBool isLogin = false.obs;
  RxString email = "".obs;
  String token ="";
  String indexLogin ="";
  var versions,url;
  String versionApp = '1.0';
  LoginStatus loginStatus = LoginStatus.notSignIn;

  Future getUserLogin()async{
    isLogin.value = GetStorage().read(AppVariabel.isLogin)??false;
    email.value = GetStorage().read(AppVariabel.email)??"";
    loginStatus = isLogin.value == true ?LoginStatus.signIn:LoginStatus.notSignIn;
    print(email.value);
  }
  Future cekKoneksi()async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        googleLogin();
      }
    } on SocketException catch (_) {
      AppAlert.getAlertConnectionLost("Connection Lost", "Please Check Your Connection Internet", () => Get.back());
    }
  }
  Future googleLogin()async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;
    AppAlert.loading("Loading", "Please Wait",false);
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    registerUser().then((value) {
      getUserLogin().then((value) {
        Get.back();
        Get.offAllNamed("/home");
      });
    });
  }

  Future<bool> isDuplicateUniqueEmail(String uniqueEmail) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: uniqueEmail)
        .get();
    return query.docs.isNotEmpty;
  }

  Future updateLoginUser(String uniqueEmail) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: uniqueEmail)
        .get();
    String id = query.docs.first.id.toString();
    final userLogin = FirebaseFirestore.instance.collection("users").doc(id);
    userLogin.update({
      'token': token,
      'islogin': true,
      'lastlogin':tz.TZDateTime.from(DateTime.now(), timeZone)
    });
  }

  Future registerUser()async {
    final userData = FirebaseAuth.instance.currentUser!;
    final firebaseUser = FirebaseFirestore.instance.collection('users').doc();
    Helpes.saveLogin(true, userData.email.toString(), userData.displayName.toString(),firebaseUser.id,token);
    String uniqEmail = userData.email.toString();

    if (await isDuplicateUniqueEmail(uniqEmail)) {
      print("user sudah terdaftar");
      updateLoginUser(uniqEmail);
    }else{
      final addUser = UsersObject(
        id: firebaseUser.id,
        isLogin: true,
        token: token,
        date: tz.TZDateTime.from(DateTime.now(), timeZone),
        lastLogin: tz.TZDateTime.from(DateTime.now(), timeZone),
        image: userData.photoURL.toString(),
        email: userData.email.toString(),
        name: userData.displayName.toString(),
      );
      final jsonUser = addUser.toJson();
      await firebaseUser.set(jsonUser).whenComplete(() => addKantor(uniqEmail));
    }
  }
  Future addKantor(email)async{
    final firebaseKantor = FirebaseFirestore.instance.collection('office').doc();

    final addKantor = DataKantor(
      id: firebaseKantor.id,
      email: email,
      nameImage: 'name Image',
      image: 'logo',
      alamat: "alamat",
      namaKantor: "nama kantor baris 1",
      namaKantor2: "nama kantor baris 2",
      template:'1',
      textBerjalan: "teks berjalan",
      date: tz.TZDateTime.from(DateTime.now(), timeZone),
      lastupdate: tz.TZDateTime.from(DateTime.now(), timeZone),

    );
    final jsonKantor = addKantor.toJson();
    await firebaseKantor.set(jsonKantor);
  }
  Future cekVersion()async{
    getUserLogin().whenComplete(() async{
      FirebaseFirestore.instance.collection('versions')
          .snapshots().listen(
              (data) {
            data.docs.forEach((element) {
              versions = element['admin_version'];
              url = element['admin_link'];
              print("----------------");
              print(versions);
              if(versionApp != element['admin_version']){
                AppAlert.getAlertUpdateApp("UPDATE APP", "New Version Already!!!", ()=>launchInBrowserUpdate() );
              }
            });
          }
      );
    });
  }
  Future<void> launchInBrowserUpdate() async {
    // if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
    // } else {
    //   throw 'Could not open the map.';
    // }
  }
   @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("CEK VESRION");
    cekVersion();
  }
}