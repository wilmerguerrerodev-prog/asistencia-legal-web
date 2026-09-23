import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/charts/widgets/chart_header.dart';

class GetDashBarChart extends StatelessWidget {
  const GetDashBarChart({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChartHeader(title: "bar_chart".tr),
        Container(
          height: 400,
          width: double.infinity,

          padding: const EdgeInsets.all(20),
          child: BarChart(BarChartData(
              borderData: FlBorderData(
                  border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  )),
              groupsSpace: 10,
              barGroups: [
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 3, barRods: [
                  BarChartRodData(fromY: 0, toY: 15, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 4, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 5, barRods: [
                  BarChartRodData(fromY: 0, toY: 11, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 6, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 7, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
                BarChartGroupData(x: 8, barRods: [
                  BarChartRodData(fromY: 0, toY: 10, width: 15, color: Colors.amber),
                ]),
              ])),
        ),
      ],
    );
  }
}