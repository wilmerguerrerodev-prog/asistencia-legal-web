
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class TotalProductsCustomers extends StatelessWidget {
  const TotalProductsCustomers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: totalProducts(context),
            ),
            if(!ResponsiveHelper.isMobile(context))
            const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
            if(!ResponsiveHelper.isMobile(context))
            Expanded(
              child: totalCustomer(context),
            ),
          ],
        ),
        if(ResponsiveHelper.isMobile(context))
        const SizedBox(height: Dimensions.paddingSizeLarge,),
        if(ResponsiveHelper.isMobile(context))
        totalCustomer(context),

      ],
    );
  }

  Widget totalProducts(context){
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(Images.totalProducts,scale: 3,),
          const SizedBox(width: Dimensions.paddingSizeDefault,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text("50000",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
              Text("total_products".tr)
            ],
          )
        ],
      ),
    );
  }

  Widget totalCustomer(context){
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(Images.totalCustomers,scale: 3,),
          const SizedBox(width: Dimensions.paddingSizeDefault,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text("50000",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
              Text("total_customers".tr)
            ],
          )
        ],
      ),
    );
  }
}
