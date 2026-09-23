import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/dashboard/widgets/recent_order_data_source.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class RecentOrders extends StatefulWidget {
  const RecentOrders({super.key});

  @override
  State<RecentOrders> createState() => _AllUserListState();
}

class _AllUserListState extends State<RecentOrders> with RestorationMixin {


  final RestorableRecentOrderSelections _dessertSelections = RestorableRecentOrderSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  late RecentOrderDataSource _recentOrderDataSource;
  bool initialized = false;


  @override
  String get restorationId => 'paginated_data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_dessertSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');


    if (!initialized) {
      _recentOrderDataSource = RecentOrderDataSource(context,);
      initialized = true;
    }
    switch (_sortColumnIndex.value) {
      case 1:
        _recentOrderDataSource.sort<String>((d) => d.orderCode, _sortAscending.value);
        break;
      case 2:
        _recentOrderDataSource.sort<String>((d) => d.customer.customerName, _sortAscending.value);
        break;
      case 3:
        _recentOrderDataSource.sort<String>((d) => d.items, _sortAscending.value);
        break;
      case 7:
        _recentOrderDataSource.sort<String>((d) => d.paymentStatus, _sortAscending.value);
        break;
      case 8:
        _recentOrderDataSource.sort<String>((d) => d.deliveryStatus, _sortAscending.value);
        break;
    }
    _recentOrderDataSource.updateSelectedDesserts(_dessertSelections);
    _recentOrderDataSource.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      _recentOrderDataSource = RecentOrderDataSource(context);
      initialized = true;
    }
    _recentOrderDataSource.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_recentOrderDataSource.desserts);
  }

  void sort<T>(
      Comparable<T> Function(RecentOrderInfo d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _recentOrderDataSource.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex.value = columnIndex;
      _sortAscending.value = ascending;
    });
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _sortColumnIndex.dispose();
    _sortAscending.dispose();
    _recentOrderDataSource.removeListener(_updateSelectedDessertRowListener);
    _recentOrderDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Last Month';

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child:  Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault,vertical:Dimensions.paddingSizeDefault ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('recent_orders'.tr,style: ubuntuMedium.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .8),
                      fontSize: Dimensions.fontSizeLarge
                  ),),
                  DropdownButton<String>(
                    underline: const SizedBox(),
                    value: selectedDuration,
                    items: <String>['Last Month', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: ubuntuMedium.copyWith(
                            color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .8),
                            fontSize: Dimensions.fontSizeLarge),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedDuration = value!;
                    },
                  )
                ],
              ),
              const Divider(),

              Row(
                children: [
                  Expanded(
                    child: PaginatedDataTable(
                      rowsPerPage: _rowsPerPage.value,
                      //headingRowColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                      arrowHeadColor: Colors.green,
                      availableRowsPerPage: const [10,20],
                      showCheckboxColumn: false,
                      onRowsPerPageChanged: (value) {
                        setState(() {
                          _rowsPerPage.value = value!;
                        });
                      },
                      initialFirstRowIndex: _rowIndex.value,
                      onPageChanged: (rowIndex) {
                        setState(() {
                          _rowIndex.value = rowIndex;
                        });
                      },
                      sortColumnIndex: _sortColumnIndex.value,
                      sortAscending: _sortAscending.value,
                      onSelectAll: _recentOrderDataSource.selectAll,
                      columns: [
                        DataColumn(
                          label: Text('order_code'.tr),
                        ),
                        DataColumn(
                          label: Text('customer'.tr),
                          onSort: (columnIndex, ascending) => sort<String>((d) => d.customer.customerName, columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text('items'.tr),
                          onSort: (columnIndex, ascending) => sort<String>((d) => d.items, columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text('payment_status'.tr),
                          onSort: (columnIndex, ascending) => sort<String>((d) => d.paymentStatus, columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text('delivery_status'.tr),
                          onSort: (columnIndex, ascending) => sort<String>((d) => d.deliveryStatus, columnIndex, ascending),
                        ),
                      ],
                      source: _recentOrderDataSource,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
