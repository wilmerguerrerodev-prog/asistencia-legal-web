import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/notification/widgets/notification_data_source.dart';
import 'package:getdash/feature/users/data_sources/user_data_sources.dart';

class AllNotificationList extends StatefulWidget {
  const AllNotificationList({Key? key}) : super(key: key);

  @override
  State<AllNotificationList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllNotificationList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestorableNotificationSelections _dessertSelections = RestorableNotificationSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late NotificationDataSource _notificationDataSource;
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
      _notificationDataSource = NotificationDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _notificationDataSource.sort<String>((d) => d.title, _sortAscending.value);
        break;
      case 1:
        _notificationDataSource.sort<String>((d) => d.image, _sortAscending.value);
        break;
      case 2:
        _notificationDataSource.sort<String>((d) => d.receiver, _sortAscending.value);
        break;
    }
    _notificationDataSource.updateSelectedDesserts(_dessertSelections);
    _notificationDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _notificationDataSource = NotificationDataSource(context);
      initialized = true;
    }
    _notificationDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_notificationDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(UserInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
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
    _notificationDataSource.removeListener(_updateSelectedDessertRowListener);
    _notificationDataSource.dispose();
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
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: PaginatedDataTable(
              //headingRowColor: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03)),
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
              onSelectAll: _notificationDataSource.selectAll,
              columns: [
                DataColumn(
                  label: Text('title'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.name, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('image'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.totalOrder, columnIndex, ascending),
                ),
                DataColumn(
                  label:  Text('receiver'.tr),
                  onSort: (columnIndex, ascending) => sort<num>((d) => d.totalOrder, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('status'.tr),
                ),
                DataColumn(
                  label: Text('action'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.iron, columnIndex, ascending),
                ),
              ],
              source: _notificationDataSource,
            ),
          ),
        ),
      ],
    );
  }
}
