import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class BestSellers extends StatelessWidget {
  const BestSellers({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Today';

    return Container(
      height: 380,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraLarge,vertical:Dimensions.paddingSizeLarge ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Best Sellers",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                DropdownButton<String>(
                  underline: const SizedBox(),
                  value: selectedDuration,
                  items: <String>['Today', 'B', 'C', 'D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedDuration = value!;
                  },
                )
              ],
            ),
            const Divider(),
            Expanded(child: bestSellerDataTable(context)),
          ],
        ),
      ),
    );
  }

  DataTable2 bestSellerDataTable(context){
    return DataTable2(
      headingRowHeight: Dimensions.headerRowHeight,
      dividerThickness: 0.0,
      horizontalMargin: 0.0,
      minWidth: 700,
      columnSpacing: 10,
      columns:  <DataColumn>[
        DataColumn2(
          size: ColumnSize.L,
          label: Text(
            'Seller Name',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Company',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Products',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Profit',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Status',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
      ],
      rows:  <DataRow2>[
        dataRow(context),
        dataRow(context),
        dataRow(context),
        dataRow(context),
        dataRow(context),
      ],
    );
  }

  DataRow2 dataRow(BuildContext context){
    return DataRow2(
      cells: <DataCell>[
        DataCell(
            Row(
              children: [
                Image.asset(Images.profileImageTwo,height: 40,width: 40,),
                const SizedBox(width: Dimensions.paddingSizeDefault,),
                Text('Daniel Clinton',style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),),
              ],
            )
        ),

          DataCell(Text('Meta',style: ubuntuRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          ))),
          DataCell(Text('12',style: ubuntuRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          ))),
          DataCell(Text('120',style: ubuntuRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          ))),
          DataCell(Text('Approved',style: ubuntuRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
          ),),)
      ],
    );
  }
}
