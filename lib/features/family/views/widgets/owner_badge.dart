import 'package:flutter/material.dart';

/// Owner badge widget
class OwnerBadge extends StatelessWidget {
  final bool small;

  const OwnerBadge({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 4 : 8,
        vertical: small ? 1 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.amber.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: small ? 10 : 14,
            color: Colors.amber.shade700,
          ),
          if (!small) ...[
            const SizedBox(width: 4),
            Text(
              'Owner',
              style: TextStyle(
                fontSize: 10,
                color: Colors.amber.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
