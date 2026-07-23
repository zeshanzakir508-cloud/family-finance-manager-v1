/// Accounts Feature
///
/// This feature provides complete account management functionality including:
/// - Create, edit, and delete accounts
/// - Archive and restore accounts
/// - Transfer money between accounts
/// - Account search and filtering
/// - Account balance tracking
///
/// The feature follows a clean architecture approach with:
/// - Constants for configuration
/// - Models for data representation
/// - Validators for input validation
/// - Services for Firebase/API communication
/// - Repositories for data operations
/// - Controllers for business logic
/// - Providers for state management (Riverpod)
/// - Routes for navigation
/// - Views for UI components

// Constants
export 'constants/account_constants.dart';
export 'constants/account_messages.dart';

// Models
export 'models/account_model.dart';

// Validators
export 'validators/account_validator.dart';

// Services
export 'services/account_service.dart';

// Repositories
export 'repositories/account_repository.dart';

// Controllers
export 'controllers/account_controller.dart';

// Providers
export 'providers/account_provider.dart';

// Routes
export 'routes/account_routes.dart';

// Views - Pages
export 'views/pages/accounts_page.dart';
export 'views/pages/account_details_page.dart';
export 'views/pages/add_account_page.dart';
export 'views/pages/edit_account_page.dart';
export 'views/pages/transfer_between_accounts_page.dart';

// Views - Sections
export 'views/sections/accounts_summary_section.dart';
export 'views/sections/accounts_list_section.dart';

// Views - Widgets
export 'views/widgets/account_card.dart';
export 'views/widgets/account_selector.dart';

// Views - Dialogs
export 'views/dialogs/delete_account_dialog.dart';
export 'views/dialogs/archive_account_dialog.dart';
