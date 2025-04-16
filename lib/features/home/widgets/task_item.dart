import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskati/core/models/task_model.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_styles.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key, required this.task,
  });
   final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color:  task.color == 0
                  ? AppColors.primaryColor
                  : task.color == 1
                      ? AppColors.orangeColor
                      : AppColors.redColor,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: getBodyTextStyle(context,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600),
                ),
                const Gap(5),
                Row(
                  children: [
                    const Icon(Icons.watch_later_outlined,
                        size: 18,
                        color: AppColors.whiteColor),
                    const Gap(5),
                    Text(
                      "${task.startTime} - ${task.endTime}",
                      style: getSmallTextStyle(
                          color: AppColors.whiteColor),
                    )
                  ],
                ),
                const Gap(5),
                Text(
                  task.description,
                  style: getSmallTextStyle(
                      color: AppColors.whiteColor),
                ),
              ],
            ),
          ),
          Container(
            width: .5,
            height: 60,
            color: AppColors.whiteColor,
          ),
          RotatedBox(quarterTurns: 3,
            child: Text(
              task.isCompleted? "Completed": "TODO",
              style: getSmallTextStyle(fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
