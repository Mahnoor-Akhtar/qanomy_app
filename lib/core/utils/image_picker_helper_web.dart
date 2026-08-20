import 'dart:async';
import 'dart:html' as html;
import 'image_picker_helper.dart';

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

Future<PickedDocument?> pickDocumentImpl() async {
  final completer = Completer<PickedDocument?>();
  final uploadInput = html.FileUploadInputElement()..accept = '*/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        completer.complete(PickedDocument(
          name: file.name,
          size: file.size,
          bytes: reader.result as List<int>,
        ));
      });
    } else {
      completer.complete(null);
    }
  });

  return completer.future;
}
