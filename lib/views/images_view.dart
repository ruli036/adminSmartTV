import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_tv/controllers/home_controller.dart';
import 'package:smart_tv/controllers/img_controller.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/widgets.dart';

class DataImagesView extends StatelessWidget {
  const DataImagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.put(HomeController());
    final ImageC = Get.put(ImagesController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          decoration:const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.cover
              )
          ),
          child: StreamBuilder<List<Images>>(
            stream: ImageC.getDataImages(),
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
                  const Center(
                    child: CircularProgressIndicator(),
                  );
              }else if(snapshot.data!.isEmpty){
                return
                  Column(
                    children: [
                      Expanded(child: Container()),
                      const Icon(Icons.image),
                      const Text("Images Empty"),
                      Expanded(child: Container()),
                    ],
                  );

              }else{
                final images = snapshot.data!;
                return
                  NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        homeC.scrool(notification);
                        return true;
                      },
                      child: ItemImages(imagesData: images));
              }
            },
          ),
        ),
      floatingActionButton: SlideTransition(
        position: homeC.animation,
        child: SizedBox(
          height: 50,
          child: FloatingActionButton(
            onPressed: (){
              ImageC.imgSelect.value = false;
              ImageC.judulIklan.clear();
              ImageC.fileImage = null;
              ImageC.cekKoneksi();
            },
            backgroundColor: const Color.fromRGBO(0,55,92,1),
            child: const FaIcon(FontAwesomeIcons.add),
          ),
        ),
      ),
    );
  }
}


class ItemImages extends StatelessWidget {
  final List<Images> imagesData;
  ItemImages({Key? key, required this.imagesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImageC = Get.find<ImagesController>();
    final size = MediaQuery.of(context).size;
     return ListView.builder(
      itemCount: imagesData.length,
      itemBuilder: (context, index){
        return
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      boxShadow:[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 1,
                            spreadRadius: 1.1,
                            offset: Offset(0,3)
                        )
                      ]
                  ),
                  child: ListTile(
                    onTap: (){
                      print(imagesData[index].image);
                    },
                    title:Text(imagesData[index].judul.toUpperCase(),style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment : CrossAxisAlignment.start,
                        children: [
                          Text(imagesData[index].numberSlide.toTitleCase(),style: const TextStyle(fontSize: 14),),
                          Text('${imagesData[index].screen.toTitleCase()} Screen',style: const TextStyle(fontSize: 14),),
                        ],
                      ),
                    ),
                    isThreeLine: true,
                    leading:
                    Container(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: imagesData[index].image,
                         errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(
                              child: ImagesLoading2(),
                            ),
                        // fit: BoxFit.cover,
                      ),
                    ),
                    trailing: PopupMenuButton(
                      onSelected: ImageC.pilihAction,
                      itemBuilder: (BuildContext context) {
                        return Setting.Pilih.map((String pilih){
                          ImageC.slideValueOld.value = imagesData[index].numberSlide;
                          ImageC.screenValueOld.value = imagesData[index].screen;
                          ImageC.imageURL = imagesData[index].image;
                          ImageC.imageID = imagesData[index].id;
                          ImageC.judulIklan.text = imagesData[index].judul;
                          ImageC.imgName = imagesData[index].nameImg;
                          ImageC.imgNameOld = imagesData[index].nameImg;
                          return PopupMenuItem<String>(
                            value: pilih,
                            child: Text(pilih),
                          );
                        }).toList();
                      },
                    ),

                  ),
                ),
              );
      },
    );
  }
}
