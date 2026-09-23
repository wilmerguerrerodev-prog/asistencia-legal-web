import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Last Month';

    return Container(
      height: 702,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child:  Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraLarge,vertical:Dimensions.paddingSizeLarge ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('best_selling_product'.tr,style: ubuntuMedium.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .8),
                      fontSize: Dimensions.fontSizeLarge
                  ),),
                  DropdownButton<String>(
                    underline: const SizedBox(),
                    value: selectedDuration,
                    items: <String>['Last Month', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                          style: ubuntuMedium.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .8),
                      fontSize: Dimensions.fontSizeLarge))
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedDuration = value!;
                    },
                  )
                ],
              ),
              const Divider(),
              Expanded(child: dataTable(context)),
            ],
          ),
        ),
      ),
    );
  }

  DataTable2 dataTable(context){
    return DataTable2(
      dividerThickness: 0.0,
      horizontalMargin: 0.0,
      minWidth: 600,
      columnSpacing: 0,
      columns:  <DataColumn>[
        DataColumn2(
          label: Text(
            'Product',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(

          label: Text(
            'Price',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Total Sell',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'Stock',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),

      ],
      rows:  <DataRow2>[
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
        dataRow2(context),
      ],
    );
  }

  DataRow2 dataRow2(BuildContext context){
    return  DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall),),
                child: Image.asset(Images.headphone)),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            const Text('Leather Watch'),
          ],
        )),
        const DataCell(Text('\$150')),
        const DataCell(Text('309')),
        const DataCell(Text('InStock')),
      ],
    );
  }

}
