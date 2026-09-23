import 'package:flutter/material.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import 'package:get/get.dart';

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85,
        decoration: BoxDecoration(
            border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("product_details".tr,style: ubuntuBold.copyWith(fontSize: 20)),
              CustomButton(
                width: 144,
                icon: Icons.add,
                buttonText: 'add_new'.tr,
                onPressed: (){
                  Get.toNamed(RouteHelper.addUserScreen);
                },
              )
            ],
          ),
        )
    );
  }
}
