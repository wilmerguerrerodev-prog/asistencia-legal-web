import 'package:flutter/material.dart';
import 'package:getdash/feature/seller/widget/seller_search_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../../../components/custom_switch.dart';


class SellerProductList extends StatefulWidget {
  const SellerProductList({Key? key}) : super(key: key);

  @override
  State<SellerProductList> createState() => _SellerProductListState();
}

class _SellerProductListState extends State<SellerProductList> {
  bool value1 = true;
  String item1 = "Edit";
  String item2 = "View Details";
  String item3 = "Unverified User";
  String item4 = "Delete User";


  onChangedMethod1(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 900,
      width: (MediaQuery.of(context).size.width - 40),
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child:  Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor,border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraLarge,vertical:Dimensions.paddingSizeLarge ),
          child: Column(
            children: [

              const SizedBox(height: Dimensions.paddingSizeDefault),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Expanded(child: sellerFilterSectionItem(title: "Categories", context: context)),
                Expanded(child: sellerFilterSectionItem(title: "Instructor", context: context)),
                Expanded(child: sellerFilterSectionItem(title: "Course Status", context: context)),
                Expanded(child: sellerFilterSectionItem(title: "Activity", context: context)),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              const SellerSearchSection(),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                    border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: Row(
                  children: [
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: DataTable(
                          headingRowHeight: Dimensions.headerRowHeight,
                          dividerThickness: 0.0,
                          horizontalMargin: 0.0,
                          columns:  <DataColumn>[
                            DataColumn(
                              label: Text(
                                'S/L',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Product Title',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Categories',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Enrolled Students',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Price',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Action',
                                style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),

                          ],
                          rows:  <DataRow>[
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                            dataRow(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow dataRow(BuildContext context){
    return DataRow(
      cells: <DataCell>[
        const DataCell(Text('Leather Analog Watch For Men Round Shape')),
        const DataCell(Text('\$150')),
        const DataCell(Text('309')),
        const DataCell(Text('InStock')),
        const DataCell(Text('\$534.00')),
        DataCell(customSwitch(value1, onChangedMethod1,context)),
        DataCell(PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: item1, child: Text(item1)),
              PopupMenuItem(value: item2, child: Text(item2)),
              PopupMenuItem(value: item3, child: Text(item3)),
              PopupMenuItem(value: item4, child: Text(item4))],
            onSelected: (String newValue){})),
      ],
    );
  }
}

Widget sellerFilterSectionItem({
  required String title,
  required BuildContext context}){
  String selectedDuration = 'All';

  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

    Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
    const SizedBox(height: Dimensions.paddingSizeSmall),
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: DropdownButton<String>(
          underline: const SizedBox(),
          value: selectedDuration,
          items: <String>['All', 'B', 'C', 'D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            selectedDuration = value!;
          },
        ),
      ),
    ),

  ]);
}
