import 'package:flutter/material.dart';
import 'package:getdash/components/custom_switch.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class RestoreableRefundSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};


  bool isSelected(int index) => _dessertSelections.contains(index);


  void setDessertSelections(List<RefundInfo> refundInfoList) {
    final updatedSet = <int>{};
    for (var i = 0; i < refundInfoList.length; i += 1) {
      var dessert = refundInfoList[i];
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


class RefundInfo {
  RefundInfo(
      this.refundDate,
      this.customerInfo,
      this.providerInfo,
      this.totalAmount,
      this.status,
      );

  final int id = _idCounter++;
  final String refundDate;
  final String customerInfo;
  final String providerInfo;
  final int totalAmount;
  final bool status;
  bool selected = false;
}

class RefundDataSource extends DataTableSource {
  RefundDataSource.empty(this.context) {
    refundInfoList = [];
  }

  RefundDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    refundInfoList = _refundList;
  }

  final BuildContext context;
  late List<RefundInfo> refundInfoList;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(RefundInfo d) getField, bool ascending) {
    refundInfoList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestoreableRefundSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < refundInfoList.length; i += 1) {
      var dessert = refundInfoList[i];
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
    if (index >= refundInfoList.length) throw 'index > _refundList.length';
    final dessert = refundInfoList[index];
    return DataRow.byIndex(
      index: index,
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
        DataCell(Text(dessert.id.toString())),
        DataCell(Text(dessert.refundDate)),
        DataCell(Text(dessert.customerInfo),),
        DataCell(Text(dessert.providerInfo)),
        DataCell(Text('${dessert.totalAmount}')),
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
  int get rowCount => refundInfoList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in refundInfoList) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? refundInfoList.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<RefundInfo> _refundList = <RefundInfo>[
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),
  RefundInfo(
    'Jun 12, 2023',
    'Hello Customer',
    'Here Is Provider Info',
    87,
    true
  ),

];

