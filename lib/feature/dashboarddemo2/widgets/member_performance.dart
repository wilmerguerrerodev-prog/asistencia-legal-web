import 'package:d_chart/single_bar/view.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class MemberPerformance extends StatelessWidget {
  const MemberPerformance({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 360,
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
                  "Member Performance",
                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                ),
              ],
            ),
            // const Divider(),
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
      decoration: const BoxDecoration(
          //color: Colors.blueGrey
          ),
      columns: <DataColumn>[
        DataColumn2(
          label: Text(
            '',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            '',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            '',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          fixedWidth: 150,
          label: Text(
            '',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
      ],
      rows: <DataRow2>[
        dataRow1(context),
        dataRow2(context),
        dataRow3(context),
        dataRow4(context),
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
        DataCell(Text('React Js,HTML',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$20467',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Row(
            children: [
              SizedBox(
                  height: 10,
                  width: 100,
                  child: DChartSingleBar(
                      radius: BorderRadius.circular(30),
                      foregroundColor: Colors.red,
                      value: 25,
                      max: 100)),
              const Text(" 25%"),
            ],
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
            const SizedBox(width: Dimensions.paddingSizeDefault),
            Text(
              'Marvin MCKinney',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
        DataCell(Text('Illustrate', style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,))),
        DataCell(Text('\$17346',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Row(
            children: [
              SizedBox(
                  height: 10,
                  width: 100,
                  child: DChartSingleBar(
                      radius: BorderRadius.circular(30),
                      foregroundColor: Colors.blue,
                      value: 72,
                      max: 100)),
              const Text(" 72%"),
            ],
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
        DataCell(Text('WordPress',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$25573',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Row(
            children: [
              SizedBox(
                  height: 10,
                  width: 100,
                  child: DChartSingleBar(
                      radius: BorderRadius.circular(30),
                      foregroundColor: Colors.purple,
                      value: 72,
                      max: 100)),
              const Text(" 52%"),
            ],
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
        DataCell(Text('Laravel,Angular',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(Text('\$38536',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ))),
        DataCell(
          Row(
            children: [
              SizedBox(
                  height: 10,
                  width: 100,
                  child: DChartSingleBar(
                      radius: BorderRadius.circular(30),
                      foregroundColor: Colors.blue,
                      value: 80,
                      max: 100)),
              const Text(" 80%"),
            ],
          ),
        )
      ],
    );
  }
}
