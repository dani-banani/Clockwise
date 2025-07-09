import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class ButtonWidget extends StatefulWidget {
  final ColorScheme colorScheme;
  final double width;
  final double height;
  final Widget child;
  final Function() onPressed;
  final ButtonType buttonType;
  const ButtonWidget({
    super.key,
    required this.colorScheme,
    required this.onPressed,
    this.width = 300,
    this.height = 50,
    this.child = const SizedBox.shrink(),
    this.buttonType = ButtonType.primary,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonType == ButtonType.primary ? widget.colorScheme.primary : widget.buttonType == ButtonType.secondary ? widget.colorScheme.secondary : widget.colorScheme.tertiary,
          foregroundColor: widget.buttonType == ButtonType.primary ? widget.colorScheme.onPrimary : widget.buttonType == ButtonType.secondary ? widget.colorScheme.onSecondary : widget.colorScheme.onTertiary,
          fixedSize: Size(widget.width, widget.height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: widget.onPressed,
        child: widget.child);
  }
}
