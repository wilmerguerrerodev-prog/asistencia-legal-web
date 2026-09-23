import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/calendar/model/event.dart';
import 'package:getdash/feature/calendar/widgets/add_event_dialog.dart';
import 'package:getdash/feature/calendar/widgets/calendar_view_type.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../../enumerations.dart';
import '../../widgets/calendar_views.dart';

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  CalendarHomePageState createState() => CalendarHomePageState();
}

class CalendarHomePageState extends State<CalendarHomePage> {
  CalendarView _selectedView = CalendarView.month;

  void _setView(CalendarView view) {
    if (view != _selectedView && mounted) {
      setState(() {
        _selectedView = view;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;
    var events = CalendarControllerProvider.of<Event>(context).controller.events;
    return Scaffold(
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer() : null,
      body: Row(
        children: [
          if (ResponsiveHelper.isDesktop(context))
            const MenuDrawer(),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeLarge,
                          horizontal: Dimensions.paddingSizeLarge),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),

                          child:ResponsiveHelper.isMobile(context) ? Column(
                            children: [
                              CalendarViewType(
                                onViewChange: _setView,
                                currentView: _selectedView,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeDefault,),
                              Expanded(child: CalendarViews(
                                key: ValueKey(MediaQuery.of(context).size.width),
                                view: _selectedView,
                              )),
                            ],
                          ):Row(
                            children: [
                              _calendarEvents(screenWidth,events),
                              const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                              Expanded(
                                child: CalendarViews(
                                  key: ValueKey(MediaQuery.of(context).size.width),
                                  view: _selectedView,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
      floatingActionButton:ResponsiveHelper.isMobile(context) ?  FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Get.dialog(
            AddEventDialog(
              onEventAdd: (event) {
                CalendarControllerProvider.of<Event>(context)
                    .controller
                    .add(event);
              },
            ),
          );
        },
      ):const SizedBox(),
    );
  }

  Widget _calendarEvents(screenWidth,events){
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CalendarViewType(
            onViewChange: _setView,
            currentView: _selectedView,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge,),
          CustomButton(
            width: screenWidth < 900 ? screenWidth / 2 : screenWidth/3,
            buttonText: 'Create New Event',
            fontSize: Dimensions.fontSizeSmall,
            onPressed: (){
              Get.dialog(
                AddEventDialog(
                  onEventAdd: (event) {
                    CalendarControllerProvider.of<Event>(context)
                        .controller
                        .add(event);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge,),
          Container(
            width:ResponsiveHelper.isMobile(context) ? Get.width :screenWidth < 900 ? screenWidth / 2 : screenWidth/3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
              color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03),
            ),
            child: Theme(
              data: ThemeData(),
              child: CalendarDatePicker(initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2024),
                onDateChanged: (DateTime value) {  },),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
          Container(
              width: screenWidth < 900 ? screenWidth / 2 : screenWidth/3,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    const Text("My Events",style: ubuntuBold,),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    Expanded(
                      child: ListView.builder(
                          itemCount: CalendarControllerProvider.of<Event>(context).controller.events.length,
                          itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeSmall),
                              child: Row(
                                children: [
                                  Container(
                                    height: 12.0,
                                    width: 12.0,
                                    decoration: BoxDecoration(
                                      color: events.elementAt(index).color,
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),

                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text(events.elementAt(index).title, style: ubuntuMedium,),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
          ),

        ],
      ),
    );
  }
}
