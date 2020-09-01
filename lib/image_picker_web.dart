library image_picker_web;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/Models/Types.dart';
import 'src/web_image_picker.dart';

export 'src/Models/Types.dart';

class ImagePickerWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
        'image_picker_web', const StandardMethodCodec(), registrar.messenger);
    final instance = WebImagePicker();
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'pickImage':
          await instance.pickImage();
          break;
        case 'pickVideo':
          await instance.pickVideo();
          break;
        default:
          throw MissingPluginException();
      }
    });
  }

  static const MethodChannel _methodChannel =
      const MethodChannel('image_picker_web');

  Future<html.File> _pickFile(String type) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = '$type/*';
    input.click();
    await input.onChange.first;
    if (input.files.isEmpty) return null;
    return input.files[0];
  }

  ///
  /// source: https://stackoverflow.com/a/59420655/9942346
  Future<List<html.File>> _pickMultiFiles(String type) async {
    final completer = Completer<List<html.File>>();
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.multiple = true;
    input.accept = '$type/*';
    input.click();
    // onChange doesn't work on mobile safari.
    input.addEventListener('change', (e) async {
      final files = input.files;
      Iterable<Future<html.File>> resultsFutures = files.map((file) async {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen(completer.completeError);
        return file;
      });
      final results = await Future.wait(resultsFutures);
      completer.complete(results);
    });
    // Need to append on mobile Safari.
    html.document.body.append(input);
    final results = await completer.future;
    if (results.isEmpty) return null;
    return results;
  }

  static Future<dynamic> getImage({@required ImageType outputType}) async {
    assert(outputType != null);
    if (!(outputType is ImageType)) {
      throw ArgumentError(
          'outputType has to be from Type: ImageType if you call getImage()');
    }
    switch (outputType) {
      case ImageType.file:
        return ImagePickerWeb()._pickFile('image');
      case ImageType.bytes:
        final data =
            await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
        final imageData = base64.decode(data['data']);
        return imageData;
      case ImageType.widget:
        final data =
            await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
        final imageName = data['name'];
        final imageData = base64.decode(data['data']);
        return Image.memory(imageData, semanticLabel: imageName);
      default:
        return null;
    }
  }

  static Future<MediaInfo> get getImageInfo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
    MediaInfo _webImageInfo = MediaInfo();
    _webImageInfo.fileName = data['name'];
    _webImageInfo.base64 = data['data'];
    _webImageInfo.base64WithScheme = data['data_scheme'];
    _webImageInfo.data = base64.decode(data['data']);
    return _webImageInfo;
  }

  static Future<List> getMultiImages({@required ImageType outputType}) async {
    assert(outputType != null);
    if (!(outputType is ImageType)) {
      throw ArgumentError(
          'outputType has to be from Type: ImageType if you call getImage()');
    }
    switch (outputType) {
      case ImageType.file:
        return ImagePickerWeb()._pickMultiFiles('image');
      // case ImageType.bytes:
      // case ImageType.widget:
      default:
        return null;
    }
  }

  static Future<dynamic> getVideo({@required VideoType outputType}) async {
    if (!(outputType is VideoType)) {
      throw ArgumentError(
          'outputType has to be from Type: VideoType if you call getVideo()');
    }
    switch (outputType) {
      case VideoType.file:
        await ImagePickerWeb()._pickFile('video');
        break;
      case VideoType.bytes:
        final data =
            await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
        final imageData = base64.decode(data['data']);
        return imageData;
        break;
      default:
        return null;
        break;
    }
  }

  static Future<MediaInfo> get getVideoInfo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    MediaInfo _webVideoInfo = MediaInfo();
    _webVideoInfo.fileName = data['name'];
    _webVideoInfo.base64 = data['data'];
    _webVideoInfo.base64WithScheme = data['data_scheme'];
    _webVideoInfo.data = base64.decode(data['data']);
    return _webVideoInfo;
  }
}
