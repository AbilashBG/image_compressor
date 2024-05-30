import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_quality_compress/utils/image_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _originalImage;
  File? _compressedImage;
  double? _originalSize;
  double? _compressedSize;

  Future<void> _pickAndCompressImage(ImageSource source) async {
    final compressedFile = await pickAndCompressImage(source);
    if (compressedFile != null) {
      final originalFile = File(compressedFile.path.replaceFirst('compressed_', ''));
      setState(() {
        _originalImage = originalFile;
        _compressedImage = compressedFile;
        _originalSize = originalFile.lengthSync() / (1024 * 1024); // Size in MB
        _compressedSize = compressedFile.lengthSync() / (1024 * 1024); // Size in MB
      });
    }
  }

  void _showImage(BuildContext context, File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Zoom Image'),
          ),
          body: PhotoView(
            imageProvider: FileImage(imageFile),
          ),
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndCompressImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndCompressImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Image Pick & Compress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _originalImage == null
                ? Text('No image selected.')
                : Column(
              children: [
                Text('Original Image'),
                GestureDetector(
                  onTap: () => _showImage(context, _originalImage!),
                  child: Image.file(
                    _originalImage!,
                    height: 200,
                  ),
                ),
                Text('Original Size: ${_originalSize!.toStringAsFixed(2)} MB'),
              ],
            ),
            SizedBox(height: 20),
            _compressedImage == null
                ? Container()
                : Column(
              children: [
                Text('Compressed Image'),
                GestureDetector(
                  onTap: () => _showImage(context, _compressedImage!),
                  child: Image.file(
                    _compressedImage!,
                    height: 200,
                  ),
                ),
                Text('Compressed Size: ${_compressedSize!.toStringAsFixed(2)} MB'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceActionSheet(context),
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}