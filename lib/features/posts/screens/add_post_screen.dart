import 'package:dormnow/core/common/gallery.dart';
import 'package:dormnow/core/common/gallery_view.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';

class AddAdvertScreen extends ConsumerStatefulWidget {
  const AddAdvertScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAdvertScreenState();
}

class _AddAdvertScreenState extends ConsumerState<AddAdvertScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  final _contactController = TextEditingController();
  final _priceController = TextEditingController();
  final _paymentController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<XFile>? _selectedImages = [];
  List<String> selectedImages = [];

  Future<void> _pickGalleryFromGallery() async {
    final imagePicker = ImagePicker();
    List<XFile> pickedFiles = await imagePicker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages ??= [];
        _selectedImages!.addAll(pickedFiles);
      });
    }
  }

  bool switchValue = false;
  // XFile? _image;
  // = XFile( 'C:/Users/supwi/OneDrive/Pictures/Файли з камери/2023-02-23/feOffset-icon.png');

  bool validName = true;
  // void openGallery(BuildContext context) => Navigator.of(context).push(MaterialPageRoute(
  //       builder: (_) => GalleryWidget(
  //         urlImages: urlImages,
  //       ),
  //     ));
  // final urlImages = [
  //   'https://www.csc.knu.ua/filer/canonical/1501012402/208/',
  //   'https://csc.knu.ua/media/news/289/a558c299-f5ac-4224-b3b9-0e9de2393c27.jpg',
  //   'https://csc.knu.ua/media/persons/da3da4b2-7b5b-4198-8952-cd28caa1228e.jpg.600x600_q85_autocrop_upscale.jpg',
  //   'https://csc.knu.ua/media/news/d520cd06-dd06-45d6-be4a-aef575722dca.jpg'
  // ];

  bool _isContructual = false;
  bool _isFree = false;
  bool _isChecked = false;
  Color dynamicBorderColor = Color(0xFFFFCE0C);

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Це поле обов\'язкове';
    }

    final RegExp regex = RegExp(r'^\d{2}\.\d{2}$');

    if (!regex.hasMatch(value)) {
      return 'Неправильно введені дані';
    }

    return null;
  }

  void createPost() {
    if (selectedImages.length <= 10 &&
        _nameController.text.isNotEmpty &&
        (_priceController.text.isNotEmpty || _isChecked)) {
      ref.read(postContollerProvider.notifier).createPost(
            context: context,
            title: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            files: selectedImages,
            price: !_isChecked ? double.parse(_priceController.text.trim()) : null,
            isFree: _isChecked,
            contacts: _contactController.text.trim(),
            address: _addressController.text.trim(),
            dorm: "dorm",
            floor: 2,
            room: "room",
          );
    } else {
      showSnackBar(context, "Please check your application");
    }
  }

  void goBackConfirmation() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Увага',
            style: TextStyle(color: Color(0xFFFFCE0C)),
          ),
          content: const Text(
            'Ви впевнені, що хочете вийти?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF16382B)),
              ),
              child: const Text('Так', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF16382B)),
              ),
              child: const Text('Ні', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    if (shouldPop == true) {
      Routemaster.of(context).history.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    _addressController.text = user.dfAddress;
    _contactController.text = user.dfContact;
    final isLoading = ref.watch(postContollerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text('Додати оголошення'),
              backgroundColor: Color(0xFF16382B),
              leading: IconButton(
                onPressed: () {
                  goBackConfirmation();
                },
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Image
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,x
                      //   children: [
                      //     _image != null
                      //         ? Image.file(
                      //             File(_image!.path),
                      //             width: 145.0,
                      //             height: 145.0,
                      //             fit: BoxFit.cover,
                      //           )
                      //         : Container(width: 150.0, height: 150.0, color: Colors.grey), // Placeholder if no image
                      //     const SizedBox(height: 5.0),
                      //     Container(
                      //         width: 150,
                      //         height: 33,
                      //         decoration: BoxDecoration(
                      //           color: Color(0xFF16382B),
                      //           border: Border.all(color: Colors.black, width: 1),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black.withOpacity(0.25),
                      //               offset: Offset(0, 4),
                      //               blurRadius: 4,
                      //             ),
                      //           ],
                      //           borderRadius: BorderRadius.circular(34),
                      //         ),
                      //         child: ElevatedButton(
                      //           onPressed: () async {
                      //             XFile? newImage = await ImagePicker().pickImage(source: ImageSource.gallery);

                      //             // Тут ви можете додати код для обробки вибору фотографії
                      //             if (newImage != null) {
                      //               setState(() {
                      //                 _image = newImage;
                      //               });
                      //             }
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             primary: Colors.transparent,
                      //             elevation: 0,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(34),
                      //             ),
                      //           ),
                      //           child: Text('Додати фото'),
                      //         )),
                      //   ],
                      // ), // Placeholder if no image

                      // Right side - Text Inputs
                      //const SizedBox(width: 16.0), // Add some space between image and text inputs
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Color(0xFFFEF6EA)),
                              decoration: InputDecoration(
                                labelText: 'Назва товару',
                                labelStyle: const TextStyle(color: Color(0xFFFEF6EA)), // Set label text color
                                hintText: 'Введіть назву вашого товару', // Add hint text
                                hintStyle: TextStyle(color: Color(0xFFFEF6EA)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFEF6EA),
                                  ),
                                  borderRadius: BorderRadius.circular(34.0), // Set border radius
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFEF6EA),
                                  ),
                                  borderRadius: BorderRadius.circular(34.0), // Set border radius
                                ),
                              ),
                              validator: (value) {
                                if (value?.trim().isEmpty ?? true) {
                                  return 'Field required';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16.0), // Add some space between text inputs
                            TextFormField(
                              controller: _descriptionController,
                              minLines: 4, // Minimum number of lines
                              maxLines: null,
                              style: TextStyle(color: Color(0xFFFEF6EA)),
                              decoration: InputDecoration(
                                labelText: 'Опис товару',
                                labelStyle: const TextStyle(color: Color(0xFFFEF6EA)), // Set label text color
                                hintText: 'Введіть опис вашого товару', // Add hint text
                                hintStyle: const TextStyle(color: Color(0xFFFEF6EA)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFEF6EA),
                                  ),
                                  borderRadius: BorderRadius.circular(34.0), // Set border radius
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFEF6EA),
                                  ),
                                  borderRadius: BorderRadius.circular(34.0), // Set border radius
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _addressController,
                    style: TextStyle(color: Color(0xFFFEF6EA)),
                    decoration: InputDecoration(
                      labelText: 'Адреса',
                      labelStyle: const TextStyle(color: Color(0xFFFEF6EA)), // Set label text color
                      hintText: 'Введіть адресу', // Add hint text
                      hintStyle: TextStyle(color: Color(0xFFFEF6EA)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFFEF6EA),
                        ),
                        borderRadius: BorderRadius.circular(34.0), // Set border radius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFFEF6EA),
                        ),
                        borderRadius: BorderRadius.circular(34.0), // Set border radius
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _contactController,
                    style: const TextStyle(color: Color(0xFFFEF6EA)),
                    decoration: InputDecoration(
                      labelText: 'Контакти',
                      labelStyle: TextStyle(color: Color(0xFFFEF6EA)), // Set label text color
                      hintText: 'Введіть спосіб з вами зв\'язатися', // Add hint text
                      hintStyle: TextStyle(color: Color(0xFFFEF6EA)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFFEF6EA),
                        ),
                        borderRadius: BorderRadius.circular(34.0), // Set border radius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFFEF6EA),
                        ),
                        borderRadius: BorderRadius.circular(34.0), // Set border radius
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          enabled: !_isChecked,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: Color(0xFFFEF6EA)),
                          decoration: InputDecoration(
                            labelText: 'Ціна',
                            hintText: '0.00₴', // Зафіксована підказка
                            labelStyle: const TextStyle(color: Color(0xFFFEF6EA)), // Set label text color

                            hintStyle: TextStyle(color: Color(0xFFFEF6EA)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFEF6EA),
                              ),
                              borderRadius: BorderRadius.circular(34.0), // Set border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFEF6EA),
                              ),
                              borderRadius: BorderRadius.circular(34.0), // Set border radius
                            ), // Колір підказки
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$'),
                            ),
                          ],
                          validator: _validatePrice,
                          onEditingComplete: () {
                            if (_priceController.text.isNotEmpty) {
                              double amount = double.parse(_priceController.text);
                              String formattedValue =
                                  '${amount.toStringAsFixed(2)}₴'; // Форматування до двох знаків після коми
                              _priceController.value = TextEditingValue(
                                text: formattedValue,
                                selection: TextSelection.collapsed(
                                  offset: formattedValue.length,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      // Container(
                      //   width: 22.0,
                      //   height: 22.0, // Set the desired height
                      //   padding: const EdgeInsets.all(2.0),
                      //   // decoration: BoxDecoration(
                      //   //   border: Border.all(color: dynamicBorderColor, width: 2.0 // Border width
                      //   //       ),
                      //   // ),
                      //   child: Checkbox(
                      //     value: _isContructual,
                      //     onChanged: !_isChecked
                      //         ? (value) {
                      //             setState(() {
                      //               _isContructual = value!;
                      //             });
                      //           }
                      //         : null,
                      //     activeColor: dynamicBorderColor,
                      //     checkColor: Colors.black,
                      //   ),
                      // ),
                      // const Text(
                      //   ' Договірна ',
                      //   style: TextStyle(color: Color(0xFFFEF6EA)), // Set the color for the text
                      // ),
                      Container(
                          width: 22.0,
                          height: 22.0,
                          padding: const EdgeInsets.all(2.0),
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: dynamicBorderColor, width: 2.0 // Border width
                          //       ),
                          // ),
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                                if (value) {
                                  _isContructual = false;
                                  _isFree = false;
                                  //dynamicBorderColor = const Color.fromARGB(255, 0, 0, 0);

                                  _priceController.clear();
                                } else {
                                  //dynamicBorderColor = const Color(0xFFFFCE0C);
                                }
                              });
                            },
                            activeColor: const Color(0xFFFFCE0C),
                            checkColor: Colors.black,
                          )),
                      const Text(' Безкоштовно', style: TextStyle(color: Color(0xFFFEF6EA))),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: SizedBox(
                  //         width: 500.0,
                  //         child: TextField(
                  //           controller: _paymentController,
                  //           enabled: !_isFree && !_isChecked,
                  //           style: const TextStyle(color: Color(0xFFFEF6EA)),
                  //           decoration: InputDecoration(
                  //             labelText: 'Дані для оплати',
                  //             labelStyle: const TextStyle(color: Color(0xFFFEF6EA)), // Set label text color

                  //             hintStyle: const TextStyle(color: Color(0xFFFEF6EA)),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                 color: Color(0xFFFEF6EA),
                  //               ),
                  //               borderRadius: BorderRadius.circular(34.0), // Set border radius
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                 color: Color(0xFFFEF6EA),
                  //               ),
                  //               borderRadius: BorderRadius.circular(34.0), // Set border radius
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8.0),
                  //     Container(
                  //         width: 22.0, // Set the desired width
                  //         height: 22.0, // Set the desired height
                  //         padding: const EdgeInsets.all(2.0),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //               color: dynamicBorderColor, // Border color
                  //               width: 2.0 // Border width
                  //               ),
                  //           // Adjust border radius as needed

                  //           // Adjust border radius as needed
                  //         ),
                  //         child: Checkbox(
                  //           value: _isFree,
                  //           onChanged: !_isChecked
                  //               ? (value) {
                  //                   setState(() {
                  //                     _isFree = value!;
                  //                   });
                  //                 }
                  //               : null,
                  //           activeColor: dynamicBorderColor, // Set the color for the active state
                  //           checkColor: Colors.black,
                  //         )),
                  //     const Text(' Готівка            ', style: TextStyle(color: Color(0xFFFEF6EA))),
                  //   ],
                  // ),
                  SizedBox(height: 8.0),
                  // InkWell(
                  //   child: Ink.image(image: NetworkImage(urlImages.first), height: 200, fit: BoxFit.cover),
                  //   onTap: () => openGallery(context),
                  // ),
                  const SizedBox(height: 8.0),
                  Container(
                      width: 500,
                      height: 33,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16382B),
                        border: Border.all(color: Colors.black, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => GalleryChoiseWidget(
                              previousImages: selectedImages,
                              onImagesChanged: (value) {
                                selectedImages = [];
                                selectedImages.addAll(value);
                                // print('!');
                                // print(selectedImages);
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                        child: const Text('Додати фото'),
                      )),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 376,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16382B),
                      border: Border.all(color: Colors.black, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _contactController.text.isEmpty) {
                          validName = false;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text(
                                  'Помилка',
                                  style: TextStyle(color: Color(0xFFFFCE0C)),
                                ),
                                content: const Text(
                                  'Вкажіть УСІ необхідні дані',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF16382B)),
                                    ),
                                    child: const Text('OK', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          createPost();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      child: const Text('Створити',
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
