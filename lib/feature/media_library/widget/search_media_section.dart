import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/utils/dimensions.dart';

class SearchMediaSection extends StatelessWidget {
  final double screenWidth;
  const SearchMediaSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    String selectedType = 'Filter By File Type';
    String selectedDate = 'Filter By Date';
    String selectedAction= 'Bulk Action';


    return SizedBox(
      height: Dimensions.paddingSizeDoubleExtraLarge,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimensions.paddingSizeExtraSmall)),
              ),
              child: CustomTextField(
                hintText: 'search'.tr,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.06),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                value: selectedType,
                items: <String>['Filter By File Type', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.06),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                value: selectedDate,
                items: <String>['Filter By Date', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDate = value!;
                },
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withValues(alpha: 0.06),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                value: selectedAction,
                items: <String>['Bulk Action', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedAction = value!;
                },
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          CustomButton(
            width: 144,
            height: 60,
            icon: Icons.search,
            buttonText: 'Search',
            onPressed: (){
            },
          )
        ],
      ),
    );

  }
}
