import 'package:flutter/material.dart';
import 'package:getdash/components/custom_image.dart';
import 'package:getdash/components/custom_switch.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class RestorableNotificationSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<NotificationInfo> desserts) {
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

class NotificationInfo {
  NotificationInfo(
      this.title,
      this.image,
      this.receiver,
      this.status,
      );

  final int id = _idCounter++;

  final String title;
  final String image;
  final String receiver;
  final bool status;
  bool selected = false;
}


class NotificationDataSource extends DataTableSource {
  NotificationDataSource.empty(this.context) {
    desserts = [];
  }

  NotificationDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _notificationList;
  }

  final BuildContext context;
  late List<NotificationInfo> desserts;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(NotificationInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableNotificationSelections selectedRows) {
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
    if (index >= desserts.length) throw 'index > _notificationList.length';
    final dessert = desserts[index];
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
        DataCell(Text(dessert.title)),
        const DataCell(Padding(
          padding: EdgeInsets.all(5.0),
          child: CustomImage(
            width: 50,
            height: 50,
            image: '',),
        ),),
        DataCell(Text(dessert.receiver)),
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


List<NotificationInfo> _notificationList = <NotificationInfo>[
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),
  NotificationInfo(
    'Here Is Notification Title',
    'image',
    'Provider, Teacher, Customer',
    true,
  ),

];

