import 'package:flutter/material.dart';
import 'package:image_picker_web_example/big_video_upload/big_video_upload_view.dart';
import 'package:image_picker_web_example/multi_video_upload/multi_video_upload.dart';
import 'package:image_picker_web_example/photo_history/photo_history_add_view.dart';
import 'package:image_picker_web_example/sample/sample_page.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: SeparatedColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          separator: SizedBox(height: 8),
          children: [
            _Button(
              label: 'Sample 1',
              page: SamplePage(),
            ),
            _Button(
              label: 'Photo History',
              page: PhotosHistoryAddPage(),
            ),
            _Button(
              label: 'Big Video Upload',
              page: BigVideoUploadView(),
            ),
            _Button(
              page: MultiVideoUploadView(),
              label: 'Upload Multi Videos',
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.page,
  });

  final String label;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Text(label),
    );
  }
}

class SeparatedColumn extends StatelessWidget {
  const SeparatedColumn({
    required this.separator,
    this.children = const [],
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final Widget separator;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  Iterable<Widget> _expandIndexed() sync* {
    for (var index = 0; index < children.length; index++) {
      yield children[index];
      if (index < children.length - 1) {
        yield separator;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: _expandIndexed().toList(),
    );
  }
}
