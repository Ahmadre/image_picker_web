import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MultiVideoUploadView extends StatefulWidget {
  const MultiVideoUploadView({super.key});

  @override
  State<MultiVideoUploadView> createState() => _MultiVideoUploadViewState();
}

class _MultiVideoUploadViewState extends State<MultiVideoUploadView> {
  final _controllers = <VideoPlayerController>[];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
