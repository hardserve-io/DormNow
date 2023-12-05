import 'dart:io';

import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPostScreenLegacy extends ConsumerStatefulWidget {
  const AddPostScreenLegacy({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenLegacyState();
}

class _AddPostScreenLegacyState extends ConsumerState<AddPostScreenLegacy> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

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

  List<PlatformFile> files = [];

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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postContollerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Add new position'),
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
                      files.length <= 10
                          ? IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  withReadStream: true,
                                  allowMultiple: true,
                                  type: FileType.image,
                                );

                                if (result == null) return;
                                files.addAll(result.files);
                                setState(() {});
                              },
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
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return buildFile(file);
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
  }

  Widget buildFile(PlatformFile file) {
    return Container(
      width: 100.w,
      color: Colors.transparent,
      child: Column(
        children: [
          (file.extension == 'jpg' || file.extension == 'png')
              ? Image.file(
                  File(file.path.toString()),
                  width: 60.w,
                )
              : const SizedBox(
                  width: 80,
                  height: 80,
                ),
          SizedBox(
            height: 10.h,
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
