import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/users/data_sources/user_data_sources.dart';


class AllUserList extends StatefulWidget {
  const AllUserList({super.key});

  @override
  State<AllUserList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestorableDessertSelections _dessertSelections =
  RestorableDessertSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late UserDataSource _userDataSource;
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
      _userDataSource = UserDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _userDataSource.sort<String>((d) => d.name, _sortAscending.value);
        break;
      case 1:
        _userDataSource.sort<num>((d) => d.totalOrder, _sortAscending.value);
        break;
      case 2:
        _userDataSource.sort<String>((d) => d.phoneNumber, _sortAscending.value);
        break;
      case 3:
        _userDataSource.sort<String>((d) => d.joinDate, _sortAscending.value);
        break;
      case 7:
        _userDataSource.sort<num>((d) => d.iron, _sortAscending.value);
        break;
    }
    _userDataSource.updateSelectedDesserts(_dessertSelections);
    _userDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _userDataSource = UserDataSource(context);
      initialized = true;
    }
    _userDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_userDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(UserInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _userDataSource.sort<T>(getField, ascending);
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
    _userDataSource.removeListener(_updateSelectedDessertRowListener);
    _userDataSource.dispose();
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
            data: Theme.of(context).copyWith(
              cardColor: Theme.of(context).primaryColor,
              dividerTheme: const DividerThemeData(
                thickness: 0,
                color: Colors.transparent,
              ),
            ),
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
              columns: [
                DataColumn(
                  label: Text('name'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.name, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('phone_number'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.totalOrder, columnIndex, ascending),
                ),
                DataColumn(
                  label:  Text('join_date'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.totalOrder, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('total_order'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<num>((d) => d.totalOrder, columnIndex, ascending),
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
              source: _userDataSource,
            ),
          ),
        ),
      ],
    );
  }
}
