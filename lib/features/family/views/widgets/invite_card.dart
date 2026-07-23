import 'package:flutter/material.dart';
import '../../models/family_invitation_model.dart';
import '../../enums/invite_status.dart';

/// Invite card widget for displaying invitations
class InviteCard extends StatelessWidget {
  final FamilyInvitationModel invitation;
  final VoidCallback? onCancel;
  final VoidCallback? onResend;

  const InviteCard({
    super.key,
    required this.invitation,
    this.onCancel,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = invitation.status == InviteStatus.pending;
    final isExpired = invitation.isExpired;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isPending && !isExpired
                  ? Colors.orange.shade100
                  : Colors.grey.shade200,
              child: Icon(
                isPending && !isExpired
                    ? Icons.hourglass_empty
                    : Icons.check_circle,
                color: isPending && !isExpired
                    ? Colors.orange
                    : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.email ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(),
                    ),
                  ),
                  Text(
                    'Sent ${_getTimeAgo(invitation.createdAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (isPending && !isExpired) ...[
              if (onResend != null && invitation.resendCount < 3)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: onResend,
                  tooltip: 'Resend',
                ),
              if (onCancel != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onCancel,
                  tooltip: 'Cancel',
                  color: Colors.red,
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    if (invitation.isExpired) return 'Expired';
    switch (invitation.status) {
      case InviteStatus.pending:
        return 'Pending response';
      case InviteStatus.accepted:
        return 'Accepted';
      case InviteStatus.rejected:
        return 'Declined';
      case InviteStatus.expired:
        return 'Expired';
      case InviteStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor() {
    if (invitation.isExpired) return Colors.grey;
    switch (invitation.status) {
      case InviteStatus.pending:
        return Colors.orange;
      case InviteStatus.accepted:
        return Colors.green;
      case InviteStatus.rejected:
        return Colors.red;
      case InviteStatus.expired:
        return Colors.grey;
      case InviteStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }
}
