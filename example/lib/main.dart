import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _pickedImages = <Image>[];
  final _pickedVideos = <dynamic>[];

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
    if (videoMetaData != null)
      setState(() {
        _pickedVideos.clear();
        _pickedVideos.add(videoMetaData);
      });
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
    setState(() {
      _pickedImages.clear();
      _pickedImages.add(Image.memory(
        infos.data,
        semanticLabel: infos.fileName,
      ));
      _imageInfo = '${infos.toJson()}';
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
              Wrap(
                // spacing: 15.0,
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
                  Container(
                    height: 200,
                    width: 200,
                    child: Text(_imageInfo, overflow: TextOverflow.ellipsis),
                  ),
                  ..._pickedVideos
                      .map<Widget>((e) => Text(
                            e.toString(),
                            overflow: TextOverflow.ellipsis,
                          ))
                      .toList(),
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
