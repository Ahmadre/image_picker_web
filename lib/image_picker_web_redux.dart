library image_picker_web;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/Models/Types.dart';
import 'src/extensions/file_extensions.dart' show FileModifier;
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
          return instance.pickImage();
        case 'pickVideo':
          return instance.pickVideo();
        default:
          throw MissingPluginException();
      }
    });
  }

  static const MethodChannel _methodChannel =
      const MethodChannel('image_picker_web');

  static Future<html.File> _pickFile(String type) async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = '$type/*';
    input.click();
    html.document.body.append(input);
    await input.onChange.first;
    if (input.files.isEmpty) return null;
    return input.files[0];
  }

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

  /// Picker that close after selecting 1 image. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// * [ImageType.file] return a [html.File] object of the selected image.
  ///
  /// * [ImageType.bytes] return a [Uint8List] of the selected image.
  ///
  /// * [ImageType.widget] return an [Image.memory] using the image's bytes.
  ///
  /// ```dart
  /// html.File imgFile = await getImage(ImageType.file);
  /// Uint8List imgBytes = await getImage(ImageType.bytes);
  /// Image imgWidget = await getImage(ImageType.widget);
  /// ```
  static Future<dynamic> getImage({@required ImageType outputType}) async {
    assert(outputType != null);
    if (!(outputType is ImageType)) {
      throw ArgumentError(
          'outputType has to be from Type: ImageType if you call getImage()');
    }
    final file = await ImagePickerWeb._pickFile('image');
    if (file == null) return null;
    switch (outputType) {
      case ImageType.file:
        return file;
      case ImageType.bytes:
        return file.asBytes();
      case ImageType.widget:
        return Image.memory(await file.asBytes(), semanticLabel: file.name);
    }
  }

  /// Help to retrieve further image's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing image's informations.
  static Future<MediaInfo> get getImageInfo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickImage');
    return MediaInfo.fromJson(data);
  }

  // Picker allow multi-image selection. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// * [ImageType.file] return a [html.File] list of the selected images.
  ///
  /// * [ImageType.bytes] return a [Uint8List] list of the selected images.
  ///
  /// * [ImageType.widget] return an [Image.memory] list using the images'
  /// bytes.
  ///
  /// ```dart
  /// List<html.File> imgFiles = await getMultiImages(ImageType.file);
  /// List<Uint8List> imgBytes = await getMultiImages(ImageType.bytes);
  /// List<Image> imgWidgets = await getMultiImages(ImageType.widget);
  /// ```
  static Future<List> getMultiImages({@required ImageType outputType}) async {
    assert(outputType != null);
    if (!(outputType is ImageType)) {
      throw ArgumentError(
          'outputType has to be from Type: ImageType if you call getImage()');
    }
    final images = await ImagePickerWeb()._pickMultiFiles('image');
    if (images == null) return null;
    switch (outputType) {
      case ImageType.file:
        return images;
      case ImageType.bytes:
        List<Uint8List> files = [];
        for (final img in images) files.add(await img.asBytes());
        return files.isEmpty ? null : files;
      case ImageType.widget:
        List<Uint8List> files = [];
        for (final img in images) files.add(await img.asBytes());
        if (files.isEmpty) return null;
        return files.map<Image>((e) => Image.memory(e)).toList();
      default:
        return null;
    }
  }

  /// Picker that close after selecting 1 video. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// * [VideoType.file] return a [html.File] object of the selected video.
  ///
  /// * [VideoType.bytes] return a [Uint8List] of the selected video.
  ///
  /// ```dart
  /// html.File videoFile = await getVideo(VideoType.file);
  /// Uint8List videoBytes = await getVideo(VideoType.bytes);
  /// ```
  static Future<dynamic> getVideo({@required VideoType outputType}) async {
    assert(outputType != null);
    switch (outputType) {
      case VideoType.file:
        return ImagePickerWeb._pickFile('video');
      case VideoType.bytes:
        final data =
            await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
        final imageData = base64.decode(data['data']);
        return imageData;
      default:
        return null;
    }
  }

  /// Help to retrieve further video's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing video's informations.
  static Future<MediaInfo> get getVideoInfo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    return MediaInfo.fromJson(data);
  }
}
