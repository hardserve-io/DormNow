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
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? profileFile;
  //final nameEditController = TextEditingController();
  late TextEditingController nameEditController;

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileFile: profileFile,
          context: context,
          name: nameEditController.text.trim(),
        );
  }

  @override
  void initState() {
    nameEditController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return ref.watch(getUserDataProvider(user.uid)).when(
          data: (data) => Scaffold(
            appBar: AppBar(title: const Text('Edit Profile')),
            body: Center(
              child: Column(
                children: [
                  TextField(
                    controller: nameEditController,
                  ),
                  ElevatedButton(onPressed: save, child: const Text('Save')),
                  Container(
                    child: GestureDetector(
                      onTap: selectProfileImage,
                      child: profileFile != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(profileFile!),
                              radius: 32,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePicture),
                              radius: 32,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
