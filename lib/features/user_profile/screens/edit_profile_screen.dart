import 'dart:io';

import 'package:dormnow/core/common/error_text.dart';
import 'package:dormnow/core/common/loader.dart';
import 'package:dormnow/core/utils.dart';
import 'package:dormnow/features/auth/controller/auth_controller.dart';
import 'package:dormnow/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;
  //final nameEditController = TextEditingController();
  final nameEditController = TextEditingController();
  final addressEditController = TextEditingController();
  final contactEditController = TextEditingController();

  bool inited = true;

  final _formKey = GlobalKey<FormState>();
  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(BuildContext context) {
    ref.read(userProfileControllerProvider.notifier).editProfile(
        profileFile: profileFile,
        context: context,
        name: nameEditController.text.trim(),
        address: addressEditController.text.trim(),
        contact: contactEditController.text.trim());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameEditController.dispose();
    addressEditController.dispose();
    contactEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return ref.watch(getUserDataProvider(user.uid)).when(
          data: (data) {
            if (inited) {
              nameEditController.text = data.name;
              contactEditController.text = data.dfContact;
              addressEditController.text = data.dfAddress;
              inited = false;
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Редагування профілю')),
              body: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 25),
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: Column(
                            children: [
                              profileFile != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 50,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePicture),
                                      radius: 50,
                                    ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffFFCE0C),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 20,
                                  right: 20,
                                ),
                                margin: const EdgeInsets.only(top: 20),
                                child: const Text(
                                  "Змінити аватар",
                                  style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Ім'я користувача"),
                            controller: nameEditController,
                            validator: (value) {
                              if (value == '') {
                                return "Це поле обов'язкове!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Адреса"),
                              controller: addressEditController,
                              validator: (value) {
                                if (value == '') {
                                  return "Це поле обов'язкове!";
                                }
                                return null;
                              }),
                          const SizedBox(height: 10),
                          TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Контакти"),
                              controller: contactEditController,
                              validator: (value) {
                                if (value == '') {
                                  return "Це поле обов'язкове!";
                                }
                                return null;
                              }),
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 25, right: 5),
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 0,
                          right: 15,
                          left: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color(0xffFFCE0C),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              save(context);
                            }
                          },
                          child: const Text(
                            'Зберегти зміни',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
