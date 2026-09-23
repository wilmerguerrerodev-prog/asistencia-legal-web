import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

class RestorableSalesReportSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<SalesReportModel> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
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
class SalesReportModel {
  SalesReportModel(
      this.orderId,
      this.customerName,
      this.sellerInfo,
      this.orderAmount,
      );

  final int id = _idCounter++;

  final String orderId;
  final String customerName;
  final String sellerInfo;
  final int orderAmount;
  bool selected = false;
}



/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class SalesReportDataSource extends DataTableSource {
  SalesReportDataSource.empty(this.context) {
    desserts = [];
  }

  SalesReportDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;

  }

  final BuildContext context;
  late List<SalesReportModel> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(SalesReportModel d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableSalesReportSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
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
    if (index >= desserts.length) throw 'index > _users.length';
    final dessert = desserts[index];
    return DataRow.byIndex(
      index: index,
      // selected: dessert.selected,
      color: color != null
          ? MaterialStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? MaterialStateProperty.all(Theme.of(context).highlightColor)
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
        DataCell(Text(dessert.orderId)),
        DataCell(Text(dessert.customerName),),
        DataCell(Text(dessert.sellerInfo)),
        DataCell(Text('${dessert.orderAmount}')),
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
  int get rowCount => desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in desserts) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? desserts.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<SalesReportModel> _users = <SalesReportModel>[
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),
  SalesReportModel(
    '#4586551336562',
    'Hello John',
    'Jane Cooper',
    240,
  ),

];
