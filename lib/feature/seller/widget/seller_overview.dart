import 'package:flutter/material.dart';
import 'package:getdash/feature/seller/widget/details_information_section.dart';
import 'package:getdash/feature/seller/widget/seller_overview_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SellerOverview extends StatelessWidget {
  const SellerOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Column(children: [
        const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),
        const SellerOverviewSection(),
        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Text('Details Information',style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
          Row(children: [
            const Icon(Icons.edit,size: Dimensions.paddingSizeLarge),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Text("Edit",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
          ]),
        ]),
        const Divider(color: Colors.black,thickness: 0.2),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        const DetailsInformationSection(),
      ]),
    );
  }
}
