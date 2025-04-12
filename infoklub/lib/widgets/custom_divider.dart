import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final double height;
  final double indent;
  final double endIndent;
  final Color color;

  const CustomDivider({
    super.key,
    this.thickness = 1.0,
    this.height = 20.0,
    this.indent = 20.0,
    this.endIndent = 20.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      height: height,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
