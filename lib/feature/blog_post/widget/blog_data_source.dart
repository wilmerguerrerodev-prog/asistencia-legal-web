import 'package:flutter/material.dart';
import 'package:getdash/components/custom_switch.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class RestorableBlogSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [BlogModel]s and saves the row indices of selected rows
  /// into a [Set].
  void setBlogSelections(List<BlogModel> blogs) {
    final updatedSet = <int>{};
    for (var i = 0; i < blogs.length; i += 1) {
      var dessert = blogs[i];
      if (dessert.selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}


int _idCounter = 0;

/// Domain model entity
class BlogModel {
  BlogModel(
      this.blogTitle,
      this.categories,
      this.createdAt,
      this.status,
      );

  final int id = _idCounter++;

  final String blogTitle;
  final String categories;
  final String createdAt;
  final bool status;
  bool selected = false;
}



/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class BlogDataSource extends DataTableSource {
  BlogDataSource.empty(this.context) {
    blogs = [];
  }

  BlogDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    blogs = _blogs;
  }

  final BuildContext context;
  late List<BlogModel> blogs;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(BlogModel d) getField, bool ascending) {
    blogs.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedBlogs(RestorableBlogSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < blogs.length; i += 1) {
      var dessert = blogs[i];
      if (selectedRows.isSelected(i)) {
        dessert.selected = true;
        _selectedCount += 1;
      } else {
        dessert.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= blogs.length) throw 'index > _blogs.length';
    final dessert = blogs[index];
    return DataRow.byIndex(
      index: index,
      // selected: dessert.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? WidgetStateProperty.all(Theme.of(context).highlightColor)
          : null),
      onSelectChanged: (value) {
        if (dessert.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(dessert.blogTitle)),
        DataCell(Text(dessert.categories),),
        DataCell(Text(dessert.createdAt)),
        DataCell(customSwitch(dessert.status, (){

        },context)),
        DataCell(Row(
          children: [
            Image.asset(Images.actionEdit,scale: 3,),
            const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
            Image.asset(Images.actionDelete,scale: 3,),
          ],
        )),
      ],
    );
  }

  @override
  int get rowCount => blogs.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in blogs) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? blogs.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<BlogModel> _blogs = <BlogModel>[
  BlogModel(
    'Blog Title Goes Here',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Ice Cream Sandwich',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Eclair',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Cupcake',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Gingerbread',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Jelly Bean',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Lollipop',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Honeycomb',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Donut',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Apple Pie',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Frozen Yougurt with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Ice Cream Sandich with sugar',
    'Food Category',
    'Jun 12, 2023',
    true,

  ),
  BlogModel(
    'Eclair with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,

  ),
  BlogModel(
    'Cupcake with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Gingerbread with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Jelly Bean with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Lollipop with sugar',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Honeycomd with sugar',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Donut with sugar',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Apple pie with sugar',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Forzen yougurt with honey',
    'Food Category',
    'Jun 12, 2023',
   true,
  ),
  BlogModel(
    'Ice Cream Sandwich with honey',
    'Food Category',
    'Jun 12, 2023',
   true,
  ),
  BlogModel(
    'Eclair with honey',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Cupcake with honey',
    'Food Category',
    'Jun 12, 2023',
   true,
  ),
  BlogModel(
    'Gignerbread with hone',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Jelly Bean with honey',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Lollipop with honey',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Honeycomd with honey',
    'Food Category',
    'Jun 12, 2023',
    true,
  ),
  BlogModel(
    'Donut with honey',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
  BlogModel(
    'Apple pie with honey',
    'Food Category',
    'Jun 12, 2023',
    false,
  ),
];
