import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../enums/family_role.dart';
import '../../enums/permission_type.dart';
import '../../helpers/permission_helper.dart';
import '../../providers/family_provider.dart';

/// Roles and permissions page
class RolesPermissionsPage extends ConsumerWidget {
  const RolesPermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Family Roles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each role has different permissions and responsibilities.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Role cards
            ...FamilyRole.values.map((role) => _RoleCard(role: role)),
            const SizedBox(height: 24),
            // Permission summary
            const Text(
              'Permission Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Permissions by role category.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Permission list
            ...state.members.isNotEmpty
                ? _buildPermissionSummary()
                : [
                    const Center(
                      child: Text('No members to show permissions for'),
                    ),
                  ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPermissionSummary() {
    final permissions = PermissionHelper.getPermissionCategories();
    final widgets = <Widget>[];

    permissions.forEach((category, permissionList) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            title: Text(category),
            children: permissionList.map((permission) {
              return ListTile(
                leading: Icon(
                  PermissionHelper.getPermissionIcon(permission),
                  size: 20,
                ),
                title: Text(permission.displayName),
                subtitle: Text(permission.description),
                dense: true,
              );
            }).toList(),
          ),
        ),
      );
    });

    return widgets;
  }
}

class _RoleCard extends StatelessWidget {
  final FamilyRole role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionHelper.getPermissionsForRole(role);
    final isAdmin = role.isAdmin;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(role.icon, color: role.color),
                const SizedBox(width: 12),
                Text(
                  role.displayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: role.color,
                  ),
                ),
                const Spacer(),
                if (isAdmin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              role.description,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Permissions:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: permissions.map((permission) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    permission.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
