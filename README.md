# ImagePickerWeb

This Web-Plugin allows Flutter Web to pick images (as Widget or Uint8List) and videos (as Uint8List). Many thanks goes to [AlvaroVasconcelos](https://github.com/AlvaroVasconcelos) for the implementation of picking images in his plugin: [flutter_web_image_picker](https://github.com/AlvaroVasconcelos/flutter_web_image_picker) 

![ExampleGif](https://github.com/Ahmadre/image_picker_web/blob/master/assets/exampleupload.gif)

### Disclaimer for Videos
* Till now [Feb. 2020] it's not possible (due to security reasons) to load a local video file (see also video_player_web). But you can retreive the bytes and upload them somewhere and play it as a network source.

## Getting Started

Add ```image_picker_web``` to your pubspec.yaml:

```yaml
    image_picker_web: any
```

## Picking Images

To load an image do:

```dart
    Image fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.widget);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
```

You can also load only the bytes by setting ```asUint8List``` to ```true```:

```dart
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.toString());
    }
```

## Picking Videos

To load a video as html.File do:

```dart
    html.File videoFile = await ImagePickerWeb.getVideo(outputType: VideoType.file);

    debugPrint('---Picked Video File---');
    debugPrint((videoFile as html.File).name.toString());
```

To load a video as Uint8List do:

```dart
    Uint8List videoData = await ImagePickerWeb.getVideo(outputType: VideoType.bytes);

    debugPrint('---Picked Video Bytes---');
    debugPrint(videoData.toString());
```

After that you can upload your video somewhere hosted and retreive the network url to play it. 

### MediaInfos

* The methods ```getVideoInfo``` and ```getImageInfo``` are also available and you should use them to save the original fileName and mediaType.

## Support
Like my work? You can support me here:

<a href="https://www.buymeacoffee.com/wyXvWnH" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-green.png" alt="Buy Me A Coffee" width="200px"></a>