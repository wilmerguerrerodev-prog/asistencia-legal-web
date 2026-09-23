import 'package:flutter/material.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/dashboard/models/summery_items.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SummerySection extends StatelessWidget {

  final int crossAxisCount;
  final double childAspectRatio;

  const SummerySection({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {


    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: summeryItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => summeryItem(summeryItems: summeryItems[index],context: context),
    );
  }

  Widget summeryItem({required SummeryItems summeryItems,required BuildContext context}){
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      width: (MediaQuery.of(context).size.width - 75) / 4,
      decoration: BoxDecoration(color: summeryItems.color,borderRadius: BorderRadius.circular(5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Text("Total Sales",style: ubuntuRegular.copyWith(color: Colors.white)),
        const SizedBox(height: 10),
        Text("\$${summeryItems.amount}",style: ubuntuBold.copyWith(color: Colors.white,fontSize: Dimensions.fontSizeExtraLarge)),
        const SizedBox(height: 10),
        Row(children: [
          Text("+\$${summeryItems.increaseRate}",style: ubuntuRegular.copyWith(color: Colors.white)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          if(!ResponsiveHelper.isTab(context))
          Expanded(child: Text("Since last Month",style: ubuntuRegular.copyWith(color: Colors.white))),
        ],),

        if(ResponsiveHelper.isTab(context))
          Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
            child: Text("Since last Month",style: ubuntuRegular.copyWith(color: Colors.white)),
          ),
      ]),
    );
  }
}
