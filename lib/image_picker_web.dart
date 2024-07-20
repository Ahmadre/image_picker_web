library image_picker_web;

import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_picker_web/src/models/media_info.dart';
// import 'dart:html' as html;
import 'package:web/web.dart' as web;

export 'src/models/media_info.dart';

/// Adds a `toList` method to [web.FileList] objects.
extension WebFileListToDartList on web.FileList {
  /// Converts a [web.FileList] into a [List] of [web.File].
  ///
  /// This method makes a copy.
  List<web.File> get toList =>
      <web.File>[for (int i = 0; i < length; i++) item(i)!];
}

class ImagePickerWeb {
  const ImagePickerWeb._();

  static void registerWith(Registrar registrar) {
    MethodChannel('image_picker_web', const StandardMethodCodec(), registrar)
        .setMethodCallHandler((call) {
      switch (call.method) {
        case 'pickImage':
          return getImageAsFile();
        case 'pickVideo':
          return getVideoAsFile();
        case 'pickMultiImage':
          return getMultiImagesAsFile();
        case 'pickMultiVideo':
          return getMultiVideosAsFile();
        case 'pickImageInfo':
          return getImageInfo();
        case 'pickVideoInfo':
          return getVideoInfo();
        default:
          throw MissingPluginException();
      }
    });
  }

  static Future<web.File?> _pickFile(String type) async {
    final completer = Completer<List<web.File>?>();

    final input = web.HTMLInputElement()
      ..accept = '$type/*'
      ..type = 'file';
    // final input = web.FileUploadInputElement()..accept = '$type/*';

    bool changeEventTriggered = false;
    void changeEventListener(web.Event e) {
      if (changeEventTriggered) return;
      changeEventTriggered = true;
      final web.FileList? files = input.files;
      if (files == null) return completer.complete(null);

      /// 生成迭代器
      final resultFuture = files.toList.map<Future<web.File>>((file) async {
        web.FileReader()
          ..readAsDataURL(file)
          ..addEventListener(
            'error',
            (JSAny event) {
              completer.completeError('Error reading file: $event');
            }.toJS,
          );
        // reader.onError.listen(completer.completeError);
        return file;
      });

      Future.wait(resultFuture).then(completer.complete);
    }

    // Cancel event management inspired by:
    // https://github.com/miguelpruivo/flutter_file_picker/blob/master/lib/src/file_picker_web.dart
    void cancelledEventListener(web.Event e) {
      web.window.removeEventListener('focus', cancelledEventListener.toJS);

      // This listener is called before the input changed event,
      // and the `uploadInput.files` value is still null
      // Wait for results from js to dart
      Future<void>.delayed(const Duration(milliseconds: 500)).whenComplete(() {
        if (!changeEventTriggered) {
          changeEventTriggered = true;
          completer.complete(null);
        }
      });
    }

    input.onChange.listen(changeEventListener);
    input.addEventListener('change', changeEventListener.toJS);

    // Listen focus event for cancelled
    web.window.addEventListener('focus', cancelledEventListener.toJS);

    input.click();

    // Need to append on mobile Safari.
    web.document.body?.append(input);

    final results = await completer.future;
    if (results == null || results.isEmpty) return null;
    return results.first;
  }

  static Future<Map<String, dynamic>?> _pickFileInfo(String type) async {
    final file = await ImagePickerWeb._pickFile(type);
    if (file == null) return null;
    final reader = web.FileReader()..readAsDataURL(file);
    // await reader.onLoad.first;
    await reader.onLoadEnd.first;
    final encoded = reader.result;
    if (encoded is! String) return null;
    // final dartEncoded = encoded;
    final stripped = (encoded! as String)
        .replaceFirst(RegExp('data:$type/[^;]+;base64,'), '');
    final fileName = file.name;
    return <String, dynamic>{
      'name': fileName,
      'data': stripped,
      'data_scheme': encoded,
    };
  }

  /// source: https://stackoverflow.com/a/59420655/9942346
  static Future<List<web.File>?> _pickMultiFiles(String type) async {
    final completer = Completer<List<web.File>?>();
    final input = web.HTMLInputElement()
      ..accept = '$type/*'
      ..type = 'file'
      ..multiple = true;

    var changeEventTriggered = false;
    void changeEventListener(web.Event e) {
      if (changeEventTriggered) return;
      changeEventTriggered = true;

      final web.FileList? files = input.files;
      if (files == null) return completer.complete(null);
      final resultsFutures = files.toList.map<Future<web.File>>((file) async {
        web.FileReader()
          ..readAsDataURL(file)
          ..addEventListener(
            'error',
            (JSAny event) {
              completer.completeError('Error reading file: $event');
            }.toJS,
          );

        // reader.onError.listen(completer.completeError);
        return file;
      });
      Future.wait(resultsFutures).then(completer.complete);
    }

    // Cancel event management inspired by:
    // https://github.com/miguelpruivo/flutter_file_picker/blob/master/lib/src/file_picker_web.dart
    void cancelledEventListener(web.Event e) {
      web.window.removeEventListener('focus', cancelledEventListener.toJS);

      // This listener is called before the input changed event,
      // and the `uploadInput.files` value is still null
      // Wait for results from js to dart
      Future<void>.delayed(const Duration(milliseconds: 500)).whenComplete(() {
        if (!changeEventTriggered) {
          changeEventTriggered = true;
          completer.complete(null);
        }
      });
    }

    input.onChange.listen(changeEventListener);
    input.addEventListener('change', changeEventListener.toJS);

    // Listen focus event for cancelled
    web.window.addEventListener('focus', cancelledEventListener.toJS);

    input.click();

    // Need to append on mobile Safari.
    web.document.body?.append(input);
    final results = await completer.future;
    if (results == null || results.isEmpty) return null;
    return results;
  }

  /// Picker that close after selecting 1 image and return a [Uint8List] of the
  /// selected image.
  static Future<Uint8List?> getImageAsBytes() async {
    final web.File? file = await ImagePickerWeb._pickFile('image');
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
  static Future<web.File?> getImageAsFile() {
    return ImagePickerWeb._pickFile('image');
  }

  /// Help to retrieve further image's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing image's informations.
  static Future<MediaInfo?> getImageInfo() async {
    final data = await _pickFileInfo('image');
    if (data == null) return null;
    return MediaInfo.fromJson(data);
  }

  /// Picker that allows multi-image selection and return a [Uint8List] list of
  /// the selected images.
  static Future<List<Uint8List>?> getMultiImagesAsBytes() async {
    final images = await _pickMultiFiles('image');
    if (images == null) return null;
    final files = <Uint8List>[];
    for (final img in images) {
      files.add(await img.asBytes());
    }
    return files.isEmpty ? null : files;
  }

  /// Picker that allows multi-image selection and return an [Image.memory] list
  /// using the images' bytes.
  static Future<List<Image>?> getMultiImagesAsWidget() async {
    final images = await _pickMultiFiles('image');
    if (images == null) return null;
    final files = <Uint8List>[];
    for (final img in images) {
      files.add(await img.asBytes());
    }
    if (files.isEmpty) return null;
    return files.map<Image>(Image.memory).toList();
  }

  /// Picker that allows multi-image selection and return a [html.File] list of
  /// the selected images.
  static Future<List<web.File>?> getMultiImagesAsFile() {
    return _pickMultiFiles('image');
  }

  /// Picker that close after selecting 1 video and return a [Uint8List] of the
  /// selected video.
  static Future<Uint8List?> getVideoAsBytes() async {
    final video = await _pickFile('video');
    return video?.asBytes();
  }

  /// Picker that close after selecting 1 video and return a [html.File] of the
  /// selected video.
  static Future<web.File?> getVideoAsFile() => _pickFile('video');

  /// Help to retrieve further video's informations about your picked source.
  ///
  /// Return an object [MediaInfo] containing video's informations.
  static Future<MediaInfo?> getVideoInfo() async {
    final data = await _pickFileInfo('video');
    if (data == null) return null;
    return MediaInfo.fromJson(data);
  }

  /// Picker that allows multi-video selection and return a [Uint8List] list of
  /// the selected videos.
  static Future<List<Uint8List>?> getMultiVideosAsBytes() async {
    final videos = await _pickMultiFiles('video');
    if (videos == null) return null;
    final files = <Uint8List>[];
    for (final video in videos) {
      files.add(await video.asBytes());
    }
    return files.isEmpty ? null : files;
  }

  /// Picker that allows multi-video selection and return a [web.File] list of
  /// the selected videos.
  static Future<List<web.File>?> getMultiVideosAsFile() {
    return _pickMultiFiles('video');
  }
}

// typedef _ByteResult = FutureOr<JSArray<JSNumber>>;
// typedef _ByteResult = FutureOr<JS>;

extension on web.File {
  Future<Uint8List> asBytes() async {
    final bytesFile = Completer<List<int>>();
    final reader = web.FileReader();
    reader
      ..addEventListener(
        'load',
        (JSAny event) {
          final result = reader.result;
          if (result is! ByteBuffer) {
            bytesFile.completeError('Result is not a byte result');
            return;
          }
          bytesFile.complete((result! as ByteBuffer).asUint8List());
        }.toJS,
      )
      // reader.onLoad.listen(
      //   (_) {
      //     final result = reader.result;
      //     if (result is! _ByteResult?) {
      //       bytesFile.completeError('Result is not a byte result');
      //       return;
      //     }

      //     bytesFile.complete(result);
      //   },
      // );
      ..readAsArrayBuffer(this);
    return Uint8List.fromList(await bytesFile.future);
  }
}
