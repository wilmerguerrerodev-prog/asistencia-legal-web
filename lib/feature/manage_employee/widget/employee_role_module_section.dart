import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class EmployeeRoleModuleSection extends StatelessWidget {
  const EmployeeRoleModuleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeRadius),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
        childAspectRatio: (2),
      ),
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => checkBoxItem(value: false,checkBoxTitle: "dashboard".tr,context: context),
    );
  }
}

Widget checkBoxItem({
  required String checkBoxTitle,
  required bool value,
  required BuildContext context}){

  return Row(children: [
    Transform.scale(scale: 0.8,child: Checkbox(value: value, onChanged: (newValue){})),
    Text(checkBoxTitle,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
  ]);
}
