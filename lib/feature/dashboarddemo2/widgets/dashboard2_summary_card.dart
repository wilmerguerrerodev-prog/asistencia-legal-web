import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboarddemo1/model/demo_one_summery_items.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

class DemoOneSummeryCard extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const DemoOneSummeryCard({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });
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
        itemCount: demoOneSummeryItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => summeryItem(summeryItems: demoOneSummeryItems[index],context: context),
      ),
    );
  }


  Widget summeryItem({required DemoOneSummeryItems summeryItems,required BuildContext context}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                summeryItems.image!,
                scale: 4,
              ),
              const SizedBox(width: 5,),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Image.asset(
                      Images.dashboardsymbol,
                      scale: 22,
                    ),
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
                        style: const TextStyle(color: Colors.green, fontSize: 15)),
                  ]),
                  const SizedBox(height: 3,),
                  Text(summeryItems.title!,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18)),
                ],
              )
            ],
          ),
        ]);
  }
}
