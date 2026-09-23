import 'package:flutter/material.dart';
import 'package:getdash/utils/styles.dart';


/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableRecentOrderSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a bankAccountInfo row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [UserInfo]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<RecentOrderInfo> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var bankAccountInfo = desserts[i];
      if (bankAccountInfo.selected) {
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
class RecentOrderInfo {
  RecentOrderInfo(
      this.orderCode,
      this.customer,
      this.items,
      this.paymentStatus,
      this.deliveryStatus,
      );

  final int id = _idCounter++;

  final String orderCode;
  final CustomerInfo customer;
  final String items;
  final String paymentStatus;
  final String deliveryStatus;
  bool selected = false;
}

class CustomerInfo {

  CustomerInfo(
      this.customerName,
      this.contactInfo
      );

  final String customerName;
  final String contactInfo;
}


class RecentOrderDataSource extends DataTableSource {
  RecentOrderDataSource.empty(this.context) {
    desserts = [];
  }

  RecentOrderDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
  }

  final BuildContext context;
  late List<RecentOrderInfo> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(RecentOrderInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableRecentOrderSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < desserts.length; i += 1) {
      var bankAccountInfo = desserts[i];
      if (selectedRows.isSelected(i)) {
        bankAccountInfo.selected = true;
        _selectedCount += 1;
      } else {
        bankAccountInfo.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index, [Color? color]) {

    assert(index >= 0);
    if (index >= desserts.length) throw 'index > _users.length';
    final bankAccountInfo = desserts[index];
    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.all(Theme.of(context).cardColor),
      onSelectChanged: (value) {
        if (bankAccountInfo.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          bankAccountInfo.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(bankAccountInfo.orderCode),),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bankAccountInfo.customer.customerName),
            Text(bankAccountInfo.customer.contactInfo),
          ],
        )),
        DataCell(Text(bankAccountInfo.items)),

        DataCell(Text(
          bankAccountInfo.paymentStatus,
          style: ubuntuMedium.copyWith(color: bankAccountInfo.paymentStatus == "paid" ? Colors.cyan : Theme.of(context).colorScheme.secondary),)),


        DataCell(Text(bankAccountInfo.deliveryStatus)),
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
    for (final bankAccountInfo in desserts) {
      bankAccountInfo.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? desserts.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<RecentOrderInfo> _users = <RecentOrderInfo>[
  RecentOrderInfo(
    '#12REGGTTF785L',
    CustomerInfo(
        "Robert Jacobs",
      "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Done',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',
    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Pending',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Confirmed',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Complete',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',
    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Complete',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Approved',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    'Pending',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),
  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  RecentOrderInfo(
    '#12REGGTTF785L',

    CustomerInfo(
        "Robert Jacobs",
        "+8801703901010"
    ),
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

];
