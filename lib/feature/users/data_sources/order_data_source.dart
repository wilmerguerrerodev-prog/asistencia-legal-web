import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import '../../../utils/images.dart';


class RestoreableUserOrderSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<UserOrder> desserts) {
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


int _idCounter = 1;

class UserOrder {
  UserOrder(
      this.sellerInfo,
      this.totalAmount,
      this.paymentStatus,
      this.dateTime,
      this.status,
      );

  final int id = _idCounter++;

  final String sellerInfo;
  final String totalAmount;
  final String paymentStatus;
  final String dateTime;
  final bool status;
  bool selected = false;
}


class UserOrderDataSource extends DataTableSource {
  UserOrderDataSource.empty(this.context) {
    desserts = [];
  }

  UserOrderDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
  }

  final BuildContext context;
  late List<UserOrder> desserts;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(UserOrder d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestoreableUserOrderSelections selectedRows) {
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
      color: color != null
          ? MaterialStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? MaterialStateProperty.all(Theme.of(context).primaryColor)
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
        DataCell(Text(dessert.id.toString())),
        DataCell(Text(dessert.sellerInfo)),
        DataCell(Text(dessert.totalAmount),),
        DataCell(Text(dessert.paymentStatus)),
        DataCell(Text(dessert.dateTime)),
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


List<UserOrder> _users = <UserOrder>[

  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),
  UserOrder(
    'Global Smart Seller',
    '250',
    'Complete',
    '15 September 2025',
    true,
  ),

];

