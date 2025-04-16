import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati/core/extension/extensions.dart';

import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';

import 'package:taskati/core/utils/text_styles.dart';

import 'package:taskati/core/widgets/custom_buttons.dart';
import 'package:taskati/core/widgets/dialogs.dart';
import 'package:taskati/features/home/home_views/home_view.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  String? path;
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                if (path != null && nameController.text.isNotEmpty) {
                  AppLocalStorage.cacheData(AppLocalStorage.kName, nameController.text);
                  AppLocalStorage.cacheData(AppLocalStorage.kImage, path);
                  AppLocalStorage.cacheData(AppLocalStorage.isUploaded, true);
                  context.pushReplacement(const HomeView());
                } else if (path == null && nameController.text.isNotEmpty) {
                  showErrorToast(context, "Please select an image");
                } else if (path != null && nameController.text.isEmpty) {
                  showErrorToast(context, "Please enter a name");
                } else {
                  showErrorToast(
                      context, "Please select an image and enter a name");
                }
              },
              child: Text(
                "Done",
                style: getBodyTextStyle(context,color: AppColors.primaryColor),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: path != null
                      ? FileImage(File(path!))
                      : const AssetImage("assets/images/user.png"),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  width: 250,
                  text: "Upload From Camera",
                  onPressed: () {
                    uploadImage(true);
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  width: 250,
                  text: "Upload From Image",
                  onPressed: () {
                    uploadImage(false);
                  },
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Name",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadImage(bool isCamera) async {
    XFile? pickedImage = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        path = pickedImage.path;
      });
    }
  }
}
