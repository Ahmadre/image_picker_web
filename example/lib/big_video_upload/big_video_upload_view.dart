import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

class BigVideoUploadView extends StatefulWidget {
  const BigVideoUploadView({super.key});

  @override
  State<BigVideoUploadView> createState() => _BigVideoUploadViewState();
}

class _BigVideoUploadViewState extends State<BigVideoUploadView> {
  VideoPlayerController? _controller;

  Future<void> _createVideo(web.File file) async {
    final url = web.URL.createObjectURL(file);
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    await _controller?.initialize();
    setState(() {});
  }

  Future<void> _pickAndLoadVideo() async {
    final file = await ImagePickerWeb.getVideoAsFile();
    if (file != null) {
      await _createVideo(file);
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
          children: [
            if (controller != null && controller.value.isInitialized)
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ElevatedButton(
              onPressed: _pickAndLoadVideo,
              child: const Text('Load Video with FileReader'),
            ),
          ],
        ),
      ),
    );
  }
}
