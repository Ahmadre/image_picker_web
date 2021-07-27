# ImagePickerWeb

[![Issues](https://img.shields.io/github/issues/Ahmadre/image_picker_web)](https://github.com/Ahmadre/image_picker_web/issues)
[![Stars](https://img.shields.io/github/stars/Ahmadre/image_picker_web)](https://github.com/Ahmadre/image_picker_web/stargazers)
[![Pub Version](https://img.shields.io/pub/v/image_picker_web?color=blue&logo=dart)](https://pub.dev/packages/image_picker_web)
[![Flutter Web CI](https://github.com/Ahmadre/image_picker_web/actions/workflows/dart.yml/badge.svg)](https://github.com/Ahmadre/image_picker_web/actions/workflows/dart.yml)

This Web-Plugin allows Flutter Web to pick images (as File, Widget or Uint8List) and videos (as File or Uint8List). Many thanks goes to [AlvaroVasconcelos](https://github.com/AlvaroVasconcelos) for the implementation of picking images in his plugin: [flutter_web_image_picker](https://github.com/AlvaroVasconcelos/flutter_web_image_picker) 

![ExampleGif](https://github.com/TesteurManiak/image_picker_web/blob/master/assets/exampleupload.gif)

### Disclaimer for Videos

* Till now [Mar. 2020] it's not possible (due to security reasons) to play a local video file (see also video_player_web). But you can retreive the file and upload them somewhere and play it as a network source.

## Getting Started

Add ` `  ` image_picker_web `  ` ` to your pubspec.yaml:

```yaml
    image_picker_web: any
```

## Picking Images

### Pick an image

Load Image as Image Widget:

```dart
    Image fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
```

Setting ` `  ` outputType `  `  ` to `  `  ` ImageType.bytes `  ` ` :

```dart
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.toString());
    }
```

Setting ` `  ` outputType `  `  ` to `  `  ` ImageType.file `  ` ` :

```dart
    html.File imageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (imageFile != null) {
      debugPrint(imageFile.name.toString());
    }
```

### Pick multiple images

Load Images as Image Widgets:

```dart
    List<Image> fromPicker = await ImagePickerWeb.getMultiImages(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() => pickedImages = fromPicker);
    }
```

Setting ` `  ` outputType `  `  ` to `  `  ` ImageType.bytes `  ` ` :

```dart
    List<Uint8List> bytesFromPicker =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      bytesFromPicker.forEach((bytes) => debugPrint(bytes.toString()));
    }
```

Setting ` `  ` outputType `  `  ` to `  `  ` ImageType.file `  ` ` :

```dart
    List<html.File> imageFiles =
        await ImagePickerWeb.getMultiImages(outputType: ImageType.file);

    if (imageFiles != null) {
      imageFiles.forEach((image) => debugPrint(image.name.toString()));
    }
```

## How do I get all Informations out of my Image/Video (e.g. Image AND File in one run)?

Besides the standard `getImage()` or `getVideo()` methods you can use the getters:
  + `getImageInfo` or
  + `getVideoInfo` to acheive this.

**Full Example**

```dart
import 'dart:html' as html;
 
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';

 html.File _cloudFile;
 var _fileBytes;
 Image _imageWidget;
 
 Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    String mimeType = mime(Path.basename(mediaData.fileName));
    html.File mediaFile =
        new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    if (mediaFile != null) {
      setState(() {
        _cloudFile = mediaFile;
        _fileBytes = mediaData.data;
        _imageWidget = Image.memory(mediaData.data);
      });
    }
  }
```

With `getMultipleImageInfos()` you can get all three available types in one call.

## Picking Videos

To load a video as html. File do:

```dart
    html.File videoFile = await ImagePickerWeb.getVideo(outputType: VideoType.file);

    debugPrint('---Picked Video File---');
    debugPrint(videoFile.name.toString());
```

To load a video as Uint8List do:

```dart
    Uint8List videoData = await ImagePickerWeb.getVideo(outputType: VideoType.bytes);

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoData.toString());
```

Reminder: Don't use Uint8List retreivement for big video files! Flutter can't handle that. Pick bigger sized videos and high-resolution videos as html. File!

After you uploaded your video somewhere hosted, you can retreive the network url to play it. 

### MediaInfos

* The methods ```getVideoInfo``` and ```getImageInfo``` are also available and you can use them to retreive further informations about your picked source.
