import 'package:flutter/material.dart';

/// Settings section showing family settings options
class SettingsSection extends StatelessWidget {
  final FamilyModel family;
  final bool isOwner;
  final VoidCallback onEditSettings;
  final VoidCallback onTransferOwnership;
  final VoidCallback onLeaveFamily;
  final VoidCallback onDeleteFamily;

  const SettingsSection({
    super.key,
    required this.family,
    required this.isOwner,
    required this.onEditSettings,
    required this.onTransferOwnership,
    required this.onLeaveFamily,
    required this.onDeleteFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _SettingsTile(
          icon: Icons.edit,
          title: 'Edit Family',
          subtitle: 'Change name, description, currency',
          onTap: onEditSettings,
        ),
        if (isOwner) ...[
          _SettingsTile(
            icon: Icons.swap_horiz,
            title: 'Transfer Ownership',
            subtitle: 'Transfer ownership to another member',
            onTap: onTransferOwnership,
            iconColor: Colors.blue,
          ),
          _SettingsTile(
            icon: Icons.delete,
            title: 'Delete Family',
            subtitle: 'Permanently delete this family',
            onTap: onDeleteFamily,
            iconColor: Colors.red,
          ),
        ],
        _SettingsTile(
          icon: Icons.exit_to_app,
          title: 'Leave Family',
          subtitle: 'Leave this family',
          onTap: onLeaveFamily,
          iconColor: Colors.orange,
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Colors.blue,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
