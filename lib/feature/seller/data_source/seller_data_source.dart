import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import '../../../components/custom_switch.dart';
import '../../../utils/images.dart';


class RestorableSellerSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<SellerInfo> sellerInfoList) {
    final updatedSet = <int>{};
    for (var i = 0; i < sellerInfoList.length; i += 1) {
      var dessert = sellerInfoList[i];
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
class SellerInfo {
  SellerInfo(
      this.seller,
      this.phoneNumber,
      this.totalProducts,
      this.totalCompletedOrder,
      this.status,
      );

  final int id = _idCounter++;

  final Seller seller;
  final String phoneNumber;
  final int totalProducts;
  final int totalCompletedOrder;
  final bool status;
  bool selected = false;
}


class Seller {
  Seller(
      this.imagePath,
      this.name,
      );


  final String imagePath;
  final String name;

}








/// Data source implementing standard Flutter's DataTableSource abstract class
/// which is part of DataTable and PaginatedDataTable synchronous data fecthin API.
/// This class uses static collection of deserts as a data store, projects it into
/// DataRows, keeps track of selected items, provides sprting capability
class SellerDataSource extends DataTableSource {
  SellerDataSource.empty(this.context) {
    sellerInfoList = [];
  }

  SellerDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    sellerInfoList = _sellerInfoList;
    if (sortedByCalories) {
      sort((d) => d.totalCompletedOrder, true);
    }
  }

  final BuildContext context;
  late List<SellerInfo> sellerInfoList;
  // Add row tap handlers and show snackbar
  bool hasRowTaps = false;
  // Override height values for certain rows
  bool hasRowHeightOverrides = false;
  // Color each Row by index's parity
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(SellerInfo d) getField, bool ascending) {
    sellerInfoList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorableSellerSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < sellerInfoList.length; i += 1) {
      var dessert = sellerInfoList[i];
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
    if (index >= sellerInfoList.length) throw 'index > _sellerInfoList.length';
    final dessert = sellerInfoList[index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return Theme.of(context).cardColor;
                // Use default value for other states and odd rows.
          }),
      onSelectChanged: (value) {
        if (dessert.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Row(
          children: [
            Image.asset(dessert.seller.imagePath,scale: 4,),
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            Text(dessert.seller.name),
          ],
        )),
        DataCell(Text(dessert.phoneNumber),),
        DataCell(Text(dessert.totalProducts.toString())),
        DataCell(Text(dessert.totalCompletedOrder.toString())),
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
  int get rowCount => sellerInfoList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void selectAll(bool? checked) {
    for (final dessert in sellerInfoList) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = (checked ?? false) ? sellerInfoList.length : 0;
    notifyListeners();
  }
}

int _selectedCount = 0;


List<SellerInfo> _sellerInfoList = <SellerInfo>[

  SellerInfo(
    Seller(
      Images.sellerLogo,
      'Bessie Cooper'
    ),
    '+8801700000000',
    20,
    24,
    false,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Guy Hawkins'
    ),
    '+8801700000000',
    30,
    24,
    false,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Jerome Bell'
    ),
    '+8801700000000',
    60,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Jenny Wilson'
    ),
    '+8801700000000',
    34,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    89,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Esther Howard'
    ),
    '+8801700000000',
    85,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    65,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Kristin Watson'
    ),
    '+8801700000000',
    45,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Jane Cooper'
    ),
    '+8801700000000',
    35,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    87,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    85,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Devon Lane'
    ),
    '+8801700000000',
    47,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    98,
    24,
    true,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    85,
    24,
    false,
  ),
  SellerInfo(
    Seller(
        Images.sellerLogo,
        'Bessie Cooper'
    ),
    '+8801700000000',
    89,
    24,
    false,
  ),
];