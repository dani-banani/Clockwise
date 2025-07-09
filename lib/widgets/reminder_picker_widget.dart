import 'package:computing_project/widgets/error_snackbar_widget.dart';
import 'package:computing_project/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:get/get.dart';

class ReminderPickerWidget extends StatefulWidget {
  final String helpText;
  final Function(DateTime?, int?) onReminderFrequencySelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? defaultSelectedDate;
  final int? defaultSelectedReminderFrequency;
  const ReminderPickerWidget({
    super.key,
    required this.onReminderFrequencySelected,
    this.helpText = "Set Reminder",
    this.defaultSelectedDate,
    this.defaultSelectedReminderFrequency,
    this.minDate,
    this.maxDate,
  });

  @override
  State<ReminderPickerWidget> createState() => _ReminderPickerWidgetState();
}

class _ReminderPickerWidgetState extends State<ReminderPickerWidget> {
  final ColorScheme colorScheme = Get.theme.colorScheme;
  static const Map<int, String> reminderFrequencyValues = {
    1: "Every Day",
    3: "Every 3 Days",
    7: "Every Week",
    14: "Every 2 Weeks",
    30: "Every 30 Days",
  };
  TextEditingController reminderController = TextEditingController();
  bool isReminderSet = false;
  int selectedReminderFrequency = 1;
  DateTime? selectedReminderDate;
  int stepCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.defaultSelectedDate != null &&
        widget.defaultSelectedReminderFrequency != null) {
      selectedReminderDate = widget.defaultSelectedDate!;
      selectedReminderFrequency = widget.defaultSelectedReminderFrequency!;
      isReminderSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        stepCount = 0;
        if (!isReminderSet) {
          selectedReminderDate = DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 0, 0);
        }
        showDialog(context);
        return;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: isReminderSet
                ? Border.all(
                    color: colorScheme.primary,
                    strokeAlign: BorderSide.strokeAlignCenter)
                : null),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (isReminderSet) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    children: [
                      const TextSpan(
                        text: "Reminder starts on: ",
                      ),
                      TextSpan(
                        text: DateFormat('dd/MM/yyyy')
                            .format(selectedReminderDate!),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    children: [
                      const TextSpan(
                        text: "Reminder sent every: ",
                      ),
                      TextSpan(
                        text:
                            "${selectedReminderFrequency.toString()} ${selectedReminderFrequency == 1 ? "Day" : "Days"}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Icon(Icons.edit, color: colorScheme.onPrimaryContainer)
          ],
          if (!isReminderSet) ...[
            Text(
              widget.helpText,
              style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Icon(Icons.alarm, color: colorScheme.onPrimaryContainer)
          ]
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
                      stepCount == 0 ? "Select Date" : "Select Frequency",
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
                  "Selected: ${DateFormat('dd/MM/yyyy').format(selectedReminderDate!)}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface),
                ),
                const SizedBox(height: 20),
                stepCount == 0
                    ? buildDatePicker(setDialogState)
                    : buildReminderFrequencyPicker(setDialogState),
              ],
            ),
          ),
          actions: [
            Row(children: [
              if (stepCount == 0 && isReminderSet) ...[
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
                        selectedReminderDate = null;
                        isReminderSet = false;
                      });

                      widget.onReminderFrequencySelected(null, null);
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
                        if (selectedReminderDate == null) {
                          ErrorSnackbarWidget.showSnackbar(
                              title: "Error", messages: ["Date is required"]);
                          return;
                        }
                        onDateSelected(selectedReminderDate!, setDialogState);
                        reminderController.text =
                            selectedReminderFrequency.toString();
                        stepCount = 1;
                        break;
                      case 1:
                        if (int.tryParse(reminderController.text) == null) {
                          ErrorSnackbarWidget.showSnackbar(
                              title: "Error",
                              messages: [
                                "Reminder frequency must be a number"
                              ]);
                          setDialogState(() {
                            reminderController.text =
                                selectedReminderFrequency.toString();
                          });
                          return;
                        }

                        if (int.parse(reminderController.text) < 1 ||
                            int.parse(reminderController.text) > 99) {
                          ErrorSnackbarWidget.showSnackbar(
                              title: "Error",
                              messages: [
                                "Reminder frequency must be between 1 and 99"
                              ]);
                          setDialogState(() {
                            reminderController.text =
                                selectedReminderFrequency.toString();
                          });
                          return;
                        }

                        setState(() {
                          isReminderSet = true;
                          widget.onReminderFrequencySelected(
                              selectedReminderDate,
                              int.parse(reminderController.text));
                        });
                        Get.back();
                        break;
                    }
                  },
                  child: Text(stepCount == 0 ? "Set Date" : "Set Frequency"),
                ),
              ),
            ])
          ],
        );
      },
    )).then((value) {
      setState(() {
        stepCount = 0;
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
        selectedDate: selectedReminderDate,
        initialDate: selectedReminderDate,
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
          if (date == selectedReminderDate) {
            return;
          }

          onDateSelected(date, setDialogState);
        },
      ),
    );
  }

  Widget buildReminderFrequencyPicker(Function setDialogState) {
    return StatefulBuilder(builder: (context, setReminderFrequencyPickerState) {
      return Container(
        width: Get.width,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SliderWidget(
                colorScheme: colorScheme,
                values: reminderFrequencyValues,
                selectedKey: selectedReminderFrequency,
                onChanged: (value) {
                  onReminderFrequencyChanged(
                      setReminderFrequencyPickerState, value);
                },
                label: "Frequency"),
            Text(
              "A reminder will be sent every",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    controller: reminderController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: colorScheme.primaryContainer,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 1, color: colorScheme.onPrimaryContainer)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 1, color: colorScheme.onPrimaryContainer)),
                    ),
                    onSubmitted: (value) {
                      onReminderFrequencyChanged(
                          setReminderFrequencyPickerState, int.parse(value));
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "Days",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void onDateSelected(DateTime date, Function setDialogState) {
    int hour = selectedReminderDate!.hour;
    int minute = selectedReminderDate!.minute;

    setDialogState(() {
      selectedReminderDate =
          DateTime(date.year, date.month, date.day, hour, minute);
    });

    setState(() {
      selectedReminderDate =
          DateTime(date.year, date.month, date.day, hour, minute);
    });
  }

  void onReminderFrequencyChanged(
      Function setReminderFrequencyPickerState, int frequency) {
    setState(() {
      selectedReminderFrequency = frequency;
      reminderController.text = frequency.toString();
    });

    setReminderFrequencyPickerState(() {
      selectedReminderFrequency = frequency;
      reminderController.text = frequency.toString();
    });
  }
}
