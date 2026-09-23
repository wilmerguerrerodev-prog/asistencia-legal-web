import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/users/data_sources/order_data_source.dart';
import 'package:getdash/utils/dimensions.dart';


class UserOrderList extends StatefulWidget {
  const UserOrderList({Key? key}) : super(key: key);

  @override
  State<UserOrderList> createState() => _AllUserListState();
}

class _AllUserListState extends State<UserOrderList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestoreableUserOrderSelections _userOrderSelections =
  RestoreableUserOrderSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late UserOrderDataSource _dessertsDataSource;
  bool initialized = false;


  @override
  String get restorationId => 'paginated_data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_userOrderSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');


    if (!initialized) {
      _dessertsDataSource = UserOrderDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource.sort<String>((d) => d.sellerInfo, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource.sort<String>((d) => d.totalAmount, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource.sort<String>((d) => d.paymentStatus, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource.sort<String>((d) => d.dateTime, _sortAscending.value);
        break;
    }
    _dessertsDataSource.updateSelectedDesserts(_userOrderSelections);
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _dessertsDataSource = UserOrderDataSource(context);
      initialized = true;
    }
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _userOrderSelections.setDessertSelections(_dessertsDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(UserOrder d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _dessertsDataSource.sort<T>(getField, ascending);
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
    _dessertsDataSource.removeListener(_updateSelectedDessertRowListener);
    _dessertsDataSource.dispose();
    super.dispose();
  }

  onChangedMethod1(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String selectedDuration = 'Last Month';

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child:  Row(
        children: [
          Expanded(
            child: PaginatedDataTable(
              rowsPerPage: _rowsPerPage.value,
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
              onSelectAll: _dessertsDataSource.selectAll,
              columns: [
                DataColumn(
                  label: Text('order_id'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.id, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('seller_info'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.sellerInfo, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('total_amount'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.totalAmount, columnIndex, ascending),
                ),
                DataColumn(
                  label:  Text('payment_status'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.paymentStatus, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('date_time'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.dateTime, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('action'.tr),
                ),
              ],
              source: _dessertsDataSource,
            ),
          ),
        ],
      ),
    );
  }
}
