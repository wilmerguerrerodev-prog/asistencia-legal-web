import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/sales_revenue_chart.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

class DashboardDemo3Ultimate extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const DashboardDemo3Ultimate({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => summeryItem(context),
      ),
    );
  }


  Widget summeryItem(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                height: 500,
                width: Get.width,
                decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text("Source of Revenue Generated",style: TextStyle(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.bold
                  ),),
                )

              ],
            ),

          //  SizedBox(height: 60,),
           const Divider(),
          const SalesRevenueChart(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              width: 15,
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
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Color(0xFFD8D8FE),
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
                ),
              ],
            ),
          
            //SizedBox(height: 70,)
          
            ],
          ),
           
    
            
          ],
                ),
              ),
        ]);
  }
}
