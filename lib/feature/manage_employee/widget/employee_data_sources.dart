import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


/// Keeps track of selected rows, feed the data into DesertsDataSource
class RestorableEmployeeSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [EmployeeInfoModel]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<EmployeeInfoModel> desserts) {
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
class EmployeeInfoModel {
  EmployeeInfoModel(
      this.name,
      this.phone,
      this.role,
      this.status
      );

  final int id = _idCounter++;

  final String name;
  final String phone;
  final String role;
  final bool status;
  bool selected = false;
}



class EmployeeDataSource extends DataTableSource {
  EmployeeDataSource.empty(this.context) {
    desserts = [];
  }

  EmployeeDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _desserts;
  }

  final BuildContext context;
  late List<EmployeeInfoModel> desserts;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(EmployeeInfoModel d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableEmployeeSelections selectedRows) {
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
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= desserts.length) throw 'index > _desserts.length';
    final dessert = desserts[index];
    return DataRow2.byIndex(
      index: index,
      selected: dessert.selected,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? WidgetStateProperty.all(Theme.of(context).highlightColor)
          : null),

      cells: [
        DataCell(Container(
          margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Text("Cameron Williamson",style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
        )),
        DataCell(Text(dessert.phone,style: ubuntuRegular.copyWith(
            color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
            fontSize: Dimensions.fontSizeExtraSmall)),),
        DataCell(Text(dessert.role,style: ubuntuRegular.copyWith(
          color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
            fontSize: Dimensions.fontSizeExtraSmall)),),
        DataCell(customSwitch(dessert.status, (){},context),),
        const DataCell(Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Icon(Icons.more_horiz),
          ),
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

List<EmployeeInfoModel> _desserts = <EmployeeInfoModel>[
  EmployeeInfoModel(
    'Frozen One',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),  EmployeeInfoModel(
    'Frozen Yogurt',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),

  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
  EmployeeInfoModel(
    'Eclair with sugar',
    '+8801703907085',
    'Senior Digital Marketer',
    true,
  ),
];

Widget customSwitch(bool val, Function onChangedMethod,context){
  return Transform.scale(
    scale: 0.6,
    child: CupertinoSwitch(inactiveTrackColor: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),activeTrackColor: Theme.of(context).primaryColor,value: val, onChanged: (newValue){
      onChangedMethod(newValue);
    }),
  );
}
