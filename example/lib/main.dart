import 'package:flutter/material.dart';
import 'package:image_picker_web_example/big_video_upload/big_video_upload_view.dart';
import 'package:image_picker_web_example/photo_history/photo_history_add_view.dart';
import 'package:image_picker_web_example/sample/sample_page.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SamplePage())),
              child: Text('Sample 1'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PhotosHistoryAddPage())),
              child: Text('Photo History'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => BigVideoUploadView())),
              child: Text('Big Video Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
