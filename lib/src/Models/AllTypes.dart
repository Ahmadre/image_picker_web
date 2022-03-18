import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/widgets.dart';

class ImageAllTypes {
  ImageAllTypes(this.imageAsFile, this.imageAsImage, this.imageAsRaw);
  Image? imageAsImage;
  html.File? imageAsFile;
  Uint8List? imageAsRaw;

  Image? get image => imageAsImage;
  html.File? get htmlFmage => imageAsFile;
  Uint8List? get unit8List => imageAsRaw;
}
