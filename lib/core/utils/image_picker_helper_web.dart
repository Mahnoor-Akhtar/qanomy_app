import 'dart:async';
import 'dart:html' as html;

Future<List<int>?> pickImageImpl() async {
  final completer = Completer<List<int>?>();
  final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        completer.complete(reader.result as List<int>?);
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
