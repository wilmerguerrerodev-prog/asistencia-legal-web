import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import '../../../components/custom_switch.dart';


class RestorablePaymentMethodsSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<PaymentMethodInfo> desserts) {
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

class PaymentMethodInfo {
  PaymentMethodInfo(
      this.paymentMethodName,
      this.addedAt,
      this.status,
      );

  final int id = _idCounter++;

  final String paymentMethodName;
  final String addedAt;
  final bool status;
  bool selected = false;
}



class PaymentMethodDataSource extends DataTableSource {
  PaymentMethodDataSource.empty(this.context) {
    desserts = [];
  }

  PaymentMethodDataSource(this.context,
      [sortedByCalories = false,
        this.hasRowTaps = false,
        this.hasRowHeightOverrides = false,
        this.hasZebraStripes = false]) {
    desserts = _paymentMethodList;
    if (sortedByCalories) {
      sort((d) => d.paymentMethodName, true);
    }
  }

  final BuildContext context;
  late List<PaymentMethodInfo> desserts;
  bool hasRowTaps = false;
  bool hasRowHeightOverrides = false;
  bool hasZebraStripes = false;

  void sort<T>(Comparable<T> Function(PaymentMethodInfo d) getField, bool ascending) {
    desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  void updateSelectedDesserts(RestorablePaymentMethodsSelections selectedRows) {
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
    if (index >= desserts.length) throw 'index > _paymentMethodList.length';
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
        DataCell(Text((dessert.id + 1).toString())),
        DataCell(Image.asset(dessert.paymentMethodName, scale: 3,),),
        DataCell(Text(dessert.addedAt)),
        DataCell(customSwitch(dessert.status, (){},context)),
        DataCell(Row(
          children: [
            Image.asset(Images.actionEdit,scale: 4,),
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


List<PaymentMethodInfo> _paymentMethodList = <PaymentMethodInfo>[
   PaymentMethodInfo(
    Images.paypal,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.googlePay,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.bitcoin,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.skrill,
    'Feb 02, 2023 04:45 PM',
    true,
  ),

  PaymentMethodInfo(
    Images.googlePay,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.visa,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.stripe,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
     PaymentMethodInfo(
    Images.paytm,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
  PaymentMethodInfo(
    Images.paytm,
    'Feb 02, 2023 04:45 PM',
    true,
  ),
];
