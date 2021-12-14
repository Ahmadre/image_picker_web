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
        'image_picker_web', const StandardMethodCodec(), registrar);
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

  static const MethodChannel _methodChannel = MethodChannel('image_picker_web');

  static Future<html.File?> _pickFile(String type) async {
    final completer = Completer<List<html.File>?>();
    final input = html.FileUploadInputElement() as html.InputElement;
    input.accept = '$type/*';

    var changeEventTriggered = false;
    void changeEventListener(html.Event e) {
      if (changeEventTriggered) return;
      changeEventTriggered = true;

      final files = input.files!;
      final resultFuture = files.map<Future<html.File>>((file) async {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen(completer.completeError);
        return file;
      });
      Future.wait(resultFuture).then((results) => completer.complete(results));
    }

    // Cancel event management inspired by:
    // https://github.com/miguelpruivo/flutter_file_picker/blob/master/lib/src/file_picker_web.dart
    void cancelledEventListener(html.Event e) {
      html.window.removeEventListener('focus', cancelledEventListener);

      // This listener is called before the input changed event,
      // and the `uploadInput.files` value is still null
      // Wait for results from js to dart
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        if (!changeEventTriggered) {
          changeEventTriggered = true;
          completer.complete(null);
        }
      });
    }

    input.onChange.listen(changeEventListener);
    input.addEventListener('change', changeEventListener);

    // Listen focus event for cancelled
    html.window.addEventListener('focus', cancelledEventListener);

    input.click();

    // Need to append on mobile Safari.
    html.document.body!.append(input);

    final results = await completer.future;
    if (results == null || results.isEmpty) return null;
    return results.first;
  }

  /// source: https://stackoverflow.com/a/59420655/9942346
  Future<List<html.File>?> _pickMultiFiles(String type) async {
    final completer = Completer<List<html.File>?>();
    final input = html.FileUploadInputElement();
    input.multiple = true;
    input.accept = '$type/*';

    var changeEventTriggered = false;
    void changeEventListener(html.Event e) {
      if (changeEventTriggered) return;
      changeEventTriggered = true;

      final files = input.files!;
      final resultsFutures = files.map<Future<html.File>>((file) async {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen(completer.completeError);
        return file;
      });
      Future.wait(resultsFutures)
          .then((results) => completer.complete(results));
    }

    // Cancel event management inspired by:
    // https://github.com/miguelpruivo/flutter_file_picker/blob/master/lib/src/file_picker_web.dart
    void cancelledEventListener(html.Event e) {
      html.window.removeEventListener('focus', cancelledEventListener);

      // This listener is called before the input changed event,
      // and the `uploadInput.files` value is still null
      // Wait for results from js to dart
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        if (!changeEventTriggered) {
          changeEventTriggered = true;
          completer.complete(null);
        }
      });
    }

    input.onChange.listen(changeEventListener);
    input.addEventListener('change', changeEventListener);

    // Listen focus event for cancelled
    html.window.addEventListener('focus', cancelledEventListener);

    input.click();

    // Need to append on mobile Safari.
    html.document.body!.append(input);
    final results = await completer.future;
    if (results == null || results.isEmpty) return null;
    return results;
  }

  /// Picker that close after selecting 1 image. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// - [ImageType.file] return a [html.File] object of the selected image.
  ///
  /// - [ImageType.bytes] return a [Uint8List] of the selected image.
  ///
  /// - [ImageType.widget] return an [Image.memory] using the image's bytes.
  ///
  /// ```dart
  /// html.File? imgFile = await getImage(ImageType.file);
  /// Uint8List? imgBytes = await getImage(ImageType.bytes);
  /// Image? imgWidget = await getImage(ImageType.widget);
  /// ```
  @Deprecated(
    'Use [getImageAsBytes], [getImageAsWidget] or [getImageAsFile] instead.',
  )
  static Future<Object?> getImage({required ImageType outputType}) async {
    switch (outputType) {
      case ImageType.file:
        return getImageAsFile();
      case ImageType.bytes:
        return getImageAsBytes();
      case ImageType.widget:
        return getImageAsWidget();
    }
  }

  /// Picker that close after selecting 1 image and return a [Uint8List] of the
  /// selected image.
  static Future<Uint8List?> getImageAsBytes() async {
    final file = await ImagePickerWeb._pickFile('image');
    return file?.asBytes();
  }

  /// Picker that close after selecting 1 image and return an [Image.memory]
  /// using the image's bytes.
  static Future<Image?> getImageAsWidget() async {
    final file = await ImagePickerWeb._pickFile('image');
    return file != null
        ? Image.memory(await file.asBytes(), semanticLabel: file.name)
        : null;
  }

  /// Picker that close after selecting 1 image and return a [html.File] of the
  /// selected image.
  static Future<html.File?> getImageAsFile() {
    return ImagePickerWeb._pickFile('image');
  }

  /// Help to retrieve further image's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing image's informations.
  static Future<MediaInfo> get getImageInfo async {
    final data =
        await (_methodChannel.invokeMapMethod<String, dynamic>('pickImage'));
    return MediaInfo.fromJson(data!);
  }

  /// Picker that allows multi-image selection. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// - [ImageType.file] return a [html.File] list of the selected images.
  /// - [ImageType.bytes] return a [Uint8List] list of the selected images.
  /// - [ImageType.widget] return an [Image.memory] list using the images'
  /// bytes.
  ///
  /// ```dart
  /// List<html.File>? imgFiles = await getMultiImages(ImageType.file);
  /// List<Uint8List>? imgBytes = await getMultiImages(ImageType.bytes);
  /// List<Image>? imgWidgets = await getMultiImages(ImageType.widget);
  /// ```
  @Deprecated(
    'Use [getMultiImagesAsBytes], [getMultiImagesAsWidget] or '
    '[getMultiImagesAsFile] instead.',
  )
  static Future<List?> getMultiImages({required ImageType outputType}) async {
    switch (outputType) {
      case ImageType.file:
        return getMultiImagesAsFile();
      case ImageType.bytes:
        return getMultiImagesAsBytes();
      case ImageType.widget:
        return getMultiImagesAsWidget();
    }
  }

  /// Picker that allows multi-image selection and return a [Uint8List] list of
  /// the selected images.
  static Future<List<Uint8List>?> getMultiImagesAsBytes() async {
    final images = await ImagePickerWeb()._pickMultiFiles('image');
    if (images == null) return null;
    var files = <Uint8List>[];
    for (final img in images) {
      files.add(await img.asBytes());
    }
    return files.isEmpty ? null : files;
  }

  /// Picker that allows multi-image selection and return an [Image.memory] list
  /// using the images' bytes.
  static Future<List<Image>?> getMultiImagesAsWidget() async {
    final images = await ImagePickerWeb()._pickMultiFiles('image');
    if (images == null) return null;
    var files = <Uint8List>[];
    for (final img in images) {
      files.add(await img.asBytes());
    }
    if (files.isEmpty) return null;
    return files.map<Image>((e) => Image.memory(e)).toList();
  }

  /// Picker that allows multi-image selection and return a [html.File] list of
  /// the selected images.
  static Future<List<html.File>?> getMultiImagesAsFile() {
    return ImagePickerWeb()._pickMultiFiles('image');
  }

  /// Picker that close after selecting 1 video. Here are the different instance
  /// of Future returned depending on [outputType] :
  ///
  /// - [VideoType.file] return a [html.File] object of the selected video.
  ///
  /// - [VideoType.bytes] return a [Uint8List] of the selected video.
  ///
  /// ```dart
  /// html.File videoFile = await getVideo(VideoType.file);
  /// Uint8List videoBytes = await getVideo(VideoType.bytes);
  /// ```
  @Deprecated(
    'Use [getVideoAsBytes] or [getVideoAsFile] instead.',
  )
  static Future<dynamic> getVideo({required VideoType outputType}) async {
    switch (outputType) {
      case VideoType.file:
        return getImageAsFile();
      case VideoType.bytes:
        return getVideoAsBytes();
    }
  }

  /// Picker that close after selecting 1 video and return a [Uint8List] of the
  /// selected video.
  static Future<Uint8List?> getVideoAsBytes() async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    final imageData = base64.decode(data!['data']);
    return imageData;
  }

  /// Picker that close after selecting 1 video and return a [html.File] of the
  /// selected video.
  static Future<html.File?> getVideoAsFile() {
    return ImagePickerWeb._pickFile('video');
  }

  /// Help to retrieve further video's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing video's informations.
  static Future<MediaInfo> get getVideoInfo async {
    final data =
        await _methodChannel.invokeMapMethod<String, dynamic>('pickVideo');
    return MediaInfo.fromJson(data!);
  }
}
