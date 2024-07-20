import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:video_player/video_player.dart';

class BigVideoUploadView extends StatefulWidget {
  const BigVideoUploadView({Key? key}) : super(key: key);

  @override
  State<BigVideoUploadView> createState() => _BigVideoUploadViewState();
}

class _BigVideoUploadViewState extends State<BigVideoUploadView> {
  VideoPlayerController? _controller;

  Future<void> _createVideo(Uint8List bytes) async {
    final blob = web.Blob(bytes.map((int byte) => byte.toJS).toList().toJS);
    final url = web.URL.createObjectURL(blob);
    // final url = html.Url.createObjectUrlFromBlob(blob);
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await _controller?.initialize();
    setState(() {});
  }

  Future<Uint8List> _load(web.File file) async {
    final reader = web.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;
    reader.onLoadEnd;
    return reader.result as Uint8List;
  }

  Future<void> _pickAndLoadVideo() async {
    final file = await ImagePickerWeb.getVideoAsFile();
    if (file != null) {
      final bytes = await _load(file);
      await _createVideo(bytes);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Big Video Upload')),
      floatingActionButton: controller != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
              child: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (controller != null && controller.value.isInitialized)
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ElevatedButton(
              onPressed: _pickAndLoadVideo,
              child: Text('Load Video with FileReader'),
            ),
          ],
        ),
      ),
    );
  }
}
