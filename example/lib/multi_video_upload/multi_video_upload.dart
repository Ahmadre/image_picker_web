import 'package:web/web.dart' as web;

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:video_player/video_player.dart';

class MultiVideoUploadView extends StatefulWidget {
  const MultiVideoUploadView({super.key});

  @override
  State<MultiVideoUploadView> createState() => _MultiVideoUploadViewState();
}

class _MultiVideoUploadViewState extends State<MultiVideoUploadView> {
  final _controllers = <VideoPlayerController>[];

  Future<void> _createVideos(List<web.File> bytesList) async {
    for (final bytes in bytesList) {
      // final blob = web.Blob(bytes.map((int byte) => byte.toJS).toList().toJS);
      final url = web.URL.createObjectURL(bytes);
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      _controllers.add(controller);
    }
    setState(() {});
  }

  Future<web.File> _load(web.File file) async {
    // final reader = web.FileReader();
    // reader.readAsArrayBuffer(file);
    // await reader.onLoadEnd.first;
    // // await reader.onLoad.first;
    // reader.onLoadEnd;

    // return reader.result as JSArrayBuffer;
    return file;
  }

  Future<void> _pickAndLoadVideos() async {
    setState(_disposeControllers);
    final files = await ImagePickerWeb.getMultiVideosAsFile();
    if (files != null) {
      final bytesList = await Future.wait(files.map(_load));
      await _createVideos(bytesList);
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Big Video Upload')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final controller in _controllers)
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ElevatedButton(
              onPressed: _pickAndLoadVideos,
              child: Text('Pick videos'),
            ),
          ],
        ),
      ),
    );
  }

  void _disposeControllers() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
