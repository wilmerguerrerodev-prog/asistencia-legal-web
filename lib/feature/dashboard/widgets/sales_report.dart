import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboard/widgets/sales_report_chart.dart';
import 'package:getdash/utils/dimensions.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 500,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: const LineChartSample1(),
      ),
    );
  }
}
