import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';

class EmployeeRoleDropDownSection extends StatelessWidget {
  const EmployeeRoleDropDownSection({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Select Role Name';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context)
              .textTheme
              .bodyLarge!
              .color!
              .withOpacity(0.06),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: DropdownButton<String>(
          isExpanded: true,
          underline: const SizedBox(),
          value: selectedDuration,
          items: <String>['Select Role Name', 'B', 'C', 'D'].map((String value) {
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
    );
  }
}
