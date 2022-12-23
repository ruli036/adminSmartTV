import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_tv/controllers/home_controller.dart';
import 'package:smart_tv/controllers/video_controller.dart';
import 'package:smart_tv/widgets/helpers.dart';
import 'package:smart_tv/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class DataVideosView extends StatelessWidget {
  const DataVideosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.put(HomeController());
    final videoC = Get.put(VideoController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration:const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.cover
          )
        ),
        child: StreamBuilder<List<Videos>>(
          stream: videoC.getDataVideos(),
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
                    const FaIcon(FontAwesomeIcons.video),
                    const Text("Video Empty"),
                    Expanded(child: Container()),
                  ],
                );

            }else{
              final videos = snapshot.data!;
              return
                NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      homeC.scrool(notification);
                      return true;
                    },
                    child: ItemVideos(videosData: videos));
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
              videoC.videoSelect.value = false;
              videoC.judulIklan.clear();
              videoC.fileVideo = null;
              videoC.cekKoneksi();
            },
            backgroundColor: const Color.fromRGBO(0,55,92,1),
            child: FaIcon(FontAwesomeIcons.add),
          ),
        ),
      ),
    );
  }
}


class ItemVideos extends StatelessWidget {
  final List<Videos> videosData;
  ItemVideos({Key? key, required this.videosData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videoC = Get.find<VideoController>();
    return ListView.builder(
      itemCount: videosData.length,
      itemBuilder: (context, index){
        return
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration:const  BoxDecoration(
                  borderRadius:  BorderRadius.all(Radius.circular(10)),
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
                onTap: ()async{
                  try{
                    videoC.volumePlay.value = videosData[index].volume;
                    videoC.getPlayVideo(videosData[index].video);
                    Get.defaultDialog(
                        barrierDismissible: false,
                        titleStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.black.withOpacity(0.4),
                        title: "Play Video",
                        content: PlayVideo()
                    );
                  }catch(error){
                    if(Get.isSnackbarOpen==true)return;
                    Get.snackbar("Connection Lost", "No Internet");
                  }
                },
                isThreeLine: true,
                title:Text(videosData[index].judul.toUpperCase(),style: const TextStyle(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,),
                leading: FaIcon(FontAwesomeIcons.fileVideo),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment : CrossAxisAlignment.start,
                    children: [
                      Text(videosData[index].numberSlide.toTitleCase(),style: const TextStyle(fontSize: 14),),
                      videosData[index].volume== true?
                      const Text("Volume Aktif",style: TextStyle(fontSize: 14),):
                      const Text("Volume Nonaktif",style: TextStyle(fontSize: 14),),
                      Text("${videosData[index].screen.toTitleCase()} Screen",style: const TextStyle(fontSize: 14),),
                    ],
                  ),
                ),
                trailing: PopupMenuButton(
                  onSelected: videoC.pilihAction,
                  itemBuilder: (BuildContext context) {
                    return Setting.Pilih.map((String pilih){
                      videoC.slideValueOld.value = videosData[index].numberSlide;
                      videoC.screenValueOld.value = videosData[index].screen;
                      videoC.videoURL = videosData[index].video;
                      videoC.videoID = videosData[index].id;
                      videoC.judulIklan.text = videosData[index].judul;
                      videoC.videoName = videosData[index].nameImg;
                      videoC.videoNameOld = videosData[index].nameImg;
                      videoC.volume.value = videosData[index].volume;
                      return PopupMenuItem<String>(
                        value: pilih,
                        child: Text(pilih),
                      );
                    }).toList();
                  },
                ),

              )
            ),
          );
      },
    );
  }
}