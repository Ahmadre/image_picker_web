import 'dart:async';
import 'dart:html' as html;

class WebImagePicker {
  Future<Map<String, dynamic>?> pickImage() async {
    final data = <String, dynamic>{};
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();
    html.document.body!.append(input);
    await input.onChange.first;
    if (input.files!.isEmpty) return null;
    final reader = html.FileReader();
    reader.readAsDataUrl(input.files![0]);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    final stripped =
        encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final imageName = input.files?.first.name;
    data.addAll({'name': imageName, 'data': stripped, 'data_scheme': encoded});
    input.remove();
    return data;
  }

  Future<Map<String, dynamic>?> pickVideo() async {
    final data = <String, dynamic>{};
    final input = html.FileUploadInputElement();
    input.accept = 'video/*';
    input.click();
    html.document.body!.append(input);
    await input.onChange.first;
    if (input.files!.isEmpty) return null;
    final reader = html.FileReader();
    reader.readAsDataUrl(input.files![0]);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    final stripped =
        encoded.replaceFirst(RegExp(r'data:video/[^;]+;base64,'), '');
    final videoName = input.files?.first.name;
    data.addAll({'name': videoName, 'data': stripped, 'data_scheme': encoded});
    input.remove();
    return data;
  }
}
