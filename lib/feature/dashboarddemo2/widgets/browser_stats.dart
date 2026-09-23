import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class BrowserStats extends StatelessWidget {
  const BrowserStats({super.key});

  @override
  Widget build(BuildContext context) {
     //double screenWidth = Get.width - 75;
     return Container(
      height: 450,
      //width: screenWidth/1.75,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge,
            vertical: Dimensions.paddingSizeLarge),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Browser States",
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(),
            Expanded(child: browserstatsDataTable(context)),
          ],
        ),
      ),
    );
  }



  DataTable2 browserstatsDataTable(context) {
    return DataTable2(
      headingRowHeight: Dimensions.headerRowHeight,
      dividerThickness: 0.0,
      horizontalMargin: 0.0,
      minWidth: 700,
      columnSpacing: 15.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          return Colors.grey
              .withOpacity(0.1); // Adjust the opacity and color as needed
        },
      ),
      decoration:const BoxDecoration(
          //color: Colors.blueGrey
          ),
      columns: <DataColumn>[
        DataColumn2(
          label: Text(
            'BROWSER',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'SESSION',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'BOUNCE RATE',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
          label: Text(
            'CTE',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
        ),
        DataColumn2(
         // fixedWidth: 90,
          label: Text(
            'GOAL CONY.RATE',
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

  DataRow2 dataRow1(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
            
            Text(
              'Google Chrome',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                //fontWeight: FontWeight.bold
              ),
            ),
          ],
        )),
        DataCell(Text('93543',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('3.5%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('12025',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(
          Text(
            '90%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
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
           
           
            Text(
              'Mozilla Firefox',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
         DataCell(Text('93543',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('3.5%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('12025',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(
          Text(
            '90%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
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
           
            Text(
              'Apple Safari',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
         DataCell(Text('93543',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('3.5%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('12025',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(
          Text(
            '90%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
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
           
          
            Text(
              'Internet Explorer',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
         DataCell(Text('93543',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('3.5%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('12025',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(
          Text(
            '90%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ),
          ),
        )       
      ],
    );
  }


  DataRow2 dataRow5(BuildContext context) {
    return DataRow2(
      cells: <DataCell>[
        DataCell(Row(
          children: [
           
           
            Text(
              'Opera Mini',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ],
        )),
         DataCell(Text('93543',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('3.5%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(Text('12025',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ))),
        DataCell(
          Text(
            '90%',
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              fontWeight: FontWeight.bold
            ),
          ),
        )       
      ],
    );
  }

  
}