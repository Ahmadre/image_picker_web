/// Class used to return informations retrieved from an image or video.
class MediaInfo {
  /// Name of the file.
  final String fileName;

  /// File's data to Base64.
  final String base64;

  /// File's data to Base64WithScheme.
  final String base64WithScheme;

  MediaInfo({this.fileName, this.base64, this.base64WithScheme});

  /// Factory constructor to generate [MediaInfo] from :
  ///
  /// ```dart
  /// await _methodChannel.invokeMapMethod<String, dynamic>('pickImage')
  /// ```
  factory MediaInfo.fromJson(Map<String, dynamic> json) => MediaInfo(
        fileName: json['name'],
        base64: json['data'],
        base64WithScheme: json['data_scheme'],
      );
}

/// Image's type.
enum ImageType { file, bytes, widget }

/// Video's type.
enum VideoType { file, bytes }
