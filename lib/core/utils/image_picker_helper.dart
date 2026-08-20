import 'image_picker_helper_stub.dart'
    if (dart.library.html) 'image_picker_helper_web.dart';

class PickedDocument {
  final String name;
  final int size; // in bytes
  final List<int> bytes;
  PickedDocument({required this.name, required this.size, required this.bytes});
}

Future<List<int>?> pickImageFromDevice() => pickImageImpl();
Future<PickedDocument?> pickDocumentFromDevice() => pickDocumentImpl();
