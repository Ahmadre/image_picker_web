import 'dart:convert';

import 'dart:typed_data';

/// Class used to return informations retrieved from an image or video.
class MediaInfo {
  /// Name of the file.
  final String? fileName;

  /// File's data to Base64.
  final String? base64;

  /// File's data to Base64WithScheme.
  final String? base64WithScheme;

  /// File's bytes data.
  final Uint8List? data;

  MediaInfo({this.fileName, this.base64, this.base64WithScheme, this.data});

  /// Factory constructor to generate [MediaInfo] from [Map<String, dynamic>].
  factory MediaInfo.fromJson(Map<String, dynamic> json) => MediaInfo(
        fileName: json['name'],
        base64: json['data'],
        base64WithScheme: json['data_scheme'],
        data: base64Decode(json['data']),
      );

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
