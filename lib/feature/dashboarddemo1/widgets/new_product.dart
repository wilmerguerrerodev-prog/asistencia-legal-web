import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class NewProduct extends StatelessWidget {
  const NewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "   New Products",
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Expanded(child: bestSellerDataTable(context)),
          ],
        ),
      ),
    );
  }

  DataTable2 bestSellerDataTable(context) {
    return DataTable2(
      headingRowHeight: Dimensions.headerRowHeight,
      dividerThickness: 0.0,
      //horizontalMargin: 0.0,
      minWidth: 700,
      columnSpacing: 10.0,
      headingRowColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
          }
          return Colors.grey
              .withValues(alpha: 0.1); // Adjust the opacity and color as needed
        },
      ),
      decoration: const BoxDecoration(
          //color: Colors.blueGrey
          ),
      columns: <DataColumn>[
        DataColumn2(
          fixedWidth: 200,
          //size: ColumnSize.S,
          label: Text(
            ' PRODUCT NAME',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          size: ColumnSize.S,
          fixedWidth: 80,
          label: Text(
            'DEALS',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          // size: ColumnSize.S,
          label: Text(
            'AMOUNT',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
      ],
      rows: <DataRow2>[
        dataRow1(context),
        dataRow2(context),
        dataRow3(context),
        dataRow4(context),
        dataRow5(context),
        dataRow6(context)
      ],
    );
  }

  DataRow2 dataRow6(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat1,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }

  DataRow2 dataRow5(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat1,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }

  DataRow2 dataRow4(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat4,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }

  DataRow2 dataRow3(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat3,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }

  DataRow2 dataRow2(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat2,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }

  DataRow2 dataRow1(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.glasshat1,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Yellow Glasses Hat',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
          ],
        )),
        DataCell(Text('1561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
        DataCell(Text('38561',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
            ))),
      ],
    );
  }
}
