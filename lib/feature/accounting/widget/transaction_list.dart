import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/accounting/data_sources/transaction_data_sources.dart';


class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _AllUserListState();
}

class _AllUserListState extends State<TransactionList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestorableTransactionSelections _dessertSelections =
  RestorableTransactionSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late TransactionDataSource _dessertsDataSource;
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
      _dessertsDataSource = TransactionDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource.sort<String>((d) => d.transactionID, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource.sort<String>((d) => d.paymentMethod, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource.sort<String>((d) => d.transactionForm, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource.sort<String>((d) => d.transactionTo, _sortAscending.value);
        break;
      case 7:
        _dessertsDataSource.sort<num>((d) => d.amount, _sortAscending.value);
        break;
    }
    _dessertsDataSource.updateSelectedDesserts(_dessertSelections);
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _dessertsDataSource = TransactionDataSource(context);
      initialized = true;
    }
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(TransactionInfo d) getField,
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
            //headingRowColor:  MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),

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
                label: Text('transaction_id'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.transactionID, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('payment_method'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.paymentMethod, columnIndex, ascending),
              ),
              DataColumn(
                label:  Text('transaction_from'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.transactionForm, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('transaction_to'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.transactionTo, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('amount'.tr),
              ),
            ],
            source: _dessertsDataSource,
          ),
        ),
      ],
    );
  }
}
