import 'dart:typed_data';

class MediaInfo {
  String fileName;
  String base64;
  String base64WithScheme;
  Uint8List data;
}

enum ImageType {
  file,
  bytes,
  widget
}

enum VideoType {
  file,
  bytes
}