import 'package:flutter/material.dart';

/// Feature tile widget for displaying app features
class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? Colors.blue;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: tileColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: tileColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
