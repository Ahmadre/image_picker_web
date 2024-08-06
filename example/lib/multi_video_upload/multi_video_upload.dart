import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

class MultiVideoUploadView extends StatefulWidget {
  const MultiVideoUploadView({super.key});

  @override
  State<MultiVideoUploadView> createState() => _MultiVideoUploadViewState();
}

class _MultiVideoUploadViewState extends State<MultiVideoUploadView> {
  final _controllers = <VideoPlayerController>[];

  Future<void> _createVideos(List<web.File> files) async {
    for (final file in files) {
      final String url = web.URL.createObjectURL(file);
      final VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      _controllers.add(controller);
    }
    setState(() {});
  }

  Future<void> _pickAndLoadVideos() async {
    setState(_disposeControllers);
    final files = await ImagePickerWeb.getMultiVideosAsFile();
    if (files != null) {
      await _createVideos(files);
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
              child: const Text('Pick videos'),
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
