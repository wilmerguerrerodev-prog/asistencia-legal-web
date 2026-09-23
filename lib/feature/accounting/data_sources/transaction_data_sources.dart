import 'package:flutter/material.dart';


/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableTransactionSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [UserInfo]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<TransactionInfo> desserts) {
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
class TransactionInfo {
  TransactionInfo(
      this.transactionID,
      this.paymentMethod,
      this.transactionForm,
      this.transactionTo,
      this.amount,
      );

  final int id = _idCounter++;

  final String transactionID;
  final String paymentMethod;
  final String transactionForm;
  final String transactionTo;
  final int amount;
  bool selected = false;
}



/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class TransactionDataSource extends DataTableSource {
  TransactionDataSource.empty(this.context) {
    desserts = [];
  }

  TransactionDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
    if (sortedByCalories) {
      sort((d) => d.amount, true);
    }
  }

  final BuildContext context;
  late List<TransactionInfo> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(TransactionInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableTransactionSelections selectedRows) {
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
        DataCell(Text(dessert.transactionID)),
        DataCell(Text(dessert.paymentMethod),),
        DataCell(Text(dessert.transactionForm)),
        DataCell(Text(dessert.transactionTo)),
        DataCell(Text('${dessert.amount}')),

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


List<TransactionInfo> _users = <TransactionInfo>[
  TransactionInfo(
    'H54SKX65WXRT698V',
    'Credit Card',
    'Ellison Trading',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Ice Cream Sandwich',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of Dhaka',
    87,
  ),
  TransactionInfo(
    'Eclair',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',

    87,
  ),
  TransactionInfo(
    'Cupcake',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Gingerbread',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Jelly Bean',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Lollipop',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Honeycomb',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Donut',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Apple Pie',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of India',
    87,
  ),
  TransactionInfo(
    'Frozen Yougurt with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Ice Cream Sandich with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,

  ),
  TransactionInfo(
    'Eclair with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,

  ),
  TransactionInfo(
    'Cupcake with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Gingerbread with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Jelly Bean with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Lollipop with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Honeycomd with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Donut with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Apple pie with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Forzen yougurt with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Ice Cream Sandwich with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Eclair with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Cupcake with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Gignerbread with hone',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Jelly Bean with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Lollipop with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Honeycomd with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Donut with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
  TransactionInfo(
    'Apple pie with honey',
    '+8801700000000',
    'Jun 12, 2023',
    'Bank of America',
    87,
  ),
];


