import 'package:flutter/material.dart';
import '../../enums/family_role.dart';

/// Role chip widget for displaying member roles
class RoleChip extends StatelessWidget {
  final FamilyRole role;
  final bool small;

  const RoleChip({
    super.key,
    required this.role,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: role.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: role.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            role.icon,
            size: small ? 12 : 14,
            color: role.color,
          ),
          const SizedBox(width: 4),
          Text(
            role.displayName,
            style: TextStyle(
              fontSize: small ? 10 : 12,
              color: role.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
