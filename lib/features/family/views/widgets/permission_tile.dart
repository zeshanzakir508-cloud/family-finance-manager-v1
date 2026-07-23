import 'package:flutter/material.dart';
import '../../enums/permission_type.dart';

/// Permission tile widget for displaying permissions
class PermissionTile extends StatelessWidget {
  final PermissionType permission;
  final bool hasPermission;
  final bool canEdit;
  final ValueChanged<bool>? onChanged;

  const PermissionTile({
    super.key,
    required this.permission,
    required this.hasPermission,
    this.canEdit = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        permission.icon,
        color: hasPermission ? Colors.blue : Colors.grey,
      ),
      title: Text(
        permission.displayName,
        style: TextStyle(
          color: hasPermission ? Colors.black : Colors.grey,
        ),
      ),
      subtitle: Text(
        permission.description,
        style: TextStyle(
          fontSize: 12,
          color: hasPermission ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),
      trailing: canEdit
          ? Switch(
              value: hasPermission,
              onChanged: onChanged,
              activeColor: Colors.blue,
            )
          : Icon(
              hasPermission ? Icons.check_circle : Icons.cancel,
              color: hasPermission ? Colors.green : Colors.grey,
              size: 20,
            ),
      enabled: canEdit,
    );
  }
}
