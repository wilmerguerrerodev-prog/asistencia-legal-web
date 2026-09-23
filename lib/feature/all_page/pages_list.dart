import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import 'data_source/pages_data_sources.dart';

class PagesList extends StatefulWidget {
  const PagesList({super.key});

  @override
  State<PagesList> createState() => _PagesListDataTableSectionState();
}

class _PagesListDataTableSectionState extends State<PagesList> {

  late PagesDataSource _dessertsDataSource;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _dessertsDataSource = PagesDataSource(
          context,
          false);
      _initialized = true;
      _dessertsDataSource.addListener(() {
        setState(() {});
      });
    }
  }


  @override
  void dispose() {
    _dessertsDataSource.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Expanded(
        child: DataTable2(
          headingRowHeight: Dimensions.headerRowHeight,
          dividerThickness: 0.0,
          horizontalMargin: 0.0,
          minWidth: 600,
          showCheckboxColumn: false,
          headingRowColor:  WidgetStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: 0.03)),
          headingTextStyle: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
          columns:  <DataColumn>[
            DataColumn2(
              label: Text(
                'page_title'.tr,
                textAlign: TextAlign.end,
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'link'.tr,
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
            DataColumn2(
              label: Text(
                'status'.tr,
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
            DataColumn2(
              label: Text(
                'action'.tr,
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
            ),
          ],
          rows: List<DataRow>.generate(_dessertsDataSource.rowCount,
                  (index) => _dessertsDataSource.getRow(index,Colors.white)),
        ),
      ),
    );
  }
}