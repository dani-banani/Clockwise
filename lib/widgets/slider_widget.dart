import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final ColorScheme colorScheme;
  final int value;
  final Function(int) onChanged;
  final int min;
  final int max;
  final int divisions;
  final String label;
  const SliderWidget({
    super.key,
    required this.colorScheme,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(alignment: Alignment.centerLeft, child: Text(widget.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Slider(
                    padding: EdgeInsets.zero,
                    min: widget.min.toDouble(),
                    max: widget.max.toDouble(),
                    divisions: widget.divisions,
                    activeColor: widget.colorScheme.primary,
                    value: widget.value.toDouble(),
                    label: widget.value.toString(),
                    onChanged: (value) {
                      widget.onChanged(value.toInt());
                    }),
              ),
              const SizedBox(width: 30),  
              Container(
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(
                        color: widget.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
