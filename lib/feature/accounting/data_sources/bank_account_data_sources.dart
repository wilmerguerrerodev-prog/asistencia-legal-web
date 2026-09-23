import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableBankAccountSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a bankAccountInfo row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [UserInfo]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<BankAccountInfo> desserts) {
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
class BankAccountInfo {
  BankAccountInfo(
      this.bankName,
      this.branchName,
      this.accountNo,
      this.accountHolderName,
      this.currentBalance,
      );

  final int id = _idCounter++;

  final String bankName;
  final String branchName;
  final String accountNo;
  final String accountHolderName;
  final String currentBalance;
  bool selected = false;
}



/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class BankAccountDataSource extends DataTableSource {
  BankAccountDataSource.empty(this.context) {
    desserts = [];
  }

  BankAccountDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
  }

  final BuildContext context;
  late List<BankAccountInfo> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(BankAccountInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableBankAccountSelections selectedRows) {
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
      // selected: bankAccountInfo.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? WidgetStateProperty.all(Theme.of(context).highlightColor)
          : null),
      onSelectChanged: (value) {
        if (bankAccountInfo.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          bankAccountInfo.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text((bankAccountInfo.id + 1).toString())),
        DataCell(Text(bankAccountInfo.bankName),),
        DataCell(Text(bankAccountInfo.branchName)),
        DataCell(Text(bankAccountInfo.accountNo)),
        DataCell(Text(bankAccountInfo.accountHolderName)),
        DataCell(Text(bankAccountInfo.currentBalance)),
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
    for (final bankAccountInfo in desserts) {
      bankAccountInfo.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? desserts.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<BankAccountInfo> _users = <BankAccountInfo>[
  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

  BankAccountInfo(
    'Bank of America',
    'Los Angeles',
    '47842158321578',
    'Arlene McCoy',
    '\$800.00',
  ),

];


