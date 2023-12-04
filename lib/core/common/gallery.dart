import 'dart:io';
import 'package:dormnow/core/common/gallery_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class GalleryChoiseWidget extends ConsumerStatefulWidget {
  final ValueChanged<List<String>> onImagesChanged;
  final List<String> previousImages;
  const GalleryChoiseWidget({super.key, required this.previousImages, required this.onImagesChanged});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<GalleryChoiseWidget> {
  final _formKey = GlobalKey<FormState>();
  //List<PlatformFile> files = [];
  List<String> urlImages = []; // Add this list to store image URLs
  void openGallery(BuildContext context) => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          urlImages: urlImages,
        ),
      ));

  @override
  void initState() {
    urlImages.addAll(widget.previousImages);
    super.initState();
  }

  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      //List<int> fileBytes = await pickedFile.readAsBytes();
      //Uint8List uint8List = Uint8List.fromList(fileBytes);

      setState(() {
        // files.add(PlatformFile(
        //   name: pickedFile.name,
        //   path: pickedFile.path,
        //   size: uint8List.length,
        //   bytes: uint8List,
        // ));
        urlImages.add(pickedFile.path); // Add the image URL to the list
      });
    } else {
      // FilePickerResult? result = await FilePicker.platform.pickFiles();

      // if (result != null) {
      //   setState(() {
      //     //files.add(result.files.first);
      //     urlImages.add(result.files.first.path!);
      //     // Add the image URL to the list
      //   });
      // }
      return;
    }
    //print(urlImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                urlImages.length < 10
                    ? IconButton(
                        iconSize: 30.h,
                        icon: const Icon(Icons.add),
                        onPressed: _pickImageFromGallery,
                      )
                    : SizedBox(
                        height: 50.h,
                      ),
                SizedBox(
                  width: 1.sw,
                  height: 320.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: urlImages.length,
                    itemBuilder: (context, index) {
                      final img = urlImages[index];
                      return buildFile(img);
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      widget.onImagesChanged(urlImages);
                      Navigator.pop(context);
                    },
                    child: Text('Save')),
                // InkWell(
                //   child: Ink.image(image: NetworkImage(urlImages.first), height: 200, fit: BoxFit.cover),
                //   onTap: () => openGallery(context),
                // ),
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

  Widget buildFile(String file) {
    return Container(
      width: 0.55.sw,
      color: Colors.transparent,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => openGallery(context),
            child: file.startsWith('https')
                ? Image(
                    image: NetworkImage(file),
                    width: 0.5.sw,
                    height: 250.h,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(file),
                    width: 0.5.sw,
                    height: 250.h,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            height: 10.0,
          ),
          InkWell(
            child: const Icon(Icons.delete_outline),
            onTap: () {
              //files.remove(file);
              urlImages.remove(file);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
