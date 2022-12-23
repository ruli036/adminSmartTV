import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smart_tv/controllers/home_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_tv/controllers/img_controller.dart';
import 'package:smart_tv/controllers/profile_controller.dart';
import 'package:smart_tv/controllers/video_controller.dart';

class ImagesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey.shade300,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              height: 130,
              width: 130,
              // margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(height: 8,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       height: 8,
          //       width: 8,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey
          //       ),
          //     ),
          //     SizedBox(width: 3,),
          //     Container(
          //       height: 8,
          //       width: 8,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey
          //       ),
          //     ),
          //     SizedBox(width: 3,),
          //     Container(
          //       height: 8,
          //       width: 8,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey
          //       ),
          //     ),
          //     SizedBox(width: 3,),
          //     Container(
          //       height: 8,
          //       width: 8,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey
          //       ),
          //     ),
          //     SizedBox(width: 3,),
          //     Container(
          //       height: 8,
          //       width: 8,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey
          //       ),
          //     ),
          //     SizedBox(width: 3,),
          //   ],
          // )
        ],
      ),
    );
  }
}
class ImagesLoading2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey.shade300,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 100,
            // margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
                color: Colors.grey,
                // borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgresUploudVideo extends StatelessWidget {
  String message;
  ProgresUploudVideo({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videoC = Get.find<VideoController>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Obx(()=>Column(
            children: [
              LinearProgressIndicator(
                value: videoC.uploudProgres.value /100,backgroundColor: Colors.grey,
              ),
              Text("${videoC.displayProgres.value} %"),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
class ProgresUploudImage extends StatelessWidget {
  String message;
  ProgresUploudImage({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageC = Get.find<ImagesController>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Obx(()=>Column(
            children: [
              LinearProgressIndicator(
                value: imageC.uploudProgres.value /100,backgroundColor: Colors.grey,
              ),
              Text("${imageC.displayProgres.value} %"),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
class ProgresUploudImageProfile extends StatelessWidget {
  String message;
  ProgresUploudImageProfile({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileC = Get.find<ProfileController>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Obx(()=>Column(
            children: [
              LinearProgressIndicator(
                value: profileC.uploudProgres.value /100,backgroundColor: Colors.grey,
              ),
              Text("${profileC.displayProgres.value} %"),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
class PlayVideo extends StatelessWidget {
  const PlayVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final videoC = Get.find<VideoController>();
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()=>videoC.closeVideo(),
      child: Obx(()=>
        Container(
          height: size.height / 2.5,
          child: !videoC.playVideo.value?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const[
              CircularProgressIndicator(),
              Text("Loading...",style: TextStyle(color: Colors.white),),
            ],
          ):
          Chewie(controller:videoC.chewieController! ),
        ),
      ),
    );
  }
}

const List<String> list = <String>['slide 1', 'slide 2'];
const List<String> screen = <String>['default', 'full'];
const List<String> template = <String>['1', '2', '3'];
class FormAddImage extends StatelessWidget {
  const FormAddImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    final ImageC = Get.find<ImagesController>();
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: ImageC.keyform,
          child: Column(
            children: [
             TextFormField(
                  controller: ImageC.judulIklan,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return 'Title Requaired';
                    }
                  },
                  decoration:const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder()
                  ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                      child:Obx(()=>
                          Container(
                            width: size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: ImageC.slideValue.value,
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? value) {
                                  ImageC.slideValue.value = value!;
                                },
                                items: list.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      )
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                    child:Obx(()=>
                        Container(
                          width: size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton<String>(
                              value: ImageC.screenValue.value,
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? value) {
                                ImageC.screenValue.value = value!;
                              },
                              items: screen.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("${value.toUpperCase()} SCREEN"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                 Expanded(
                    child: ImageC.imgSelect.value && ImageC.imgChange.value>0?Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: FileImage(ImageC.fileImageView!),
                          fit: BoxFit.contain
                        )
                      ),
                      child:
                      Center(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.image,color: Colors.blue,),
                          onPressed: (){
                            ImageC.getImage();
                          },
                        ),
                      ),
                    ):Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.image,color: Colors.blue,),
                          onPressed: (){
                            print("ok");
                            ImageC.getImage();
                          },
                        ),
                      ),
                    )
                ),
              ),
              keyboard!=0.0?Container():Container(
                width: size.width,
                child: ElevatedButton(
                    onPressed:(){
                      ImageC.validasi();
                    },
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        FaIcon(FontAwesomeIcons.upload),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Uploud New Image"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class FormEditImage extends StatelessWidget {
  const FormEditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    final ImageC = Get.find<ImagesController>();
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: ImageC.keyform,
          child: Column(
            children: [
              TextFormField(
                  controller: ImageC.judulIklan,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return 'Title Requaired';
                    }
                  },
                  decoration:const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder()
                  ),
                ),
              Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                      child:  Obx(()=>
                          Container(
                            width: size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: ImageC.slideValueOld.value,
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? value) {
                                  ImageC.slideValueOld.value = value!;
                                },
                                items: list.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                    child:Obx(()=>
                        Container(
                          width: size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton<String>(
                              value: ImageC.screenValueOld.value,
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? value) {
                                ImageC.screenValueOld.value = value!;
                              },
                              items: screen.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("${value.toUpperCase()} SCREEN"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                 Expanded(
                    child: ImageC.imgSelect.value && ImageC.imgChange.value>0?Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: FileImage(ImageC.fileImageView!),
                          fit: BoxFit.contain
                        )
                      ),
                      child: Center(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.image,color: Colors.blue,),
                          onPressed: (){
                            ImageC.getImage();
                          },
                        ),
                      ),
                    ):Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.image,color: Colors.blue,),
                          onPressed: (){
                            print("ok");
                            ImageC.getImage();
                          },
                        ),
                      ),
                    )
                ),
              ),
              keyboard!=0.0?Container():Container(
                width: size.width,
                child: ElevatedButton(
                    onPressed:(){
                      ImageC.validasiEdit();
                    },
                    // style: ButtonStyle(w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        FaIcon(FontAwesomeIcons.images),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Save Change"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FormAddVideo extends StatelessWidget {
  const FormAddVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    final videoC = Get.find<VideoController>();
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: Colors.white,
      height: size.height /2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: videoC.keyform,
          child: Column(
            children: [
              TextFormField(
                controller: videoC.judulIklan,
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Title Requaired';
                  }
                },
                decoration:const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder()
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                      child:Obx(()=>
                          Container(
                            width: size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: videoC.slideValue.value,
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? value) {
                                  videoC.slideValue.value = value!;
                                },
                                items: list.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                      child:Obx(()=>
                          Container(
                            width: size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton<String>(
                                value: videoC.screenValue.value,
                                alignment: Alignment.centerRight,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? value) {
                                  videoC.screenValue.value = value!;
                                },
                                items: screen.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text("${value.toUpperCase()} SCREEN"),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Set Volume Video"),
                    Switch(
                      value: videoC.volume.value,
                      onChanged: (value) {
                        videoC.volume.value = value;
                        print(videoC.volume.value);
                      },
                      activeTrackColor: Colors.blue,
                      activeColor: Colors.indigo,
                    ),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                  Expanded(
                      child: videoC.videoSelect.value && videoC.videoChange.value>0?Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(videoC.infoFile),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.fileVideo,color: Colors.blue,),
                                  onPressed: (){
                                    print("ok");
                                    videoC.getVideo();
                                  },
                                ),
                              ],
                            )
                        )
                      ):Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.fileVideo,color: Colors.blue,),
                            onPressed: (){
                              print("ok");
                              videoC.getVideo();
                            },
                          ),
                        ),
                      )
                  ),
              ),
              keyboard!=0.0?Container():Container(
                width: size.width,
                child: ElevatedButton(
                    onPressed:(){
                      videoC.validasi();
                    },
                    // style: ButtonStyle(w),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        FaIcon(FontAwesomeIcons.upload),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Uploud New Video"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class FormEditVideo extends StatelessWidget {
  const FormEditVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    final videoC = Get.find<VideoController>();
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: Colors.white,
      height: size.height /2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: videoC.keyform,
          child: Column(
            children: [
              TextFormField(
                controller: videoC.judulIklan,
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Title Requaired';
                  }
                },
                decoration:const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder()
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Row(
                children: [
                  Expanded(
                    child:Obx(()=>
                        Container(
                          width: size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton<String>(
                              value: videoC.slideValueOld.value,
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? value) {
                                videoC.slideValueOld.value = value!;
                              },
                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Expanded(
                    child:Obx(()=>
                        Container(
                          width: size.width,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1,color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton<String>(
                              value: videoC.screenValueOld.value,
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (String? value) {
                                videoC.screenValueOld.value = value!;
                              },
                              items: screen.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text("${value.toUpperCase()} SCREEN"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Set Volume Video"),
                      Switch(
                        value: videoC.volume.value,
                        onChanged: (value) {
                          videoC.volume.value = value;
                          print(videoC.volume.value);
                        },
                        activeTrackColor: Colors.blue,
                        activeColor: Colors.indigo,
                      ),
                    ],
                  )
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                  Expanded(
                      child: videoC.videoSelect.value && videoC.videoChange.value>0?Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(videoC.infoFile),
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.fileVideo,color: Colors.blue,),
                                  onPressed: (){
                                    print("ok");
                                    videoC.getVideo();
                                  },
                                ),
                              ],
                            )
                        )
                      ):Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.fileVideo,color: Colors.blue,),
                            onPressed: (){
                              print("ok");
                              videoC.getVideo();
                            },
                          ),
                        ),
                      )
                  ),
              ),
              keyboard!=0.0?Container():Container(
                width: size.width,
                child: ElevatedButton(
                    onPressed:(){
                      videoC.validasiEdit();
                    },
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        FaIcon(FontAwesomeIcons.upload),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Save Change"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FormEditDataKantor extends StatelessWidget {
  const FormEditDataKantor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    final profileC = Get.find<ProfileController>();
    final size = MediaQuery.of(context).size;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      height: size.height /1.2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: profileC.keyform,
          child: Column(
            children: [
              TextFormField(
                controller: profileC.namaKantor,
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Title Requaired';
                  }
                },
                decoration:const InputDecoration(
                    labelText: "Office Title line 1 *",
                    border: OutlineInputBorder()
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextFormField(
                controller: profileC.namaKantor2,
                // validator: (e) {
                //   if (e!.isEmpty) {
                //     return 'Title line 2';
                //   }
                // },
                decoration:const InputDecoration(
                    labelText: "Office Title line 2",
                    border: OutlineInputBorder()
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextFormField(
                controller: profileC.alamat,
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Address Requaired';
                  }
                },
                decoration:const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder()
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Obx(()=>
                  Container(
                    width: size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton<String>(
                        value: profileC.template.value,
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? value) {
                          profileC.template.value = value!;
                        },
                        items: template.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text("Template ${value}"),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ),
              // Padding(padding: EdgeInsets.all(5)),
              // Expanded(
              //   child: TextFormField(
              //     controller: profileC.teksBerjalan,
              //     validator: (e) {
              //       if (e!.isEmpty) {
              //         return 'News Requaired';
              //       }
              //     },
              //     decoration:const InputDecoration(
              //         labelText: "News",
              //         // contentPadding: const EdgeInsets.only(top: value),
              //         border: OutlineInputBorder()
              //     ),
              //     maxLines: 5,
              //   ),
              // ),
              // Padding(padding: EdgeInsets.all(5)),
              Expanded(child: Container()),
               keyboard !=0.0?Container():Container(
                width: size.width,
                child: ElevatedButton(
                    onPressed:(){
                      profileC.validasi();
                    },
                    // style: ButtonStyle(w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:const [
                        FaIcon(FontAwesomeIcons.building),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Save"),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
