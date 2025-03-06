import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati/core/extension/extensions.dart';
import 'package:taskati/core/services/local_helper.dart';

import 'package:taskati/core/utils/text_styles.dart';
import 'package:taskati/features/home/home_views/home_view.dart';
import 'package:taskati/features/uplaod/upload_view.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  bool isUploaded = AppLocalStorage.getCachedData(AppLocalStorage.isUploaded)??false;
    Future.delayed(const Duration(seconds: 3), () {
      if(isUploaded){
        context.pushReplacement(const HomeView());
      }else{
        context.pushReplacement(const UploadView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/images/logo.json",
              width: 200,
            ),
            const SizedBox(height: 10),
            Text(
              "Taskati",
              style: getTitleTextStyle(context,),
            ),
            const SizedBox(height: 10),
            Text(
              "Organize your tasks with ease",
              style: getSmallTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}