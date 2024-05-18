import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.leftIcon,
      required this.rightIcon,
      this.iconColor,
      this.textColor,
      this.borderColor,
      this.padding,
      this.height});

  final IconData rightIcon;
  final IconData leftIcon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double? height;
  final Function() onPressed;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(width * 0.05),
        child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: width,
              height: widget.height ?? height * 0.08,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.borderColor ?? Colors.black.withAlpha(100),
                  width: 1.4,
                ),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
              padding: widget.padding ?? EdgeInsets.all(width * 0.05),
              child: Row(
                children: [
                  Icon(
                    widget.leftIcon,
                    color: widget.iconColor ?? Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(color: widget.textColor ?? Colors.black),
                  ),
                  const Spacer(),
                  Icon(
                    widget.rightIcon,
                    color: widget.iconColor ?? Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )));
  }
}
