import 'dart:convert';
import 'dart:html' as html;

import 'dart:typed_data';

/// Class used to return informations retrieved from an image or video.
class MediaInfo {
  /// Name of the file.
  final String fileName;

  /// File's data to Base64.
  final String base64;

  /// File's data to Base64WithScheme.
  final String base64WithScheme;

  /// File's bytes data.
  final Uint8List bytes;

  MediaInfo({this.fileName, this.base64, this.base64WithScheme, this.bytes});

  /// Factory constructor to generate [MediaInfo] from [Map<String, dynamic>].
  factory MediaInfo.fromJson(Map<String, dynamic> json) => MediaInfo(
        fileName: json['name'],
        base64: json['data'],
        base64WithScheme: json['data_scheme'],
        bytes: base64Decode(json['data']),
      );

  /// Factory constructor to generate [MediaInfo] from [html.File] file and
  /// [Uint8List] bytes.
  factory MediaInfo.fromFile(html.File file, Uint8List bytes) => MediaInfo(
        fileName: file.name,
        base64: String.fromCharCodes(bytes),
        bytes: bytes,
      );
}

/// Image's type.
enum ImageType { file, bytes, widget, mediaInfo }

/// Video's type.
enum VideoType { file, bytes }
