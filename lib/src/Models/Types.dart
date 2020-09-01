import 'dart:typed_data';

/// Class used to return informations retrieved from an image or video.
class MediaInfo {
  /// Name of the file.
  String fileName;

  /// File's data to Base64.
  String base64;

  /// File's data to Base64WithScheme.
  String base64WithScheme;

  /// File's bytes.
  Uint8List data;
}

/// Image's type.
enum ImageType { file, bytes, widget }

/// Video's type.
enum VideoType { file, bytes }
