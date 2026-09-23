import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/product/product_data_source.dart';


class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _AllUserListState();
}

class _AllUserListState extends State<ProductList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";


  final RestorableProductSelections _dessertSelections =
  RestorableProductSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late ProductDataSource _dessertsDataSource;
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
      _dessertsDataSource = ProductDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource.sort<String>((d) => d.name, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource.sort<String>((d) => d.store, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource.sort<String>((d) => d.category, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource.sort<num>((d) => d.price, _sortAscending.value);
        break;
    }
    _dessertsDataSource.updateSelectedDesserts(_dessertSelections);
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _dessertsDataSource = ProductDataSource(context);
      initialized = true;
    }
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(ProductInfo d) getField,
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
    return Row(
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
            onSelectAll: _dessertsDataSource.selectAll,
            columns: [
              DataColumn(
                label: Text('name'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.name, columnIndex, ascending),
              ),
              DataColumn(label: Text('store'.tr)),
              DataColumn(label:  Text('category'.tr)),
              DataColumn(
                label: Text('price'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<num>((d) => d.price, columnIndex, ascending),
              ),
              DataColumn(label: Text('status'.tr)),

              DataColumn(label: Text('action'.tr)),
            ],
            source: _dessertsDataSource,
          ),
        ),
      ],
    );
  }
}
