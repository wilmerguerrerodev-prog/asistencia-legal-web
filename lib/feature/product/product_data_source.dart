import 'package:flutter/material.dart';
import 'package:getdash/components/custom_switch.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class RestorableProductSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<ProductInfo> desserts) {
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

class ProductInfo {
  ProductInfo(
      this.name,
      this.store,
      this.category,
      this.price,
      this.status,
      );

  final int id = _idCounter++;

  final String name;
  final String store;
  final String category;
  final int price;
  final bool status;
  bool selected = false;
}

class ProductDataSource extends DataTableSource {
  ProductDataSource.empty(this.context) {
    desserts = [];
  }

  ProductDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _productInfoList;
  }

  final BuildContext context;
  late List<ProductInfo> desserts;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(ProductInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableProductSelections selectedRows) {
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
    if (index >= desserts.length) throw 'index > _productInfoList.length';
    final dessert = desserts[index];
    return DataRow.byIndex(
      index: index,
      color: color != null
          ? WidgetStateProperty.all(color)
          : (hasZebraStripes && index.isEven
          ? WidgetStateProperty.all(Theme.of(context).cardColor)
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
        DataCell(Text(dessert.name)),
        DataCell(Text(dessert.store),),
        DataCell(Text(dessert.category)),
        DataCell(Text('${dessert.price}')),
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


List<ProductInfo> _productInfoList = <ProductInfo>[
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),
  ProductInfo(
    'Frozen Yogurt',
    'Store',
    'Food',
    24,
    true,
  ),

];
