import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  XFile? _image;
  List<XFile>? _images;
  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _pickGalleryFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        // Append the picked files to the existing list of images
        _images!.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                width: 200,
                height: 200,
              )
            else
              Text('No image selected'),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: Text('Pick an image from gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
