library image_picker_web;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/web_image_picker.dart';
import 'src/bean/web_media_info.dart';

class ImagePickerWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel('image_picker_web',
        const StandardMethodCodec(), registrar.messenger);
    final instance = WebImagePicker();
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'pickImage':
          return await instance.pickImage();
        case 'pickVideo':
          return await instance.pickVideo();
        default:
          throw MissingPluginException();
      }
    });
  }

  static const MethodChannel _methodChannel =
      const MethodChannel('image_picker_web');

  static Future<dynamic> getImage({bool asUint8List = false}) async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
    final imageName = data['name'];
    final imageData = base64.decode(data['data']);
    if (asUint8List) {
      return imageData;
    }
    return Image.memory(imageData, semanticLabel: imageName);
  }

  static Future<MediaInfo> get getImageInfo async {
    final data =
    await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
    MediaInfo _webImageInfo = MediaInfo();
    _webImageInfo.fileName = data['name'];
    _webImageInfo.filePath = data['path'];
    _webImageInfo.base64 = data['data'];
    _webImageInfo.base64WithScheme = data['data_scheme'];
    _webImageInfo.data = base64.decode(data['data']);
    return _webImageInfo;
  }

  static Future<Uint8List> get getVideo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    final videoData = base64.decode(data['data']);
    return videoData;
  }

  static Future<MediaInfo> get getVideoInfo async {
    final data =
    await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    MediaInfo _webVideoInfo = MediaInfo();
    _webVideoInfo.fileName = data['name'];
    _webVideoInfo.filePath = data['path'];
    _webVideoInfo.base64 = data['data'];
    _webVideoInfo.base64WithScheme = data['data_scheme'];
    _webVideoInfo.data = base64.decode(data['data']);
    return _webVideoInfo;
  }
}
