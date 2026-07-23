/// Family Feature
///
/// This feature provides complete family management functionality including:
/// - Create, join, leave, and delete families
/// - Member management with roles and permissions
/// - Invitation system with email and code sharing
/// - Activity logging and statistics
/// - Family settings and ownership transfer
///
/// The feature follows a clean architecture approach with:
/// - Constants for configuration
/// - Enums for type safety
/// - Models for data representation
/// - Controllers for business logic
/// - Providers for state management (Riverpod)
/// - Repositories for data operations
/// - Services for Firebase/API communication
/// - Validators for input validation
/// - Helpers for utility functions
/// - Extensions for UI enhancements
/// - Routes for navigation
/// - Views for UI components

// Constants
export 'constants/family_constants.dart';
export 'constants/family_permissions.dart';
export 'constants/family_limits.dart';
export 'constants/family_messages.dart';

// Enums
export 'enums/family_role.dart';
export 'enums/family_status.dart';
export 'enums/member_status.dart';
export 'enums/invite_status.dart';
export 'enums/permission_type.dart';
export 'enums/ownership_transfer_status.dart';

// Models
export 'models/family_invitation_model.dart';
export 'models/family_permission_model.dart';
export 'models/family_activity_model.dart';
export 'models/family_statistics_model.dart';

// Controllers
export 'controllers/family_controller.dart';
export 'controllers/member_controller.dart';
export 'controllers/family_invitation_controller.dart';
export 'controllers/family_settings_controller.dart';

// Providers
export 'providers/family_state.dart';
export 'providers/family_notifier.dart';
export 'providers/family_provider.dart';
export 'providers/family_members_provider.dart';
export 'providers/family_invitation_provider.dart';

// Repositories
export 'repositories/family_repository.dart';
export 'repositories/member_repository.dart';

// Services
export 'services/family_service.dart';
export 'services/member_service.dart';
export 'services/invitation_service.dart';
export 'services/permission_service.dart';

// Validators
export 'validators/family_validator.dart';
export 'validators/member_validator.dart';
export 'validators/invite_validator.dart';

// Helpers
export 'helpers/family_helper.dart';
export 'helpers/family_navigation_helper.dart';
export 'helpers/permission_helper.dart';
export 'helpers/member_helper.dart';

// Extensions
export 'extensions/family_extensions.dart';

// Routes
export 'routes/family_routes.dart';

// Views - Pages
export 'views/pages/family_home_page.dart';
export 'views/pages/create_family_page.dart';
export 'views/pages/join_family_page.dart';
export 'views/pages/family_members_page.dart';
export 'views/pages/member_profile_page.dart';
export 'views/pages/roles_permissions_page.dart';
export 'views/pages/invite_members_page.dart';
export 'views/pages/family_settings_page.dart';
export 'views/pages/ownership_transfer_page.dart';
export 'views/pages/leave_family_page.dart';
export 'views/pages/delete_family_page.dart';

// Views - Sections
export 'views/sections/family_header_section.dart';
export 'views/sections/family_statistics_section.dart';
export 'views/sections/members_section.dart';
export 'views/sections/owner_section.dart';
export 'views/sections/pending_invites_section.dart';
export 'views/sections/roles_section.dart';
export 'views/sections/settings_section.dart';

// Views - Widgets
export 'views/widgets/family_card.dart';
export 'views/widgets/family_member_tile.dart';
export 'views/widgets/member_avatar.dart';
export 'views/widgets/role_chip.dart';
export 'views/widgets/permission_tile.dart';
export 'views/widgets/invite_card.dart';
export 'views/widgets/owner_badge.dart';
export 'views/widgets/family_statistics_card.dart';
export 'views/widgets/empty_family_widget.dart';
export 'views/widgets/join_family_widget.dart';

// Views - Dialogs
export 'views/dialogs/leave_family_dialog.dart';
export 'views/dialogs/remove_member_dialog.dart';
export 'views/dialogs/delete_family_dialog.dart';
export 'views/dialogs/ownership_transfer_dialog.dart';
export 'views/dialogs/invite_cancel_dialog.dart';

// Views - Sheets
export 'views/sheets/member_actions_sheet.dart';
export 'views/sheets/invite_options_sheet.dart';
export 'views/sheets/role_selection_sheet.dart';
