import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    //

    return Container(
      height: 380,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge,
            vertical: Dimensions.paddingSizeLarge),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Users",
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFE3D5F4),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Active",
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Inactive",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              ],
            ),
            const Divider(),
            Expanded(child: userDataTable(context)),
          ],
        ),
      ),
    );
  }

  DataTable2 userDataTable(context) {
    return DataTable2(
      headingRowHeight: Dimensions.headerRowHeight,
      dividerThickness: 0.0,
      horizontalMargin: 0.0,
      minWidth: 700,
      columnSpacing: 15.0,
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
          label: Text(
            ' SELLER NAME',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'COMPANY',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'PRODUCT',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'REVENUE',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          fixedWidth: 90,
          label: Text(
            'STATUS',
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
      ],
    );
  }

  DataRow2 dataRow5(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.robbart,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Robbart Fox',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Samsung',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('Sunglass',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$12453',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Text(
            'Done',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        )
      ],
    );
  }

  DataRow2 dataRow4(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.annete,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Annette Black',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Samsung',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('Computer',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$20467',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Text(
            'Done',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        )
      ],
    );
  }

  DataRow2 dataRow3(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.marvin,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Marvin MCKinney',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Samsung',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('Watch',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$17346',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Text(
            'Done',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        )
      ],
    );
  }

  DataRow2 dataRow2(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.therassa,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Therassa Webb',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Samsung',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('Laptop',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$25573',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Text(
            'Pending',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        )
      ],
    );
  }

  DataRow2 dataRow1(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            Image.asset(
              Images.jerome,
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: Dimensions.paddingSizeDefault,
            ),
            Text(
              'Jerome Bell',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Samsung',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('Smart Phone',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Text(
            'Done',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        )
      ],
    );
  }
}
