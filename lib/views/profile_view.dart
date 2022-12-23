import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_tv/controllers/profile_controller.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState ==  ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return const Center(child: Text("Something Was Wrong!"),);
          }else if(snapshot.hasData){
            final userData = FirebaseAuth.instance.currentUser!;
            return
              Stack(
                children: [
                   Container(
                     width: size.width,
                     child: Image.asset("assets/bg.jpeg",fit: BoxFit.cover),
                   ),
                  Positioned(
                      top: 100,
                      left: 5,
                      width: size.width-10,
                      child: ItemProfile(userData.displayName.toString(),userData.email.toString(),userData.photoURL.toString())
                  ),
                ],
              );

          }else{
            return const Center(
              child:
                  Icon(Icons.error),
            );
          }
        },
      ),
    );
  }
}

class ItemProfile extends StatelessWidget {
  final String name;
  final String email;
  final String image;
  const ItemProfile(this.name,this.email,this.image);

  @override
  Widget build(BuildContext context) {
    final profileC = Get.put(ProfileController());
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: size.height/ 1.8,
          decoration: const BoxDecoration(
              borderRadius:  BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow:[
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 1,
                    spreadRadius: 1.1,
                    offset: Offset(0,3)
                )
              ]
          ),
          child: StreamBuilder<List<DataKantor>>(
            stream: profileC.getDataKantor(),
            builder: (context, snapshot){
              if(snapshot.hasError){
                print(snapshot.error);
                return
                  Column(
                    children: [
                      Expanded(child: Container()),
                      const Icon(Icons.error),
                      const Text("ERROR"),
                      Expanded(child: Container()),
                    ],
                  );
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return
                  Column(
                    children: [
                      Expanded(child: Container()),
                      const CircularProgressIndicator(),
                      // const Text("ERROR"),
                      Expanded(child: Container()),
                    ],
                  );
              }else if(snapshot.data!.isEmpty){
                return
                  Column(
                    children: [
                      Expanded(child: Container()),
                      const Icon(Icons.account_circle),
                      const Text("Empty"),
                      Expanded(child: Container()),
                    ],
                  );
              }else{
                final data = snapshot.data!;
                return
                ListView(
                  children: List.generate(data.length, (index) => Container(
                    // color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                profileC.idKantor = data[index].id;
                                profileC.imgNameOld = data[index].nameImage;
                                profileC.cekKoneksi();
                              },
                              child: ClipOval(
                                child:data[index].image!="logo"?
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: CachedNetworkImage(
                                    imageUrl: data[index].image,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(
                                          child: ImagesLoading(),
                                        ),
                                    fit: BoxFit.cover,
                                    width: size.width,
                                  ),
                                ):
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(
                                          child: ImagesLoading(),
                                        ),
                                    fit: BoxFit.cover,
                                    width: size.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text("${name.toCapitalized()}",),
                          Text("$email"),
                          Divider(),
                          Container(
                            width: size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text("Nama Kantor",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(data[index].namaKantor.toTitleCase(),style: TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(data[index].namaKantor2.toTitleCase(),style: TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Text("Alamat",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(data[index].alamat.toTitleCase(),style: TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Text("Tampilan",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text("Template ${data[index].template}",style: TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                IconButton(
                                    onPressed: (){
                                      profileC.namaKantor.text = data[index].namaKantor;
                                      profileC.namaKantor2.text = data[index].namaKantor2;
                                      profileC.alamat.text = data[index].alamat;
                                      profileC.teksBerjalan.text = data[index].textBerjalan;
                                      profileC.idKantor = data[index].id;
                                      profileC.template.value = data[index].template;
                                      profileC.cekKoneksi2();

                                    },
                                    icon: FaIcon(FontAwesomeIcons.edit,color: Colors.blue,)
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  )),
                );
              }
            },
          )
      ),
    );
  }
}
