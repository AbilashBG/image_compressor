import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File?> pickAndCompressImage(ImageSource source, {int quality = 20}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile == null) {
    return null;
  }

  final imageFile = File(pickedFile.path);
  final image = img.decodeImage(imageFile.readAsBytesSync());
  if (image == null) {
    return null;
  }

  final compressedImage = img.encodeJpg(image, quality: quality);
  final dir = await getTemporaryDirectory();
  final targetPath = path.join(dir.path, "compressed_${path.basename(imageFile.path)}");
  final compressedFile = File(targetPath)..writeAsBytesSync(compressedImage);

  return compressedFile;
}