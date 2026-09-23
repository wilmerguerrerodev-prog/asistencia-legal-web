import 'package:flutter/material.dart';
import 'package:getdash/feature/seller/models/seller_info_model.dart';

import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SellerInfoSection extends StatelessWidget {

  final int crossAxisCount;
  final double childAspectRatio;
  const SellerInfoSection({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sellerInfoList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => sellerInfoItem(sellerInfoModel: sellerInfoList[index],context: context),
    );

  }

  Widget sellerInfoItem({required SellerInfoModel sellerInfoModel,required BuildContext context}){
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,top: Dimensions.paddingSizeLarge, right:Dimensions.paddingSizeDefault),
      width: (MediaQuery.of(context).size.width - 180) / 4,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: .05),
          border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Row(children: [
          Icon(sellerInfoModel.leadingIcon,color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(sellerInfoModel.title!,style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),fontSize: Dimensions.fontSizeLarge)),
        ]),

        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Row(children: [
          Text(
              "${sellerInfoModel.totalSellerAmount}",
              style: ubuntuMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),
                  fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeRadius,
                right: Dimensions.paddingSizeRadius,
                top: Dimensions.paddingSizeMint,
                bottom: Dimensions.paddingSizeMint),

            decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraMoreLarge)),
            child: Row(children: [
              Text(
                  "+${sellerInfoModel.totalSales}",
                  style: ubuntuMedium.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeExtraSmall)),

              const SizedBox(width: Dimensions.paddingSizeMint),
              const Icon(Icons.arrow_outward,color: Colors.white,size: Dimensions.iconSizeSmall),
            ]),
          ),

        ]),

      ]),
    );
  }

}
