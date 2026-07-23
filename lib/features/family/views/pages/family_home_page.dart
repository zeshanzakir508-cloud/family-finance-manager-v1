import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/family_provider.dart';
import '../sections/family_header_section.dart';
import '../sections/family_statistics_section.dart';
import '../sections/members_section.dart';
import '../sections/pending_invites_section.dart';
import '../widgets/family_card.dart';
import '../widgets/empty_family_widget.dart';

/// Family home page showing family overview
class FamilyHomePage extends ConsumerWidget {
  const FamilyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyStateProvider);
    final actions = ref.watch(familyActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: state.currentFamily != null
                ? () => context.goToInviteMembers()
                : null,
            tooltip: 'Invite Members',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  context.goToFamilySettings();
                  break;
                case 'members':
                  context.goToFamilyMembers();
                  break;
                case 'roles':
                  context.goToRolesPermissions();
                  break;
                case 'leave':
                  context.goToLeaveFamily();
                  break;
                case 'delete':
                  context.goToDeleteFamily();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'members',
                child: Text('Members'),
              ),
              if (state.isOwner) ...[
                const PopupMenuItem(
                  value: 'roles',
                  child: Text('Roles & Permissions'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Family'),
                ),
              ],
              const PopupMenuItem(
                value: 'leave',
                child: Text('Leave Family'),
              ),
            ],
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.currentFamily == null
              ? _buildEmptyState(context)
              : _buildFamilyContent(context, state, actions),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyFamilyWidget(
      onCreatePressed: () => context.goToCreateFamily(),
      onJoinPressed: () => context.goToJoinFamily(),
    );
  }

  Widget _buildFamilyContent(
    BuildContext context,
    FamilyState state,
    FamilyActions actions,
  ) {
    return RefreshIndicator(
      onRefresh: () => actions.refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Family header
            FamilyHeaderSection(
              family: state.currentFamily!,
              memberCount: state.memberCount,
              isOwner: state.isOwner,
              isModerator: state.isModerator,
            ),
            const SizedBox(height: 16),
            // Statistics
            FamilyStatisticsSection(
              statistics: state.statistics,
              memberCount: state.memberCount,
              pendingInvites: state.pendingInviteCount,
            ),
            const SizedBox(height: 16),
            // Members preview
            MembersSection(
              members: state.members.take(5).toList(),
              totalCount: state.memberCount,
              onViewAll: () => context.goToFamilyMembers(),
              onMemberTap: (member) => context.goToMemberProfile(member.id),
            ),
            const SizedBox(height: 16),
            // Pending invites
            if (state.hasPendingInvitations)
              PendingInvitesSection(
                invitations: state.pendingInvitations,
                onViewAll: () => context.goToInviteMembers(),
              ),
          ],
        ),
      ),
    );
  }
}
