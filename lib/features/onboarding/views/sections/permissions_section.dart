import 'package:flutter/material.dart';

/// Permission item model
class PermissionItem {
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final bool required;

  const PermissionItem({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    this.required = false,
  });
}

/// Permissions section with permission tiles
class PermissionsSection extends StatelessWidget {
  final List<PermissionItem> permissions;
  final Map<String, bool> permissionStates;
  final Function(String, bool) onPermissionChanged;

  const PermissionsSection({
    super.key,
    required this.permissions,
    required this.permissionStates,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: permissions.map((permission) {
        final isGranted = permissionStates[permission.key] ?? false;
        return _PermissionTile(
          title: permission.title,
          description: permission.description,
          icon: permission.icon,
          required: permission.required,
          granted: isGranted,
          onChanged: (value) {
            onPermissionChanged(permission.key, value ?? false);
          },
        );
      }).toList(),
    );
  }
}

/// Individual permission tile widget
class _PermissionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool required;
  final bool granted;
  final Function(bool?) onChanged;

  const _PermissionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.required,
    required this.granted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: granted ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: granted ? Colors.green : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: granted ? Colors.green : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (required) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
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
          Switch(
            value: granted,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
