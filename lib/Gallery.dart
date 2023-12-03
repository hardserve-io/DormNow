import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'GalleryView.dart';

class GalleryChoiseWidget extends ConsumerStatefulWidget {
  const GalleryChoiseWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<GalleryChoiseWidget> {
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> files = [];
  List<String> urlImages = [
    'https://www.csc.knu.ua/filer/canonical/1501012402/208/',
  ]; // Add this list to store image URLs
  void openGallery(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          urlImages: urlImages,
        ),
      ));
  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      List<int> fileBytes = await pickedFile.readAsBytes();
      Uint8List uint8List = Uint8List.fromList(fileBytes);

      setState(() {
        files.add(PlatformFile(
          name: pickedFile.name,
          path: pickedFile.path,
          size: uint8List.length,
          bytes: uint8List,
        ));
        urlImages.add(pickedFile.path); // Add the image URL to the list
      });
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          files.add(result.files.first);
          urlImages
              .add(result.files.first.path!); // Add the image URL to the list
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _pickImageFromGallery,
                ),
                SizedBox(
                  width: 1.0,
                  height: 120.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return buildFile(file);
                    },
                  ),
                ),
                InkWell(
                  child: Ink.image(
                      image: NetworkImage(urlImages.first),
                      height: 200,
                      fit: BoxFit.cover),
                  onTap: () => openGallery(context),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file) {
    return Container(
      width: 100.0,
      color: Colors.transparent,
      child: Column(
        children: [
          (file.extension == 'jpg' || file.extension == 'png')
              ? Image.file(
                  File(file.path!),
                  width: 60.0,
                )
              : const SizedBox(
                  width: 80,
                  height: 80,
                ),
          SizedBox(
            height: 10.0,
          ),
          InkWell(
            child: const Icon(Icons.delete_outline),
            onTap: () {
              files.remove(file);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
