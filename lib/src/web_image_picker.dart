import 'dart:async';
import 'dart:html' as html;

class WebImagePicker {
  Future<Map<String, dynamic>?> pickImage() async {
    final data = <String, dynamic>{};
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    html.document.body?.append(input);

    await input.onChange.first;

    final files = input.files;
    if (files == null || files.isEmpty) return null;

    final reader = html.FileReader()..readAsDataUrl(files[0]);
    await reader.onLoad.first;

    final encoded = reader.result;
    if (encoded is! String) return null;

    final stripped =
        encoded.replaceFirst(RegExp('data:image/[^;]+;base64,'), '');
    final imageName = input.files?.first.name;

    data.addAll({'name': imageName, 'data': stripped, 'data_scheme': encoded});
    input.remove();

    return data;
  }

  Future<Map<String, dynamic>?> pickVideo() async {
    final data = <String, dynamic>{};
    final input = html.FileUploadInputElement()
      ..accept = 'video/*'
      ..click();

    html.document.body?.append(input);

    await input.onChange.first;

    final files = input.files;
    if (files == null || files.isEmpty) return null;

    final reader = html.FileReader()..readAsDataUrl(files[0]);
    await reader.onLoad.first;

    final encoded = reader.result;
    if (encoded is! String) return null;

    final stripped =
        encoded.replaceFirst(RegExp('data:video/[^;]+;base64,'), '');
    final videoName = input.files?.first.name;

    data.addAll({'name': videoName, 'data': stripped, 'data_scheme': encoded});
    input.remove();

    return data;
  }
}
