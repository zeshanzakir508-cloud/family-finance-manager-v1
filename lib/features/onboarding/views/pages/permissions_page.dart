import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/onboarding_provider.dart';
import '../sections/permissions_section.dart';

/// Permissions page
class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});

  @override
  ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends ConsumerState<PermissionsPage> {
  final Map<String, bool> _permissionStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize permission states from metadata
    _loadPermissionStates();
  }

  void _loadPermissionStates() {
    final metadata = ref.read(onboardingMetadataProvider);
    final permissions = metadata?['permissions'] as Map<String, bool>?;
    if (permissions != null) {
      _permissionStates.addAll(permissions);
    }
  }

  void _updatePermissionState(String key, bool value) {
    setState(() {
      _permissionStates[key] = value;
    });
    
    // Save to metadata
    ref.read(onboardingNotifierProvider.notifier).saveMetadata({
      'permissions': _permissionStates,
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Permissions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Allow permissions to get the most out of the app.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Permission tiles
          PermissionsSection(
            permissions: [
              PermissionItem(
                key: 'notifications',
                title: 'Notifications',
                description: 'Get alerts for budgets and expenses',
                icon: Icons.notifications_active,
                required: false,
              ),
              PermissionItem(
                key: 'storage',
                title: 'Storage',
                description: 'Save receipts and attachments',
                icon: Icons.folder,
                required: true,
              ),
              PermissionItem(
                key: 'camera',
                title: 'Camera',
                description: 'Scan receipts and documents',
                icon: Icons.camera_alt,
                required: false,
              ),
              PermissionItem(
                key: 'location',
                title: 'Location',
                description: 'Add location to expenses',
                icon: Icons.location_on,
                required: false,
              ),
            ],
            permissionStates: _permissionStates,
            onPermissionChanged: _updatePermissionState,
          ),
          const SizedBox(height: 16),
          // Info text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Permissions can be changed later in Settings.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Permission item model for the page
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
