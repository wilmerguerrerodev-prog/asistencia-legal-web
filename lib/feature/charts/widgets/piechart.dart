import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/charts/widgets/chart_header.dart';

class GetDashPieChart extends StatelessWidget {
  const GetDashPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChartHeader(title: "pie_chart".tr),
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: PieChart(PieChartData(
                  centerSpaceRadius: 5,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(value: 35, color: Colors.purple, radius: 100),
                    PieChartSectionData(value: 40, color: Colors.amber, radius: 100),
                    PieChartSectionData(value: 55, color: Colors.green, radius: 100),
                    PieChartSectionData(value: 70, color: Colors.orange, radius: 100),
                  ])
              )
          ),
        ),
      ],
    );
  }
}