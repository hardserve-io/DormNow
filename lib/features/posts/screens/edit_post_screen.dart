import 'dart:io';

import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:routemaster/routemaster.dart';

class EditPostScreen extends ConsumerStatefulWidget {
  final String postId;
  const EditPostScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();

  List<DropdownMenuItem> priceOptions = const [
    'Price',
    'Free',
  ]
      .map(
        (value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        ),
      )
      .toList();

  List<XFile> files = [];
  List<String> existingPhotos = [];

  String isPriced = "Price";

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void createPost() {
    if (files.length <= 10 &&
        titleController.text.isNotEmpty &&
        (priceController.text.isNotEmpty || isPriced == "Free")) {
      ref.read(postContollerProvider.notifier).createPost(
            context: context,
            title: titleController.text.trim(),
            description: descController.text.trim(),
            files: [],
            price: isPriced == "Price" ? double.parse(priceController.text.trim()) : null,
            isFree: isPriced == "Free",
            contacts: "contacts",
            address: "address",
            dorm: "dorm",
            floor: 2,
            room: "room",
          );
    } else {
      showSnackBar(context, "Please check your application");
    }
  }

  void selectPhotos() async {
    List<XFile> result = await imagePicker.pickMultiImage();

    if (result.isEmpty) return;
    files.addAll(result);
    setState(() {});
  }

  Future<bool> goBack(BuildContext context) {
    Routemaster.of(context).pop();
    return Future(() => true);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            existingPhotos.addAll(data.pictures);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit post'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        (files.length + existingPhotos.length <= 10)
                            ? IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: selectPhotos,
                              )
                            : SizedBox(
                                height: 30.h,
                              ),
                        SizedBox(
                          width: 1.sw,
                          height: 120.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: files.length + existingPhotos.length,
                            itemBuilder: (context, index) {
                              print(files.length + existingPhotos.length);
                              print(index);
                              if (index < existingPhotos.length - 1) {
                                final picUrl = existingPhotos[index];
                                return buildFile(url: picUrl);
                              } //else {
                              //   final file = files[index];
                              //   return buildFile(file: file);
                              // }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Title',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLength: 30,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        TextField(
                          controller: descController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Description',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLines: 5,
                          maxLength: 200,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        DropdownButton(
                          hint: const Text('Price options'),
                          value: isPriced,
                          items: priceOptions,
                          onChanged: (res) {
                            isPriced = res;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        isPriced == "Price"
                            ? TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'Enter price',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18),
                                ),
                              )
                            : Container(
                                width: 0,
                              ),
                        SizedBox(
                          height: 30.h,
                        ),
                        ElevatedButton(
                          onPressed: createPost,
                          child: const Text('Create'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  Widget buildFile({XFile? file, String? url}) {
    return Container(
      width: 100.w,
      color: Colors.transparent,
      child: Column(
        children: [
          (file != null)
              ? Image.file(
                  File(file.path.toString()),
                  width: 60.w,
                )
              : Image(
                  image: NetworkImage(url!),
                  width: 60.w,
                ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            child: const Icon(Icons.delete_outline),
            onTap: () {
              if (file != null) {
                files.remove(file);
              }

              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
