import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/widgets/custom_buttons.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? path;

  @override
  Widget build(BuildContext context) {
    String? imagePath = AppLocalStorage.getCachedData(AppLocalStorage.kImage);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  bool isDarkTheme =
                      AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme) ?? false;
                  AppLocalStorage.cacheData(
                      AppLocalStorage.isDarkTheme, !isDarkTheme);
                });
              },
              icon: const Icon(Icons.dark_mode))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath))
                        : const AssetImage("assets/images/user.png")
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        showImagePicker(context);
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Divider(
                thickness: 1,
                color: AppColors.primaryColor,
                endIndent: 20,
                indent: 20,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalStorage.getCachedData(AppLocalStorage.kName)?.toString() ?? "User",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showEditNameDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.create,
                          color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme)
          ? AppColors.darkColor
          : AppColors.whiteColor,
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomButton(
                  text: "upload from camera",
                  onPressed: () {
                    uploadImage(true);
                    Navigator.pop(context);
                  }),
              const SizedBox(height: 20),
              CustomButton(
                  text: "upload from gallery",
                  onPressed: () {
                    uploadImage(false);
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  void uploadImage(bool isCamera) async {
    XFile? pickedImage = await ImagePicker()
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        path = pickedImage.path;
        AppLocalStorage.cacheData(AppLocalStorage.kImage, path);
      });
    }
  }

  void showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showModalBottomSheet(
      backgroundColor: AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme)
          ? AppColors.darkColor
          : AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Edit Name"),
              ),
              const SizedBox(height: 20),
              CustomButton(
                  text: "Update Your Name",
                  onPressed: () {
                    setState(() {
                      AppLocalStorage.cacheData(
                          AppLocalStorage.kName, nameController.text);
                      Navigator.pop(context);
                    });
                  }),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
