import 'dart:async';
import 'dart:html' as html;

import 'dart:typed_data';

typedef _ByteResult = FutureOr<List<int>>;

extension FileModifier on html.File {
  Future<Uint8List> asBytes() async {
    final bytesFile = Completer<List<int>>();
    final reader = html.FileReader();
    reader.onLoad.listen(
      (_) {
        final result = reader.result;
        if (result is! _ByteResult?) {
          bytesFile.completeError('Result is not a byte result');
          return;
        }

        bytesFile.complete(result);
      },
    );
    reader.readAsArrayBuffer(this);
    return Uint8List.fromList(await bytesFile.future);
  }
}
