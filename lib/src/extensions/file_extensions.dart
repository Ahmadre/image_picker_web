import 'dart:async';
import 'dart:html' as html;

import 'dart:typed_data';

extension FileModifier on html.File {
  Future<Uint8List> asBytes() async {
    final Completer<List<int>> bytesFile = Completer<List<int>>();
    final html.FileReader reader = html.FileReader();
    reader.onLoad.listen((event) => bytesFile.complete(reader.result));
    reader.readAsArrayBuffer(this);
    return Uint8List.fromList(await bytesFile.future);
  }
}
