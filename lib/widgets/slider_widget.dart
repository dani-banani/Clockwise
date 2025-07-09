import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final ColorScheme colorScheme;
  final Map<int, String> values;
  final int selectedKey;
  final Function(int) onChanged;
  final String label;
  const SliderWidget({
    super.key,
    required this.colorScheme,
    required this.values,
    required this.selectedKey,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    List<int> sliderValues = values.keys.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$label:",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  )),
              Text(
                values[selectedKey] ?? "",
                style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
              padding: EdgeInsets.zero,
              allowedInteraction: SliderInteraction.tapAndSlide,
              min: 0,
              max: sliderValues.length.toDouble() - 1,
              divisions: sliderValues.length - 1,
              activeColor: colorScheme.primary,
              value: sliderValues.indexOf(selectedKey).toDouble() == -1
                  ? 0
                  : sliderValues.indexOf(selectedKey).toDouble(),
              label: values[selectedKey] ?? "",
              onChanged: (value) {
                int selectedValue = values.keys.toList()[value.toInt()];
                onChanged(selectedValue);
              }),
        ],
      ),
    );
  }
}
