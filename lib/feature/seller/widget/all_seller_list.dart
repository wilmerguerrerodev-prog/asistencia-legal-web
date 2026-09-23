import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/seller/data_source/seller_data_source.dart';


class AllSellerList extends StatefulWidget {
  const AllSellerList({super.key});

  @override
  State<AllSellerList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllSellerList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestorableSellerSelections _dessertSelections =
  RestorableSellerSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late SellerDataSource _sellerDataSource;
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
      _sellerDataSource = SellerDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _sellerDataSource.sort<String>((d) => d.seller.name, _sortAscending.value);
        break;
      case 1:
        _sellerDataSource.sort<num>((d) => d.totalProducts, _sortAscending.value);
        break;
      case 2:
        _sellerDataSource.sort<String>((d) => d.phoneNumber, _sortAscending.value);
        break;
      case 3:
        _sellerDataSource.sort<num>((d) => d.totalCompletedOrder, _sortAscending.value);
        break;

    }
    _sellerDataSource.updateSelectedDesserts(_dessertSelections);
    _sellerDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _sellerDataSource = SellerDataSource(context);
      initialized = true;
    }
    _sellerDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_sellerDataSource.sellerInfoList);
  }

  void sort<T>(
      Comparable<T> Function(SellerInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _sellerDataSource.sort<T>(getField, ascending);
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
    _sellerDataSource.removeListener(_updateSelectedDessertRowListener);
    _sellerDataSource.dispose();
    super.dispose();
  }

  onChangedMethod1(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: PaginatedDataTable(
            rowsPerPage: _rowsPerPage.value,
            //headingRowColor: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),
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
            onSelectAll: _sellerDataSource.selectAll,
            columns: [
              DataColumn(
                label: Text('seller'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.seller.name, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('contact_info'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.phoneNumber, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('total_products'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<num>((d) => d.totalProducts, columnIndex, ascending),
              ),
              DataColumn(
                label:  Text('total_order'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<num>((d) => d.totalCompletedOrder, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('status'.tr),
              ),

              DataColumn(
                label: Text('action'.tr),
              ),
            ],
            source: _sellerDataSource,
          ),
        ),
      ],
    );
  }
}
