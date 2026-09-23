import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_switch.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import '../../../utils/images.dart';


class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<UserInfo> desserts) {
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

class UserInfo {
  UserInfo(
      this.name,
      this.phoneNumber,
      this.joinDate,
      this.totalOrder,
      this.status,
      this.iron,
      );

  final int id = _idCounter++;

  final String name;
  final String phoneNumber;
  final String joinDate;
  final int totalOrder;
  final bool status;
  final int iron;
  bool selected = false;
}



class UserDataSource extends DataTableSource {
  UserDataSource.empty(this.context) {
    desserts = [];
  }

  UserDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _users;
    if (sortedByCalories) {
      sort((d) => d.totalOrder, true);
    }
  }

  final BuildContext context;
  late List<UserInfo> desserts;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(UserInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableDessertSelections selectedRows) {
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
      color: (hasZebraStripes && index.isEven
          ? MaterialStateProperty.all(Theme.of(context).primaryColor)
          : null),

      onSelectChanged: (value) {
        if (dessert.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();

          if(value){
            Get.toNamed(RouteHelper.getUserProfileScreen());
          }
        }
      },
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(Images.profileImageTwo,width: Dimensions.tableImageSize,height: Dimensions.tableImageSize,),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Text(dessert.name),
          ],
        )),
        DataCell(Text(dessert.phoneNumber),),
        DataCell(Text(dessert.joinDate)),
        DataCell(Text('${dessert.totalOrder}')),
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


List<UserInfo> _users = <UserInfo>[
  UserInfo(
    'Frozen Yogurt',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Ice Cream Sandwich',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Eclair',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Cupcake',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Gingerbread',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Jelly Bean',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Lollipop',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Honeycomb',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Donut',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Apple Pie',
    '+8801700000000',
    'Jun 12, 2023',
    20,
    true,
    87,
  ),
  UserInfo(
    'Frozen Yougurt with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Ice Cream Sandich with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,

  ),
  UserInfo(
    'Eclair with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,

  ),
  UserInfo(
    'Cupcake with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Gingerbread with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Jelly Bean with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Lollipop with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Honeycomd with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Donut with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Apple pie with sugar',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Forzen yougurt with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Ice Cream Sandwich with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Eclair with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Cupcake with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Gignerbread with hone',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Jelly Bean with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Lollipop with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Honeycomd with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    true,
    87,
  ),
  UserInfo(
    'Donut with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
  UserInfo(
    'Apple pie with honey',
    '+8801700000000',
    'Jun 12, 2023',
    24,
    false,
    87,
  ),
];

