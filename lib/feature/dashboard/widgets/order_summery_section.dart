import 'package:flutter/material.dart';
import 'package:getdash/feature/dashboard/models/order_items.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class OrderSummerySection extends StatelessWidget {

  final int crossAxisCount;
  final double childAspectRatio;


  const OrderSummerySection({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderSummeryItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => orderSummeryItem(orderSummeryItems: orderSummeryItems[index],context: context),
    );
  }

  Widget orderSummeryItem({
    required OrderSummeryItems orderSummeryItems,
    required BuildContext context}){

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(orderSummeryItems.iconPath!,scale: 3.5,),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,children: [
            Text(
                orderSummeryItems.amount!,
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text(
                orderSummeryItems.title!,
                style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5))),

          ]),
        ],
      ),
    );
  }
}
