import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_web_video_player/flutter_web_video_player.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _pickedImages = <Image>[];

  String _videoSRC;
  String _imageInfo = '';

  Future<void> _pickImage() async {
    Image fromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        _pickedImages.clear();
        _pickedImages.add(fromPicker);
      });
    }
  }

  Future<void> _pickVideo() async {
    final videoMetaData =
        await ImagePickerWeb.getVideo(outputType: VideoType.bytes);

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoMetaData.toString());

    /// >>> Upload your video in Bytes now to any backend <<<
    /// >>> Disclaimer: local files are not working till now! [February 2020] <<<

    if (videoMetaData != null) {
      setState(() {
        _videoSRC =
            'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
      });
    }
  }

  Future<void> _pickMultiImages() async {
    List<Image> images =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.widget);
    setState(() {
      _pickedImages.clear();
      _pickedImages.addAll(images);
    });
  }

  Future<void> _getImgFile() async {
    html.File infos = await ImagePickerWeb.getImage(outputType: ImageType.file);
    setState(() => _imageInfo =
        'Name: ${infos.name}\nRelative Path: ${infos.relativePath}');
  }

  Future<void> _getImgInfo() async {
    final infos = await ImagePickerWeb.getImageInfo;
    setState(
        () => _imageInfo = 'Name: ${infos.fileName}\nBase64: ${infos.base64}');
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
                              _pickedImages == null ? 0 : _pickedImages.length,
                          itemBuilder: (context, index) =>
                              _pickedImages[index]),
                    ),
                  ),
                  const SizedBox(width: 15),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    child: _videoSRC != null
                        ? Container(
                            constraints: const BoxConstraints(
                                maxHeight: 200, maxWidth: 200),
                            width: 200,
                            child: const WebVideoPlayer(
                                src: 'someNetworkSRC', controls: true))
                        : Container(),
                  ),
                  const SizedBox(width: 15),
                  Text(_imageInfo),
                ],
              ),
              ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
                RaisedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                RaisedButton(
                  onPressed: _pickVideo,
                  child: const Text('Select Video'),
                ),
                RaisedButton(
                  onPressed: _pickMultiImages,
                  child: const Text('Select Multi Images'),
                ),
                RaisedButton(
                  onPressed: _getImgFile,
                  child: const Text('Get Image File'),
                ),
                RaisedButton(
                  onPressed: _getImgInfo,
                  child: const Text('Get Image Info'),
                ),
              ]),
            ])),
      ),
    );
  }
}
