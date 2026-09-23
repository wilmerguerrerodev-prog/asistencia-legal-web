import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/marketing/widget/subscriber_data_source.dart';
import 'package:getdash/utils/dimensions.dart';


class SubscriberList extends StatefulWidget {
  const SubscriberList({Key? key}) : super(key: key);

  @override
  State<SubscriberList> createState() => _AllUserListState();
}

class _AllUserListState extends State<SubscriberList> with RestorationMixin {


  final RestorableSubscriberSelections _dessertSelections =
  RestorableSubscriberSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late SubscriberDataSource _subscriberDataSource;
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
      _subscriberDataSource = SubscriberDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _subscriberDataSource.sort<num>((d) => d.id, _sortAscending.value);
        break;
      case 1:
        _subscriberDataSource.sort<String>((d) => d.emailAddress, _sortAscending.value);
        break;
      case 2:
        _subscriberDataSource.sort<String>((d) => d.subscribeAt, _sortAscending.value);
        break;
    }
    _subscriberDataSource.updateSelectedDesserts(_dessertSelections);
    _subscriberDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _subscriberDataSource = SubscriberDataSource(context);
      initialized = true;
    }
    _subscriberDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_subscriberDataSource.subscribers);
  }

  void sort<T>(
      Comparable<T> Function(SubscriberInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _subscriberDataSource.sort<T>(getField, ascending);
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
    _subscriberDataSource.removeListener(_updateSelectedDessertRowListener);
    _subscriberDataSource.dispose();
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
                showCheckboxColumn: false,
               // headingRowColor: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),
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
                onSelectAll: _subscriberDataSource.selectAll,
                columns: [
                  DataColumn(
                    label: Text('sl'.tr),
                  ),
                  DataColumn(
                    label: Text('email_address'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.emailAddress, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('subscribe_at'.tr),
                    onSort: (columnIndex, ascending) =>
                        sort<String>((d) => d.subscribeAt, columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('action'.tr),
                  ),
                ],
                source: _subscriberDataSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
