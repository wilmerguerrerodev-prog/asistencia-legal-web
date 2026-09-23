import 'package:flutter/material.dart';
import 'package:getdash/feature/blog_post/widget/blog_post_search_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../../../components/custom_switch.dart';


class AllPostTabView extends StatefulWidget {
  const AllPostTabView({super.key});

  @override
  State<AllPostTabView> createState() => _AllPostTabViewState();
}

class _AllPostTabViewState extends State<AllPostTabView> {

  bool value1 = true;


  onChangedMethod1(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
          border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Column(children: [

        const SizedBox(height: Dimensions.paddingSizeDefault),

        const BlogPostSearchSection(),

        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),


        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
              border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06)),
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
                          'S No',
                          style: ubuntuBold.copyWith(fontStyle: FontStyle.italic,fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                      DataColumn(

                        label: Text(
                          'Blog Title',
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
                          'Created At',
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

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),


      ]),
    );
  }

  DataRow dataRow(BuildContext context){
    return DataRow(
      cells: <DataCell>[
        const DataCell(Text('Leather Analog Watch For Men Round Shape')),
        const DataCell(Text('\$150')),
        const DataCell(Text('309')),
        const DataCell(Text('InStock')),
        DataCell(customSwitch(value1, onChangedMethod1,context)),
        const DataCell(Row(children: [
          Icon(Icons.edit),
          SizedBox(width: Dimensions.paddingSizeDefault),
          Icon(Icons.delete),
        ])),
      ],
    );
  }
}


