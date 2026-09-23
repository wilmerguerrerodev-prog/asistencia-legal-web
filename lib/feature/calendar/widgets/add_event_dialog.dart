import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import '../model/event.dart';
import 'date_time_selector.dart';

class AddEventDialog extends StatefulWidget {
  final void Function(CalendarEventData<Event>)? onEventAdd;

  const AddEventDialog({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  AddEventWidgetState createState() => AddEventWidgetState();
}

class AddEventWidgetState extends State<AddEventDialog> {
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "";

  String _description = "";

  Color _color = Colors.blue;

  late FocusNode _titleNode;

  late FocusNode _descriptionNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Theme.of(context).cardColor,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("create_new_event".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                    InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: const Icon(Icons.highlight_remove)),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                CustomTextField(
                  hintText: 'Enter Event Title',
                  onSaved: (value) => _title = value?.trim() ?? "",
                  onValidate: (value){
                    if (value == null || value == "") {
                      return "Please enter event title.";
                    }
                    return null;
                  },
                  inputType: TextInputType.text,
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeSelectorFormField(

                        controller: _startDateController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "Start Date",
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please select date.";
                          }

                          return null;
                        },
                        textStyle: const TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        onSave: (date) => _startDate = date,
                        type: DateTimeSelectionType.date,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _endDateController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "End Date",
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please select date.";
                          }

                          return null;
                        },
                        textStyle: const TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        onSave: (date) => _endDate = date,
                        type: DateTimeSelectionType.date,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _startTimeController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "Start Time",
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please select start time.";
                          }

                          return null;
                        },
                        onSave: (date) => _startTime = date,
                        textStyle: const TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        type: DateTimeSelectionType.time,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: DateTimeSelectorFormField(
                        controller: _endTimeController,
                        decoration: AppConstants.inputDecoration.copyWith(
                          labelText: "End Time",
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please select end time.";
                          }

                          return null;
                        },
                        onSave: (date) => _endTime = date,
                        textStyle: const TextStyle(
                          color: AppColors.black,
                          fontSize: 17.0,
                        ),
                        type: DateTimeSelectionType.time,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  focusNode: _descriptionNode,
                  inputType: TextInputType.multiline,
                  maxLines: 4,
                  onValidate: (value) {
                    if (value == null || value.trim() == "") {
                      return "Please enter event description.";
                    }

                    return null;
                  },
                  onSaved: (value) => _description = value?.trim() ?? "",
                  hintText: "Event Description",
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    const Text(
                      "Event Color: ",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: _displayColorPicker,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: _color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onPressed: _createEvent,
                  buttonText: "Add Event",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      date: _startDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: _endDate,
      title: _title,
      event: Event(
        title: _title,
      ),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
    Get.back();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                buttonText: "Select",
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _color = color;
                    });
                  }
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
