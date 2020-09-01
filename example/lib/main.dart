import 'package:flutter/material.dart';
import 'package:flutter_web_video_player/flutter_web_video_player.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Image> pickedImages = [];
  String videoSRC;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImage() async {
    /// You can set the parameter asUint8List to true
    /// to get only the bytes from the image
    /* Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.toString());
    } */

    /// Default behavior would be getting the Image.memory
    Image fromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        pickedImages.clear();
        pickedImages.add(fromPicker);
      });
    }
  }

  Future<void> pickVideo() async {
    final videoMetaData =
        await ImagePickerWeb.getVideo(outputType: VideoType.bytes);

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoMetaData.toString());

    /// >>> Upload your video in Bytes now to any backend <<<
    /// >>> Disclaimer: local files are not working till now! [February 2020] <<<

    if (videoMetaData != null) {
      setState(() {
        videoSRC =
            'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
      });
    }
  }

  Future<void> pickMultiImages() async {
    List<Image> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.widget);
    setState(() {
      pickedImages.clear();
      pickedImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Web Example'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: SizedBox(
                      width: 500,
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              pickedImages == null ? 0 : pickedImages.length,
                          itemBuilder: (context, index) => pickedImages[index]),
                    ),
                  ),
                  const SizedBox(width: 15),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: videoSRC != null
                        ? Container(
                            constraints: const BoxConstraints(
                                maxHeight: 200, maxWidth: 200),
                            width: 200,
                            child: const WebVideoPlayer(
                                src: 'someNetworkSRC', controls: true))
                        : Container(),
                  )
                ],
              ),
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                RaisedButton(
                  onPressed: pickImage,
                  child: const Text('Select Image'),
                ),
                RaisedButton(
                  onPressed: pickVideo,
                  child: const Text('Select Video'),
                ),
                RaisedButton(
                  onPressed: pickMultiImages,
                  child: const Text('Select Multi Images'),
                )
              ]),
            ])),
      ),
    );
  }
}
