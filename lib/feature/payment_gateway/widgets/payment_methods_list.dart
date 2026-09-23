import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/payment_gateway/widgets/payment_methods_data_source.dart';


class PaymentMethodsList extends StatefulWidget {
  const PaymentMethodsList({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsList> createState() => _AllUserListState();
}

class _AllUserListState extends State<PaymentMethodsList> with RestorationMixin {

  final RestorablePaymentMethodsSelections _dessertSelections =
  RestorablePaymentMethodsSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late PaymentMethodDataSource _dessertsDataSource;
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
      _dessertsDataSource = PaymentMethodDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource.sort<num>((d) => d.id, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource.sort<String>((d) => d.paymentMethodName, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource.sort<String>((d) => d.addedAt, _sortAscending.value);
        break;
    }
    _dessertsDataSource.updateSelectedDesserts(_dessertSelections);
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _dessertsDataSource = PaymentMethodDataSource(context);
      initialized = true;
    }
    _dessertsDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(PaymentMethodInfo d) getField,
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

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: PaginatedDataTable(
            rowsPerPage: _rowsPerPage.value,
            showCheckboxColumn: false,
           // headingRowColor:  MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),
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
                label: Text('S. No'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<num>((d) => d.id, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('payment_method_name'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.paymentMethodName, columnIndex, ascending),
              ),
              DataColumn(
                label:  Text('added_at'.tr),
                onSort: (columnIndex, ascending) =>
                    sort<String>((d) => d.addedAt, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('status'.tr),
              ),
              DataColumn(
                label: Text('action'.tr),
              ),
            ],
            source: _dessertsDataSource,
          ),
        ),
      ],
    );
  }
}
