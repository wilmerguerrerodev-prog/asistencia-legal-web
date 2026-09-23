import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import 'employee_data_sources.dart';


class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListDataTableSectionState();
}

class _EmployeeListDataTableSectionState extends State<EmployeeList> {

  late EmployeeDataSource _employeeDataSource;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _employeeDataSource = EmployeeDataSource(
          context,
          false);
      _initialized = true;
      _employeeDataSource.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _employeeDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PaginatedDataTable(
            headingRowHeight: Dimensions.headerRowHeight,
            horizontalMargin: 0.0,
            showCheckboxColumn: false,
            //headingRowColor:  MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),
            columns:  <DataColumn>[
              DataColumn(
                label: Text(
                  'Name Info',
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ),
              DataColumn(
                label: Text(
                  'Phone',
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ),
              DataColumn(
                label: Text(
                  'Role',
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
                label: Expanded(
                  child: Text(
                    'Action',
                    style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            source: _employeeDataSource,
          ),
        ),
      ],
    );
  }
}
