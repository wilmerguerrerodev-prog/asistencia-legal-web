import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'blog_data_source.dart';


class AllBlogList extends StatefulWidget {
  const AllBlogList({Key? key}) : super(key: key);

  @override
  State<AllBlogList> createState() => _AllUserListState();
}

class _AllUserListState extends State<AllBlogList> with RestorationMixin {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";



  final RestorableBlogSelections _dessertSelections =
  RestorableBlogSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late BlogDataSource _usersDataSource;
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
      _usersDataSource = BlogDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 0:
        _usersDataSource.sort<String>((d) => d.blogTitle, _sortAscending.value);
        break;
      case 1:
        _usersDataSource.sort<String>((d) => d.categories, _sortAscending.value);
        break;
      case 2:
        _usersDataSource.sort<String>((d) => d.createdAt, _sortAscending.value);
        break;
    }
    _usersDataSource.updateSelectedBlogs(_dessertSelections);
    _usersDataSource.addListener(_updateSelectedBlogRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _usersDataSource = BlogDataSource(context);
      initialized = true;
    }
    _usersDataSource.addListener(_updateSelectedBlogRowListener);
  }

  void _updateSelectedBlogRowListener() {
    _dessertSelections.setBlogSelections(_usersDataSource.blogs);
  }

  void sort<T>(
      Comparable<T> Function(BlogModel d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _usersDataSource.sort<T>(getField, ascending);
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
    _usersDataSource.removeListener(_updateSelectedBlogRowListener);
    _usersDataSource.dispose();
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

    return Row(
      children: [
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent),
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
              onSelectAll: _usersDataSource.selectAll,
              columns: [
                DataColumn(
                  label: Text('blog_title'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.blogTitle, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('categories'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.categories, columnIndex, ascending),
                ),
                DataColumn(
                  label:  Text('created_at'.tr),
                  onSort: (columnIndex, ascending) =>
                      sort<String>((d) => d.createdAt, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text('status'.tr),
                ),

                DataColumn(
                  label: Text('action'.tr),
                ),
              ],
              source: _usersDataSource,
            ),
          ),
        ),
      ],
    );
  }
}
