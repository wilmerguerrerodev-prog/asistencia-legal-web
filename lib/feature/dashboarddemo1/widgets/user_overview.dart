import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/user_overview_chart.dart';
import 'package:getdash/utils/dimensions.dart';

class UserOverviewChart extends StatelessWidget {
  const UserOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: const UserDataOverview(),
    );
  }
}
