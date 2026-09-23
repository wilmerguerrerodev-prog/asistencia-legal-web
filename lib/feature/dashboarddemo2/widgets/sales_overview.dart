import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/sales_overview_chart.dart';
import 'package:getdash/utils/dimensions.dart';

class SalesOverview extends StatelessWidget {
  const SalesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 200,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Padding(
                padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Text(
                  "Sales Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:const Color(0xFFE3D5F4),
                        borderRadius: BorderRadius.circular(10)),
                    child:const Padding(
                      padding:  EdgeInsets.all(10),
                      child: Text(
                        "Today",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                 const SizedBox(
                    width: 3,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child:const Padding(
                      padding:  EdgeInsets.all(10),
                      child: Text(
                        "Week",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                 const SizedBox(
                    width: 3,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child:const Padding(
                      padding:  EdgeInsets.all(10),
                      child: Text(
                        "Month",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
         const Divider(),
         const SalesOverviewChart(),
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pieChartInfoWidget("\$7.9k", "Revenue"),
                      pieChartInfoWidget("\$50k", "Sales"),
                      pieChartInfoWidget("\$55k", "Product")

                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pieChartInfoWidget(String count, String title){
    return Column(
      children: [
         Text(
          count,
          style: TextStyle(
              fontSize: Dimensions.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Text(
         title,
          style: TextStyle(
              fontSize: Dimensions.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ],
    );
  }
}
