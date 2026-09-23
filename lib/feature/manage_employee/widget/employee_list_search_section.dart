import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/utils/dimensions.dart';

class EmployeeListSearchSection extends StatelessWidget {
  final double screenWidth;
  const EmployeeListSearchSection({Key? key, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
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
        CustomButton(
          width: 144,
          height: 60,
          icon: Icons.search,
          buttonText: 'Search',
          onPressed: (){
          },
        )
      ],
    );

  }
}
