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

  /// Factory constructor to generate [MediaInfo] from [Map<String, dynamic>].
  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'name': final String? name,
          'base64': final String? base64,
          'data_scheme': final String? dataScheme,
          'data': final String data,
        }:
        return MediaInfo(
          fileName: name,
          base64: base64,
          base64WithScheme: dataScheme,
          data: base64Decode(data),
        );
      default:
        throw const FormatException('Invalid media info format');
    }
  }

  /// Name of the file.
  final String? fileName;

  /// File's data to Base64.
  final String? base64;

  /// File's data to Base64WithScheme.
  final String? base64WithScheme;

  /// File's bytes data.
  final Uint8List? data;

  /// Convert [MediaInfo] to [Map<String, dynamic>] format
  Map<String, dynamic> toJson() => {
        'name': fileName,
        'data': base64,
        'data_scheme': base64WithScheme,
      };
}

/// Image's type.
enum ImageType { file, bytes, widget }

/// Video's type.
enum VideoType { file, bytes }
