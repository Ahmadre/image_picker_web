import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_web/src/models/media_info.dart';

void main() {
  group('MediaInfo', () {
    group('fromJson', () {
      test('parse full JSON', () {
        const validJson = {
          'name': 'name',
          'data': 'data',
          'data_scheme': 'data_scheme',
        };

        final mediaInfo = MediaInfo.fromJson(validJson);

        expect(mediaInfo.fileName, validJson['name']);
        expect(mediaInfo.base64, validJson['data']);
        expect(mediaInfo.base64WithScheme, validJson['data_scheme']);
      });

      test('parse partial JSON', () {
        const partialJson = {
          'name': 'name',
          'data': 'data',
        };

        final mediaInfo = MediaInfo.fromJson(partialJson);

        expect(mediaInfo.fileName, partialJson['name']);
        expect(mediaInfo.base64, partialJson['data']);
      });
    });
  });
}
