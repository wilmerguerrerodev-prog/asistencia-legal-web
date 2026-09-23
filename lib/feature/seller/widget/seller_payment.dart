import 'package:flutter/material.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/utils/dimensions.dart';

class SellerPayment extends StatelessWidget {
  const SellerPayment({super.key});


  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Bank';
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Column(children: [
        Row(children: [
          const Text("Payment Method"),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                value: selectedDuration,
                items: <String>['Bank', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDuration = value!;
                },
              ),
            ),
          ),


        ]),

        const SizedBox(height: Dimensions.paddingSizeLargeThirty),
        Row(children: [
          Expanded(child: paymentInputSectionItem(title: "Bank Name", context: context)),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Expanded(child: paymentInputSectionItem(title: "Account Number", context: context)),
        ]),

        const SizedBox(height: Dimensions.paddingSizeLarge),
        Row(children: [
          Expanded(child: paymentInputSectionItem(title: "Account Holder Name", context: context)),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Expanded(child: paymentInputSectionItem(title: "Branch", context: context)),
        ]),

        const SizedBox(height: Dimensions.paddingSizeLarge),
        Row(children: [
          Expanded(child: paymentInputSectionItem(title: "Routing Number", context: context)),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Expanded(child: paymentInputSectionItem(title: "Swift Code", context: context)),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
        const Row(mainAxisAlignment: MainAxisAlignment.end,children: [
          CustomButton(buttonText: "Save",width: 100),
        ]),
      ]),
    );
  }
}

Widget paymentInputSectionItem({
  required String title,
  required BuildContext context}){

  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

    Text(title),
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
