import 'package:image_picker/image_picker.dart';
import 'image_picker_helper.dart';

Future<List<int>?> pickImageImpl() async {
  try {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file.readAsBytes();
    }
  } catch (_) {}
  return null;
}

Future<PickedDocument?> pickDocumentImpl() async {
  try {
    final picker = ImagePicker();
    final XFile? file = await picker.pickMedia();
    if (file != null) {
      final bytes = await file.readAsBytes();
      return PickedDocument(
        name: file.name,
        size: bytes.length,
        bytes: bytes,
      );
    }
  } catch (_) {}
  return null;
}
