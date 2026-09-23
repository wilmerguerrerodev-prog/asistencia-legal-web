import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/utils/dimensions.dart';
import 'coupon_data_source.dart';


class CouponList extends StatefulWidget {
  const CouponList({super.key});

  @override
  State<CouponList> createState() => _AllUserListState();
}

class _AllUserListState extends State<CouponList> with RestorationMixin {


  final RestorableCouponSelections _dessertSelections = RestorableCouponSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late CouponDataSource _couponDataSource;
  bool initialized = false;


  @override
  String get restorationId => 'paginated_data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_dessertSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');


    if (!initialized) {
      _couponDataSource = CouponDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _couponDataSource.sort<num>((d) => d.id, _sortAscending.value);
        break;
      case 1:
        _couponDataSource.sort<String>((d) => d.couponTitle, _sortAscending.value);
        break;
      case 2:
        _couponDataSource.sort<String>((d) => d.couponCode, _sortAscending.value);
        break;
      case 3:
        _couponDataSource.sort<String>((d) => d.couponType, _sortAscending.value);
        break;
    }
    _couponDataSource.updateSelectedDesserts(_dessertSelections);
    _couponDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _couponDataSource = CouponDataSource(context);
      initialized = true;
    }
    _couponDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_couponDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(CouponInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _couponDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex.value = columnIndex;
      _sortAscending.value = ascending;
    });
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _sortColumnIndex.dispose();
    _sortAscending.dispose();
    _couponDataSource.removeListener(_updateSelectedDessertRowListener);
    _couponDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Row(
          children: [
            Expanded(
              child: PaginatedDataTable(
                rowsPerPage: _rowsPerPage.value,
               // headingRowColor: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),

                showCheckboxColumn: false,
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _rowsPerPage.value = value!;
                  });
                },
                initialFirstRowIndex: _rowIndex.value,
                onPageChanged: (rowIndex) {
                  setState(() {
                    _rowIndex.value = rowIndex;
                  });
                },
                sortColumnIndex: _sortColumnIndex.value,
                sortAscending: _sortAscending.value,
                onSelectAll: _couponDataSource.selectAll,
                columns: [
                  DataColumn(
                    label: Text('sl'.tr),
                  ),
                  DataColumn(
                    label: Text('coupon_title'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.couponTitle, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('coupon_code'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.couponCode, columnIndex, ascending),
                  ),
                  DataColumn(
                    label:  Text('coupon_type'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.couponType, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('discount_type'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.discountType, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('action'.tr),
                  ),
                ],
                source: _couponDataSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
