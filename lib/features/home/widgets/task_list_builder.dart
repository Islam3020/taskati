import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:taskati/core/models/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_styles.dart';

import 'package:taskati/features/home/widgets/task_item.dart';


class TaskListBuilder extends StatelessWidget {
  const TaskListBuilder({
    super.key, required this.selectedDate,
  });
 final String selectedDate;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ValueListenableBuilder(valueListenable: AppLocalStorage.taskBox!.listenable(),
          builder: (context, box, child) {
            List<TaskModel> tasks = box.values.where((e)=> e.date==selectedDate).cast<TaskModel>().toList();
            if (tasks.isEmpty) {
              return  Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/images/empty.json'),
                    const Gap(20),
                    Text("No Tasks Yet", style: getBodyTextStyle(context, color: AppColors.primaryColor)
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  
                  return Dismissible(key: UniqueKey(),
                  secondaryBackground:  Container(padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    color: Colors.red),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete, color: Colors.white,),
                        Gap(10),
                        Text("Delete", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    ),
                  background: Container(padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.done, color: Colors.white,),
                        Gap(10),
                        Text("Completed", style: TextStyle(color: Colors.white),)
                      ],
                    ),
                    ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      box.delete(tasks[index].id);
                    }else {
                      box.put(tasks[index].id, tasks[index].copyWith(isCompleted: true));
                    }
                  },
                    child: TaskItem(
                    task: tasks[index],
                    ),
                  );
                });
          },
          
        ));
  }
}
