import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class RestorableSubscriberSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<SubscriberInfo> subscribers) {
    final updatedSet = <int>{};
    for (var i = 0; i < subscribers.length; i += 1) {
      var subscriberInfo = subscribers[i];
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
class SubscriberInfo {
  SubscriberInfo(
      this.emailAddress,
      this.subscribeAt,
      );

  final int id = _idCounter++;

  final String emailAddress;
  final String subscribeAt;
  bool selected = false;
}

class SubscriberDataSource extends DataTableSource {
  SubscriberDataSource.empty(this.context) {
    subscribers = [];
  }

  SubscriberDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    subscribers = _subscriberList;
  }

  final BuildContext context;
  late List<SubscriberInfo> subscribers;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(SubscriberInfo d) getField, bool ascending) {
    subscribers.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableSubscriberSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < subscribers.length; i += 1) {
      var subscriberInfo = subscribers[i];
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
    if (index >= subscribers.length) throw 'index > _subscriberList.length';
    final subscriberInfo = subscribers[index];
    return DataRow.byIndex(
      index: index,
      // selected: subscriberInfo.selected,
      color: color != null
          ? MaterialStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? MaterialStateProperty.all(Theme.of(context).highlightColor)
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
        DataCell(Text(subscriberInfo.emailAddress),),
        DataCell(Text(subscriberInfo.subscribeAt)),
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
  int get rowCount => subscribers.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final subscriberInfo in subscribers) {
      subscriberInfo.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? subscribers.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<SubscriberInfo> _subscriberList = <SubscriberInfo>[
  SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
  SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
  SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
  SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
  SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),
SubscriberInfo(
    'demo@gmail.com',
    '15 March 2020',
  ),

];
