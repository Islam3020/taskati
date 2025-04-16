import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:taskati/core/extension/extensions.dart';
import 'package:taskati/core/utils/app_colors.dart';
import 'package:taskati/core/utils/text_styles.dart';

import 'package:taskati/features/home/widgets/home_header%20copy.dart';
import 'package:taskati/features/home/widgets/task_list_builder.dart';
import 'package:taskati/features/home/widgets/today_widget.dart';
import 'package:taskati/features/profile/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () => context.pushTo(const ProfileView()),
                  child: const HomeHeader()),
              const Gap(15),
              const TodayWidget(),
              const Gap(15),
              DatePicker(
                DateTime.now().subtract(const Duration(days: 1)),
                initialSelectedDate:
                    DateTime.now(),
                width: 70,
                height: 90,
                selectionColor: AppColors.primaryColor,
                selectedTextColor: Colors.white,
                dayTextStyle: getBodyTextStyle(context, fontSize: 14),
                monthTextStyle: getBodyTextStyle(context, fontSize: 14),
                dateTextStyle:
                    getBodyTextStyle(context, fontWeight: FontWeight.w500),
                onDateChange: (date) {
                  setState(() {
                    selectedDate = DateFormat("dd/MM/yyyy").format(date);
                  });
                },
              ),
              const Gap(10),
              TaskListBuilder(
                selectedDate: selectedDate,
              )
            ],
          ),
        ),
      ),
    );
  }
}
