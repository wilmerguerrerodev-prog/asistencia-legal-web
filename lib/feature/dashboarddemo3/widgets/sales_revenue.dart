import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/sales_revenue_chart.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

class SalesRevenue extends StatelessWidget {
  const SalesRevenue({super.key});

  @override
  Widget build(BuildContext context) {
   // double screenWidth = Get.width - 75;
    return AspectRatio(
      aspectRatio: 2.8,
      child: Container(
        height: 400,
       // width: Get.width,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Row(
          children: [
          const SalesRevenueChart(),
           
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset(
                    Images.facebookdemo3,
                    scale: 22,
                  ),
                ),
                Text(
                  "Facebook",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$4621",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.tealAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset(
                    Images.twitterdemo3,
                    scale: 22,
                  ),
                ),
                Text(
                  "Twitter",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$4621",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: const Color(0xFFD8D8FE),
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset(
                    Images.googledemo3,
                    scale: 22,
                  ),
                ),
                Text(
                  "Google",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$4621",
                  style: TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
