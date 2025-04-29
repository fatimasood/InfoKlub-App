import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';

class AddDetailsbtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double width;
  final Color? borderColor;
  final Widget? icon;

  const AddDetailsbtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppTheme.secondaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.height = 45.0,
    this.width = double.infinity,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.5)
              : BorderSide.none, // Apply border if color is provided
        ),
        minimumSize: Size(width, height), // Size of the button
      ),
      onPressed: onPressed,
      child: Row(
        // mainAxisSize: MainAxisSize.min, // Content takes minimum width
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textAlign: TextAlign.start,
            style: AppTheme.getResponsiveTextTheme(context).bodySmall,
          ),
          if (icon != null) ...[
            icon!, // Display icon if provided
            // const SizedBox(width: 8), // Add spacing between icon and text
          ],
        ],
      ),
    );
  }
}
