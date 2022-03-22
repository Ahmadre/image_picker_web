import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:video_player/video_player.dart';

class BigVideoUploadView extends StatefulWidget {
  const BigVideoUploadView({Key key}) : super(key: key);

  @override
  State<BigVideoUploadView> createState() => _BigVideoUploadViewState();
}

class _BigVideoUploadViewState extends State<BigVideoUploadView> {
  VideoPlayerController _controller;

  Future<Uint8List> _loadImage(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    final timer = Stopwatch()..start();
    await reader.onLoad.first;
    timer.stop();
    print('Loaded in ${timer.elapsedMilliseconds}ms');
    return reader.result as Uint8List;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Big Video Upload')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller != null) {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }
        },
        child: Icon(
          _controller != null && _controller.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_controller != null && _controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ElevatedButton(
              onPressed: () async {
                final file = await ImagePickerWeb.getVideoAsFile();
                final bytes = await _loadImage(file);
                final blob = html.Blob([bytes]);
                final url = html.Url.createObjectUrlFromBlob(blob);
                _controller = VideoPlayerController.network(url);
                await _controller.initialize();
                setState(() {});
              },
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
