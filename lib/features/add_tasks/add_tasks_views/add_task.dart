import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati/core/extension/extensions.dart';
import 'package:taskati/core/models/task_model.dart';
import 'package:taskati/core/services/local_helper.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_styles.dart';
import 'package:taskati/core/widgets/custom_buttons.dart';
import 'package:taskati/features/home/home_views/home_view.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  int selectedColor = 0;
  @override
  void initState() {
    dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    startTimeController.text = DateFormat("hh:mm a").format(DateTime.now());
    endTimeController.text = DateFormat("hh:mm a").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleField(),
                const Gap(10),
                descriptionField(),
                const Gap(10),
                dateField(context),
                const Gap(10),
                timeField(context),
                const Gap(20),
                Row(
                  children: [
                    colorsWidget(),
                    const Spacer(),
                    CustomButton(
                        width: 145,
                        text: "Create Task",
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            var key = DateTime.now().toString() +
                                titleController.text;
                            await AppLocalStorage.cacheTask(
                                key,
                                TaskModel(
                                    id: key,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    date: dateController.text,
                                    startTime: startTimeController.text,
                                    endTime: endTimeController.text,
                                    color: selectedColor,
                                    isCompleted: false));
                            context.pushTo(const HomeView());
                          }
                        })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row colorsWidget() {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = index;
              });
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: index == 0
                  ? AppColors.primaryColor
                  : index == 1
                      ? AppColors.orangeColor
                      : AppColors.redColor,
              child: (selectedColor == index)
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }

  Row timeField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "start time",
                style: getBodyTextStyle(context, fontWeight: FontWeight.w500),
              ),
              const Gap(10),
              TextFormField(
                controller: startTimeController,
                readOnly: true,
                onTap: () async {
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return  Theme(
                                    data:AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme)? ThemeData.dark():ThemeData.light(),
                                    child: child!,
                                  );
                    },
                  
                  );
                  if (time != null) {
                    startTimeController.text = time.format(context);
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Select Time",
                  suffixIcon: Icon(
                    Icons.access_time_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "end time",
                style: getBodyTextStyle(context, fontWeight: FontWeight.w500),
              ),
              const Gap(10),
              TextFormField(
                controller: endTimeController,
                readOnly: true,
                onTap: () async {
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return  Theme(
                                    data:AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme)? ThemeData.dark():ThemeData.light(),
                                    child: child!,
                                  );
                    },
                  );
                  if (time != null) {
                    endTimeController.text = time.format(context);
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Select Time",
                  suffixIcon: Icon(
                    Icons.access_time_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column titleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "title",
          style: getBodyTextStyle(context, fontWeight: FontWeight.w500),
        ),
        const Gap(10),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: "Enter Title",
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Required";
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }

  Column descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "description",
          style: getBodyTextStyle(context, fontWeight: FontWeight.w500),
        ),
        const Gap(10),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter Description",
          ),
        ),
      ],
    );
  }

  Column dateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "date",
          style: getBodyTextStyle(context, fontWeight: FontWeight.w500),
        ),
        const Gap(10),
        TextFormField(
          controller: dateController,
          readOnly: true,
          onTap: () async {
            var pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2040),
              builder:(context, child){
                return   Theme(
                                    data:AppLocalStorage.getCachedData(AppLocalStorage.isDarkTheme)? ThemeData.dark():ThemeData.light(),
                                    child: child!,
                                  );
                
              }
            );
            if (pickedDate != null) {
              dateController.text = DateFormat("dd/MM/yyyy").format(pickedDate);
            }
          },
          decoration: InputDecoration(
            hintText: dateController.text,
            hintStyle: getBodyTextStyle(context, fontWeight: FontWeight.w500),
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
