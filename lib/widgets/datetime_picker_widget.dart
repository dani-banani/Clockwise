import 'package:computing_project/widgets/error_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:get/get.dart';

class DateTimePickerWidget extends StatefulWidget {
  final String helpText;
  final Function(DateTime?) onDateTimeSelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? selectedDate;
  const DateTimePickerWidget({
    super.key,
    required this.onDateTimeSelected,
    this.helpText = "Select Date",
    this.selectedDate,
    this.minDate,
    this.maxDate,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  final List<int> hours =
      List.generate(12, (index) => index + 1).reversed.toList();
  final List<int> minutes = List.generate(60, (index) => index);
  final List<String> periods = ['AM', 'PM'];
  bool isDateTimeSelected = false;
  int selectedHourIndex = 0;
  int selectedMinuteIndex = 0;
  int selectedPeriodIndex = 0;
  DateTime? selectedDateTime;
  int stepCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      selectedDateTime = widget.selectedDate!;
      isDateTimeSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        stepCount = 0;
        if (!isDateTimeSelected) {
          selectedDateTime = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0);
        }
        showDialog(context);
        return;
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: isDateTimeSelected
                ? Border.all(color: colorScheme.primary, strokeAlign: BorderSide.strokeAlignCenter)
                : null),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (isDateTimeSelected) ...[
            RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    children: [
                      const TextSpan(
                        text: "Task dues on: ",
                      ),
                      TextSpan(
                        text: DateFormat('dd/MM/yyyy hh:mm a')
                            .format(selectedDateTime!),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
            Icon(Icons.edit, color: colorScheme.onPrimaryContainer)

          ],
          if (!isDateTimeSelected) ...[
          Text(
            isDateTimeSelected
                ? DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!)
                : widget.helpText,
            style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
            Icon(Icons.calendar_month, color: colorScheme.onPrimaryContainer)
          ],
        ]),
      ),
    );
  }

  void showDialog(BuildContext context) {
    Get.dialog(StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          actionsPadding:
              const EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 0),
          clipBehavior: Clip.hardEdge,
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      stepCount == 0 ? "Set Date" : "Set Time",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, 
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: colorScheme.onSurface,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Selected: ${DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface),
                ),
                const SizedBox(height: 20),
                stepCount == 0
                    ? buildDatePicker(setDialogState)
                    : buildTimePicker(setDialogState),
              ],
            ),
          ),
          actions: [
            Row(children: [
              if (stepCount == 0 && isDateTimeSelected) ...[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDateTime = null;
                        isDateTimeSelected = false;
                      });

                      widget.onDateTimeSelected(null);
                      Get.back();
                    },
                    child: const Text("Remove Date"),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              if (stepCount == 1) ...[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 50),
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: colorScheme.primary),
                      ),
                    ),
                    onPressed: () {
                      setDialogState(() {
                        stepCount = 0;
                      });
                    },
                    child: const Text("Change Date"),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(double.infinity, 50),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    switch (stepCount) {
                      case 0:
                        if (selectedDateTime == null) {
                          ErrorSnackbarWidget.showSnackbar(
                              title: "Error", messages: ["Date is required"]);
                          return;
                        }

                        onDateSelected(selectedDateTime!, setDialogState);
                        stepCount = 1;
                        break;
                      case 1:
                        setState(() {
                          isDateTimeSelected = true;
                          widget.onDateTimeSelected(selectedDateTime);
                        });
                        Get.back();
                        break;
                    }
                  },
                  child: Text(stepCount == 0 ? "Select Date" : "Select Time"),
                ),
              ),
            ])
          ],
        );
      },
    )).then((value) {
      setState(() {
        stepCount = 0;
        selectedHourIndex = 0;
        selectedMinuteIndex = 0;
        selectedPeriodIndex = 0;
      });
    });
  }

  Widget buildDatePicker(Function setDialogState) {
    return Container(
      height: Get.height * 0.3,
      width: Get.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DatePicker(
        padding: EdgeInsets.zero,
        centerLeadingDate: true,
        leadingDateTextStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        splashRadius: 10,
        selectedDate: selectedDateTime,
        initialDate: selectedDateTime,
        selectedCellTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        disabledCellsTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
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

          onDateSelected(date, setDialogState);
        },
      ),
    );
  }

  Widget buildTimePicker(Function setDialogState) {
    FixedExtentScrollController hourController =
        FixedExtentScrollController(initialItem: selectedHourIndex);
    FixedExtentScrollController minuteController =
        FixedExtentScrollController(initialItem: selectedMinuteIndex);
    FixedExtentScrollController periodController =
        FixedExtentScrollController(initialItem: selectedPeriodIndex);
    return StatefulBuilder(builder: (context, setTimePickerState) {
      return Container(
          height: Get.height * 0.3,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: ListWheelScrollView(
                          controller: hourController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 40,
                          diameterRatio: 0.8,
                          onSelectedItemChanged: (index) {
                            setTimePickerState(() {
                              selectedHourIndex = index;
                              onTimeChanged(setDialogState);
                            });
                          },
                          children: [
                            ...hours.toList().map((hour) {
                              final currentHourIndex = hours.indexOf(hour);
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  hour.toString(),
                                  style: TextStyle(
                                      color: colorScheme.onPrimaryContainer
                                          .withValues(
                                              alpha: currentHourIndex ==
                                                      selectedHourIndex
                                                  ? 1
                                                  : 0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            })
                          ])),
                  Text(
                    ":",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer),
                  ),
                  Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: ListWheelScrollView(
                          controller: minuteController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 40,
                          diameterRatio: 0.8,
                          onSelectedItemChanged: (index) {
                            setTimePickerState(() {
                              selectedMinuteIndex = index;
                              onTimeChanged(setDialogState);
                            });
                          },
                          children: [
                            ...minutes.toList().map((minute) {
                              final currentMinuteIndex =
                                  minutes.indexOf(minute);
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  minute.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                      color: colorScheme.onPrimaryContainer
                                          .withValues(
                                              alpha: currentMinuteIndex ==
                                                      selectedMinuteIndex
                                                  ? 1
                                                  : 0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            })
                          ])),
                  Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: ListWheelScrollView(
                          controller: periodController,
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 40,
                          diameterRatio: 0.8,
                          onSelectedItemChanged: (index) {
                            setTimePickerState(() {
                              selectedPeriodIndex = index;
                              onTimeChanged(setDialogState);
                            });
                          },
                          children: [
                            ...periods.toList().map((period) {
                              final currentPeriodIndex =
                                  periods.indexOf(period);
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  period,
                                  style: TextStyle(
                                      color: colorScheme.onPrimaryContainer
                                          .withValues(
                                              alpha: currentPeriodIndex ==
                                                      selectedPeriodIndex
                                                  ? 1
                                                  : 0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            })
                          ])),
                ],
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: colorScheme.primary, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  )),
            ],
          ));
    });
  }

  void onDateSelected(DateTime date, Function setDialogState) {
    int hour = selectedDateTime!.hour;
    int minute = selectedDateTime!.minute;

    setDialogState(() {
      selectedDateTime =
          DateTime(date.year, date.month, date.day, hour, minute);
    });

    setState(() {
      selectedDateTime =
          DateTime(date.year, date.month, date.day, hour, minute);
    });
  }

  void onTimeChanged(Function setDialogState) {
    int selectedHour = hours[selectedHourIndex];
    String selectedPeriod = periods[selectedPeriodIndex];
    if (selectedPeriod == 'PM' && selectedHour != 12) {
      selectedHour += 12;
    } else if (selectedPeriod == 'AM' && selectedHour == 12) {
      selectedHour = 0;
    }
    setDialogState(() {
      selectedDateTime = selectedDateTime!
          .copyWith(hour: selectedHour, minute: minutes[selectedMinuteIndex]);
    });

    setState(() {
      selectedDateTime = selectedDateTime!
          .copyWith(hour: selectedHour, minute: minutes[selectedMinuteIndex]);
    });
  }
}
