/// Categories Feature
///
/// This feature provides complete category management functionality including:
/// - Create, edit, and delete categories
/// - Archive and restore categories
/// - Merge categories
/// - Category search and filtering
/// - Category selection for transactions
///
/// The feature follows a clean architecture approach with:
/// - Validators for input validation
/// - Services for Firebase/API communication
/// - Repositories for data operations
/// - Controllers for business logic
/// - Providers for state management (Riverpod)
/// - Routes for navigation
/// - Views for UI components

// Validators
export 'validators/category_validator.dart';

// Services
export 'services/category_service.dart';

// Repositories
export 'repositories/category_repository.dart';

// Controllers
export 'controllers/category_controller.dart';

// Providers
export 'providers/category_provider.dart';

// Routes
export 'routes/category_routes.dart';

// Views - Pages
export 'views/pages/categories_page.dart';
export 'views/pages/add_category_page.dart';
export 'views/pages/edit_category_page.dart';

// Views - Sections
export 'views/sections/categories_summary_section.dart';
export 'views/sections/categories_list_section.dart';

// Views - Widgets
export 'views/widgets/category_card.dart';
export 'views/widgets/category_selector.dart';

// Views - Dialogs
export 'views/dialogs/delete_category_dialog.dart';
export 'views/dialogs/merge_category_dialog.dart';
