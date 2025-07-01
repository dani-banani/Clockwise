import 'package:computing_project/widgets/action_dialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:get/get.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class DateTimePickerWidget extends StatefulWidget {
  final String helpText;
  final bool isTime;
  final Function(DateTime?) onDateOrTimeSelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  const DateTimePickerWidget({
    super.key,
    required this.onDateOrTimeSelected,
    this.helpText = "Select Date",
    this.isTime = false,
    this.minDate,
    this.maxDate,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  DateTime? selectedDateTime;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          if (widget.isTime) {
            showTimePicker(context);
            return;
          }
          showDatePicker(context);
          return;
        }

        setState(() {
          isSelected = false;
          selectedDateTime = null;
        });

        widget.onDateOrTimeSelected(null);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: isSelected ? Border.all(color: colorScheme.primary) : null),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            isSelected && selectedDateTime != null
                ? widget.isTime
                    ? DateFormat('h:mm a').format(selectedDateTime!)
                    : DateFormat('dd/MM/yyyy').format(selectedDateTime!)
                : widget.helpText,
            style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          if (!isSelected)
            Icon(widget.isTime ? Icons.access_time : Icons.calendar_month,
                color: colorScheme.onPrimaryContainer)
          else
            Icon(Icons.close, color: colorScheme.error)
        ]),
      ),
    );
  }

  void showDatePicker(BuildContext context) {
    Get.dialog(ActionDialogWidget(
      title: "Select Date",
      actionText: "Select",
      gap: 0,
      onActionPressed: () {
        if (selectedDateTime == null) {
          return;
        }

        setState(() {
          isSelected = true;
        });
        widget.onDateOrTimeSelected(selectedDateTime!);
      },
      body: SizedBox(
        height: Get.height * 0.3,
        width: Get.width,
        child: DatePicker(
          centerLeadingDate: true,
          leadingDateTextStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          splashRadius: 10,
          selectedDate: selectedDateTime ?? DateTime.now(),
          initialDate: selectedDateTime ?? DateTime.now(),
          selectedCellTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
          enabledCellsTextStyle: const TextStyle(
            fontSize: 16,
          ),
          currentDateTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          currentDateDecoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          maxDate: widget.maxDate ??
              DateTime.now().add(const Duration(days: 365 * 20)),
          minDate: widget.minDate ??
              DateTime.now().subtract(const Duration(days: 365 * 20)),
          onDateSelected: (date) {
            if (date == selectedDateTime) {
              return;
            }

            setState(() {
              selectedDateTime = date;
            });
          },
        ),
      ),
    ));
  }

  void showTimePicker(BuildContext context) async {
    Navigator.of(context).push(showPicker(
      context: context,
      borderRadius: 20,
      contentPadding: const EdgeInsets.all(20),
      buttonStyle: ButtonStyle(
          alignment: Alignment.center,
          fixedSize: WidgetStateProperty.all(Size(Get.width - 120, 50)),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ))),
      value: isSelected && selectedDateTime != null
          ? Time(hour: selectedDateTime!.hour, minute: selectedDateTime!.minute)
          : Time(hour: 12, minute: 0),
      iosStylePicker: true,
      pmLabel: "PM",
      amLabel: "AM",
      hourLabel: "Hours",
      minuteLabel: "Minutes",
      accentColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      focusMinutePicker: false,
      showCancelButton: false,
      unselectedColor: colorScheme.primary,
      okText: "Select Time",
      onChange: (value) {
        setState(() {
          selectedDateTime = DateTime(0, 0, 0, value.hour, value.minute);
          isSelected = true;
        });
        widget.onDateOrTimeSelected(selectedDateTime!);
      },
    ));
  }
}
