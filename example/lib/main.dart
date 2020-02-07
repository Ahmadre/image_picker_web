import 'package:flutter/material.dart';

import 'package:flutter_web_video_player/flutter_web_video_player.dart';
import 'package:image_picker_web/image_picker_web.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Image pickedImage;
  String videoSRC;

  @override
  void initState() {
    super.initState();
  }

  pickImage() async {
    /// You can set the parameter asUint8List to true
    /// to get only the bytes from the image
    /* Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.toString());
    } */

    /// Default behavior would be getting the Image.memory
    Image fromPicker = await ImagePickerWeb.getImage();

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
  }

  pickVideo() async {
    final videoMetaData = await ImagePickerWeb.getVideo;

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoMetaData.toString());

    /// >>> Upload your video in Bytes now to any backend <<<
    /// >>> Disclaimer: local files are not working till now! [February 2020] <<<

    if (videoMetaData != null) {
      setState(() {
        videoSRC = 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
      });
    }
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
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: SizedBox(
                          width: 200,
                          child: pickedImage,
                        ) ??
                        Container(),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: videoSRC != null
                        ? Container(
                            constraints:
                                BoxConstraints(maxHeight: 200, maxWidth: 200),
                            width: 200,
                            child: WebVideoPlayer(
                                src: 'someNetworkSRC', controls: true))
                        : Container(),
                  )
                ],
              ),
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                RaisedButton(
                  onPressed: () => pickImage(),
                  child: Text('Select Image'),
                ),
                RaisedButton(
                  onPressed: () => pickVideo(),
                  child: Text('Select Video'),
                ),
              ]),
            ])),
      ),
    );
  }
}
