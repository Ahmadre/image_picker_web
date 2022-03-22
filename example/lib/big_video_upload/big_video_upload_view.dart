import 'package:flutter/material.dart';

class BigVideoUploadView extends StatefulWidget {
  const BigVideoUploadView({Key key}) : super(key: key);

  @override
  State<BigVideoUploadView> createState() => _BigVideoUploadViewState();
}

class _BigVideoUploadViewState extends State<BigVideoUploadView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Big Video Upload')),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Upload Video'),
        ),
      ]),
    );
  }
}
