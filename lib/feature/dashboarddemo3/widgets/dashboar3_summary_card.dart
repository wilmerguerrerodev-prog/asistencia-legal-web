import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboarddemo3/model/dashboard3_summary_item.dart';
import 'package:getdash/utils/dimensions.dart';

class DemoThreeSummeryCard extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const DemoThreeSummeryCard({
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
        itemCount: demoThreeSummeryItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => summeryItem(summeryItems: demoThreeSummeryItems[index],context: context),
      ),
    );
  }


  Widget summeryItem({required DemoThreeSummaryItems summeryItems,required BuildContext context}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(
              children: [
                Image.asset(
                  summeryItems.image!,
                  scale: 4,
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      
                      Text(
                        summeryItems.amount.toString(),
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      Text(summeryItems.increaseRate.toString(),
                          style: const TextStyle(color: Colors.green, fontSize: 14)),
                      Text(summeryItems.subtitle.toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(summeryItems.title!,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 18)),
                  ],
                )
              ],
            ),
          ),
        ]);
  }
}
