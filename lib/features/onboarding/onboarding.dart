/// Onboarding Feature
///
/// This feature provides a complete onboarding flow for new users,
/// including welcome screen, permissions, terms acceptance, family setup,
/// account creation, category selection, and completion celebration.
///
/// The feature follows a clean architecture approach with:
/// - Constants for configuration
/// - Enums for step and status management
/// - Models for data representation
/// - Validators for business rules
/// - Extensions for UI enhancements
/// - Services for data persistence
/// - Repository for data operations
/// - Providers for state management (Riverpod)
/// - Controller for business logic
/// - Helpers for utilities
/// - Routes for navigation
/// - Views for UI components

// Constants
export 'constants/onboarding_constants.dart';
export 'constants/onboarding_assets.dart';

// Enums
export 'enums/onboarding_step.dart';
export 'enums/onboarding_status.dart';

// Models
export 'models/onboarding_page_model.dart';
export 'models/onboarding_progress_model.dart';

// Validators
export 'validators/onboarding_validator.dart';

// Extensions
export 'extensions/onboarding_extensions.dart';

// Services
export 'services/onboarding_service.dart';
export 'services/onboarding_storage_service.dart';

// Repositories
export 'repositories/onboarding_repository.dart';

// Providers
export 'providers/onboarding_state.dart';
export 'providers/onboarding_notifier.dart';
export 'providers/onboarding_provider.dart';

// Controllers
export 'controllers/onboarding_controller.dart';

// Helpers
export 'helpers/onboarding_helper.dart';
export 'helpers/onboarding_navigation_helper.dart';

// Routes
export 'routes/onboarding_routes.dart';

// Views - Pages
export 'views/pages/splash_redirect_page.dart';
export 'views/pages/onboarding_page.dart';
export 'views/pages/intro_page.dart';
export 'views/pages/permissions_page.dart';
export 'views/pages/terms_privacy_page.dart';
export 'views/pages/family_setup_page.dart';
export 'views/pages/account_setup_page.dart';
export 'views/pages/category_setup_page.dart';
export 'views/pages/finish_onboarding_page.dart';

// Views - Sections
export 'views/sections/intro_section.dart';
export 'views/sections/permissions_section.dart';
export 'views/sections/progress_indicator_section.dart';
export 'views/sections/page_indicator_section.dart';
export 'views/sections/family_options_section.dart';
export 'views/sections/account_preview_section.dart';
export 'views/sections/category_preview_section.dart';

// Views - Widgets
export 'views/widgets/onboarding_card.dart';
export 'views/widgets/onboarding_button.dart';
export 'views/widgets/onboarding_header.dart';
export 'views/widgets/onboarding_footer.dart';
export 'views/widgets/onboarding_image.dart';
export 'views/widgets/skip_button.dart';
export 'views/widgets/next_button.dart';
export 'views/widgets/back_button.dart';
export 'views/widgets/page_indicator.dart';
export 'views/widgets/permission_tile.dart';
export 'views/widgets/feature_tile.dart';

// Views - Dialogs
export 'views/dialogs/exit_onboarding_dialog.dart';
export 'views/dialogs/skip_confirmation_dialog.dart';

// Views - Sheets
export 'views/sheets/permission_sheet.dart';
export 'views/sheets/family_selection_sheet.dart';
