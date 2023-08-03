import 'dart:convert';

import 'dart:typed_data';

/// Class used to return informations retrieved from an image or video.
class MediaInfo {
  MediaInfo({
    this.fileName,
    this.base64,
    this.base64WithScheme,
    this.data,
  });

  /// Factory constructor to generate [MediaInfo] from a [Map].
  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final dataScheme = json['data_scheme'];
    final data = json['data'];

    if (name is! String? || dataScheme is! String? || data is! String?) {
      throw const FormatException('Invalid media info format');
    }

    return MediaInfo(
      fileName: name,
      base64: data,
      base64WithScheme: dataScheme,
      data: data != null ? base64Decode(data) : null,
    );
  }

  /// Name of the file.
  final String? fileName;

  /// File's data to Base64.
  final String? base64;

  /// File's data to Base64WithScheme.
  final String? base64WithScheme;

  /// File's bytes data.
  final Uint8List? data;

  /// Convert [MediaInfo] to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': fileName,
      'data': base64,
      'data_scheme': base64WithScheme,
    };
  }
}

/// Image's type.
enum ImageType { file, bytes, widget }

/// Video's type.
enum VideoType { file, bytes }
