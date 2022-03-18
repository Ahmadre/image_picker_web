import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ImageAllTypes {
  ImageAllTypes(this.imageAsFile, this.imageAsImage, this.imageAsRaw);
  Image? imageAsImage;
  html.File? imageAsFile;
  Uint8List? imageAsRaw;
}
