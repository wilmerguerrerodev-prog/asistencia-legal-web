import 'package:flutter/material.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/feature/seller/widget/seller_opload_file_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SellerDetailsSettings extends StatelessWidget {
  const SellerDetailsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
            border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Column(children: [

          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

            Expanded(child: addSellerInputSectionItem(title: "Seller Name", context: context)),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: addSellerInputSectionItem(title: "Phone Number", context: context)),

          ]),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

            Expanded(child: addSellerInputSectionItem(title: "Email Address", context: context)),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: addSellerInputSectionItem(title: "Office Address", context: context)),

          ]),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          const SellerUploadFileSection(),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

            Expanded(child: addSellerInputSectionItem(title: "Contact Person Name", context: context)),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: addSellerInputSectionItem(title: "Designation", context: context)),

          ]),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

            Expanded(child: addSellerInputSectionItem(title: "Phone Number", context: context)),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: addSellerInputSectionItem(title: "Email Address", context: context)),

          ]),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          const SellerUploadFileSection(),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          const Row(mainAxisAlignment: MainAxisAlignment.end,children:  [

            CustomButton(buttonText: "Submit",width: 100),

          ]),

        ]),
      ),
    );
  }
}

Widget addSellerInputSectionItem({
  required String title,
  required BuildContext context}){

  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

    Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
    const SizedBox(height: Dimensions.paddingSizeSmall),
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: CustomTextField(
        ),
      ),
    ),

  ]);
}
