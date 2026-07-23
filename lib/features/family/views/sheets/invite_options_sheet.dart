import 'package:flutter/material.dart';

/// Bottom sheet for invitation options
class InviteOptionsSheet extends StatelessWidget {
  final VoidCallback onEmailInvite;
  final VoidCallback? onShareCode;
  final VoidCallback? onViewInvites;
  final VoidCallback? onCancel;

  const InviteOptionsSheet({
    super.key,
    required this.onEmailInvite,
    this.onShareCode,
    this.onViewInvites,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
            'Invite Members',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose how you want to invite members',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Email invite
          _OptionTile(
            icon: Icons.email,
            title: 'Send Email Invite',
            subtitle: 'Send invitation via email',
            color: Colors.blue,
            onTap: () {
              Navigator.pop(context);
              onEmailInvite();
            },
          ),
          const SizedBox(height: 8),
          // Share code
          if (onShareCode != null)
            _OptionTile(
              icon: Icons.share,
              title: 'Share Invite Code',
              subtitle: 'Share the invite code directly',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                onShareCode!.call();
              },
            ),
          const SizedBox(height: 8),
          // View invites
          if (onViewInvites != null)
            _OptionTile(
              icon: Icons.list,
              title: 'View Invites',
              subtitle: 'See all pending invitations',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                onViewInvites!.call();
              },
            ),
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

  /// Show the invite options sheet
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onEmailInvite,
    VoidCallback? onShareCode,
    VoidCallback? onViewInvites,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InviteOptionsSheet(
        onEmailInvite: onEmailInvite,
        onShareCode: onShareCode,
        onViewInvites: onViewInvites,
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
