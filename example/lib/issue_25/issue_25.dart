import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class Issue25View extends StatefulWidget {
  const Issue25View({super.key});

  @override
  State<Issue25View> createState() => _Issue25ViewState();
}

class _Issue25ViewState extends State<Issue25View> {
  bool _isLoading = false;
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    final pickedFile = await ImagePickerWeb.getImageAsBytes();

    // function below does not execute when
    // using the back button on the mobile device
    setState(() {
      if (pickedFile != null) _imageBytes = pickedFile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue #25')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick image'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_imageBytes case final imageBytes?)
              Image.memory(
                imageBytes,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
