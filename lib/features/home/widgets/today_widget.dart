

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:gap/gap.dart';
import 'package:taskati/core/extension/extensions.dart';

import 'package:taskati/core/utils/text_styles.dart';


import 'package:taskati/core/widgets/custom_buttons.dart';
import 'package:taskati/features/add_tasks/add_tasks_views/add_task.dart';


class TodayWidget extends StatelessWidget {
  const TodayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMEd().format(DateTime.now()).toString(),
                
                style: getTitleTextStyle(context,fontWeight: FontWeight.w600),
              ),
              Text(
                "Today",
                style: getBodyTextStyle(context,fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Gap(10),
        CustomButton(width:138, text: "Add Task", onPressed: (){
          context.pushTo(const AddTask());
        })
      ],
    );
  }
}