import 'package:flutter/material.dart';
import '../app/theme.dart';

Widget InfoCard(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required String title,
  String? description,
  required Color backgroundColor,
  Color? arrowColor,
  VoidCallback? onTap,
  VoidCallback? editAction,
  VoidCallback? downloadAction,
  Color? descolor,
  bool showIcons = false,
  bool showArrow = false,
}) {
  return GestureDetector(
    onTap: showIcons ? null : onTap,
    child: Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppTheme.whiteColor, width: 2.0),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 12.0),

          // Title and optional description/buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                if (description != null) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: descolor ?? iconColor.withOpacity(0.7),
                    ),
                  ),
                ],

                // Show either action buttons or arrow
                if (showIcons && description == null)
                  Row(
                    children: [
                      if (editAction != null)
                        _buildActionButton(
                          context,
                          icon: Icons.edit,
                          label: "Edit",
                          color: arrowColor,
                          onTap: editAction,
                        ),
                      if (editAction != null && downloadAction != null)
                        const SizedBox(width: 8.0),
                      if (downloadAction != null)
                        _buildActionButton(
                          context,
                          icon: Icons.download,
                          label: "Download",
                          color: arrowColor,
                          onTap: downloadAction,
                        ),
                    ],
                  ),
              ],
            ),
          ),

          // Show arrow if needed (and no buttons are showing)
          if (showArrow && !(showIcons && description == null))
            Icon(
              Icons.arrow_forward_ios,
              color: arrowColor,
              size: 18.0,
            ),
        ],
      ),
    ),
  );
}

Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Color? color,
  required VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 3),
          ),
        ],
        color: color,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14.0),
            const SizedBox(width: 4.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
