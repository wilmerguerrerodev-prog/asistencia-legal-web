import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

import '../../../components/custom_switch.dart';


/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableCouponSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a CouponInfo row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [UserInfo]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<CouponInfo> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var subscriberInfo = desserts[i];
      if (subscriberInfo.selected) {
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
class CouponInfo {
  CouponInfo(
      this.couponTitle,
      this.couponCode,
      this.couponType,
      this.discountType,
      this.status,
      );

  final int id = _idCounter++;

  final String couponTitle;
  final String couponCode;
  final String couponType;
  final String discountType;
  final bool status;
  bool selected = false;
}



/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class CouponDataSource extends DataTableSource {
  CouponDataSource.empty(this.context) {
    desserts = [];
  }

  CouponDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
  }

  final BuildContext context;
  late List<CouponInfo> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(CouponInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableCouponSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < desserts.length; i += 1) {
      var subscriberInfo = desserts[i];
      if (selectedRows.isSelected(i)) {
        subscriberInfo.selected = true;
        _selectedCount += 1;
      } else {
        subscriberInfo.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= desserts.length) throw 'index > _users.length';
    final subscriberInfo = desserts[index];
    return DataRow.byIndex(
      index: index,
      // selected: subscriberInfo.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? WidgetStateProperty.all(Theme.of(context).highlightColor)
          : null),
      onSelectChanged: (value) {
        if (subscriberInfo.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          subscriberInfo.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text((subscriberInfo.id + 1).toString())),
        DataCell(Text(subscriberInfo.couponTitle),),
        DataCell(Text(subscriberInfo.couponCode)),
        DataCell(Text(subscriberInfo.couponType)),
        DataCell(customSwitch(subscriberInfo.status, (){

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
  int get rowCount => desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final subscriberInfo in desserts) {
      subscriberInfo.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? desserts.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<CouponInfo> _users = <CouponInfo>[
  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
    '#DFRCFEDTF',
    'First Order',
    'Monthly',
    true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),
 CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),
 CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

  CouponInfo(
    'Bank of America',
      '#DFRCFEDTF',
      'First Order',
      'Monthly',
      true
  ),

];
