import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/accounting/data_sources/bank_account_data_sources.dart';


class BankAccountList extends StatefulWidget {
  const BankAccountList({Key? key}) : super(key: key);

  @override
  State<BankAccountList> createState() => _AllUserListState();
}

class _AllUserListState extends State<BankAccountList> with RestorationMixin {


  final RestorableBankAccountSelections _dessertSelections =
  RestorableBankAccountSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late BankAccountDataSource _bankAccountDataSource;
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
      _bankAccountDataSource = BankAccountDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _bankAccountDataSource.sort<num>((d) => d.id, _sortAscending.value);
        break;
      case 1:
        _bankAccountDataSource.sort<String>((d) => d.bankName, _sortAscending.value);
        break;
      case 2:
        _bankAccountDataSource.sort<String>((d) => d.branchName, _sortAscending.value);
        break;
      case 3:
        _bankAccountDataSource.sort<String>((d) => d.accountNo, _sortAscending.value);
        break;
      case 7:
        _bankAccountDataSource.sort<String>((d) => d.accountHolderName, _sortAscending.value);
        break;
      case 8:
        _bankAccountDataSource.sort<String>((d) => d.currentBalance, _sortAscending.value);
        break;
    }
    _bankAccountDataSource.updateSelectedDesserts(_dessertSelections);
    _bankAccountDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _bankAccountDataSource = BankAccountDataSource(context);
      initialized = true;
    }
    _bankAccountDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_bankAccountDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(BankAccountInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _bankAccountDataSource.sort<T>(getField, ascending);
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
    _bankAccountDataSource.removeListener(_updateSelectedDessertRowListener);
    _bankAccountDataSource.dispose();
    super.dispose();
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
            onSelectAll: _bankAccountDataSource.selectAll,
            columns: [
              DataColumn(
                label: Text('sl'.tr),
              ),
              DataColumn(
                label: Text('bank_name'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.bankName, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('branch_name'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.bankName, columnIndex, ascending),
              ),
              DataColumn(
                label:  Text('account_no'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.accountNo, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('account_holder_name'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.accountHolderName, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('current_balance'.tr),
              ),

              DataColumn(
                label: Text('action'.tr),
              ),
            ],
            source: _bankAccountDataSource,
          ),
        ),
      ],
    );
  }
}