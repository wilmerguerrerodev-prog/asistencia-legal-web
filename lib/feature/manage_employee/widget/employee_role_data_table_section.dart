import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../../../components/custom_switch.dart';

class EmployeeRoleDataTableSection extends StatefulWidget {
  const EmployeeRoleDataTableSection({super.key});

  @override
  State<EmployeeRoleDataTableSection> createState() => _EmployeeRoleDataTableSectionState();
}

class _EmployeeRoleDataTableSectionState extends State<EmployeeRoleDataTableSection> {

  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";

  onChangedMethod1(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Row(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: DataTable(
                headingRowHeight: Dimensions.headerRowHeight,
                dividerThickness: 0.0,
                horizontalMargin: 0.0,
                columns:  <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Role Name',
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                  DataColumn(

                    label: Text(
                      'Permitted Modules',
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ],
                rows:  <DataRow>[
                  dataRow(context),
                  dataRow(context),
                  dataRow(context),
                  dataRow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow dataRow(BuildContext context){
    return DataRow(
      cells: <DataCell>[
        const DataCell(Text('Admin')),
        const DataCell(Text('8')),
        DataCell(customSwitch(value1, onChangedMethod1,context)),
        DataCell(PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: item1, child: Text(item1)),
              PopupMenuItem(value: item2, child: Text(item2)),
              PopupMenuItem(value: item3, child: Text(item3)),
              PopupMenuItem(value: item4, child: Text(item4))],
            onSelected: (String newValue){})),
      ],
    );
  }
}
