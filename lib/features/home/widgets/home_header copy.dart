import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';

import 'package:taskati/core/utils/text_styles.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: AppLocalStorage.userBox!.listenable(), builder: (context, box, child) {
      return  Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "hello, ${AppLocalStorage.getCachedData("name")}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTitleTextStyle(context,color: AppColors.primaryColor),
                ),
                Text(
                  "Have a nice day",
                  style: getBodyTextStyle(context,),
                ),
              ],
            ),
          ),
          const Gap(20),
          CircleAvatar(
            radius: 24,
            backgroundImage:
                FileImage(File(AppLocalStorage.getCachedData("image"))),
          )
        ],
      );
   
    }
    );
  }
}