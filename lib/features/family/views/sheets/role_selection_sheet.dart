import 'package:flutter/material.dart';
import '../../enums/family_role.dart';

/// Bottom sheet for role selection
class RoleSelectionSheet extends StatelessWidget {
  final FamilyRole currentRole;
  final Function(FamilyRole) onRoleSelected;

  const RoleSelectionSheet({
    super.key,
    required this.currentRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = FamilyRole.values.where((r) => r != FamilyRole.owner).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Role',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a role for this member',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...roles.map((role) {
            final isSelected = role == currentRole;
            return _RoleTile(
              role: role,
              isSelected: isSelected,
              onTap: () {
                Navigator.pop(context);
                onRoleSelected(role);
              },
            );
          }),
          const SizedBox(height: 16),
          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Show the role selection sheet
  static Future<FamilyRole?> show(
    BuildContext context, {
    required FamilyRole currentRole,
  }) async {
    FamilyRole? selectedRole;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleSelectionSheet(
        currentRole: currentRole,
        onRoleSelected: (role) {
          selectedRole = role;
        },
      ),
    );

    return selectedRole;
  }
}

class _RoleTile extends StatelessWidget {
  final FamilyRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? role.color.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? role.color
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: role.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                role.icon,
                color: role.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? role.color : Colors.black,
                    ),
                  ),
                  Text(
                    role.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: role.color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
