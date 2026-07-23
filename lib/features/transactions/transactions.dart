/// Transactions Feature
///
/// This feature provides complete transaction management functionality including:
/// - Create, edit, and delete transactions
/// - Income, expense, and transfer transactions
/// - Recurring transactions
/// - Transaction search and filtering
/// - Transaction sorting
/// - Transaction duplication
/// - Transaction details view
///
/// The feature follows a clean architecture approach with:
/// - Constants for configuration
/// - Enums for type safety
/// - Validators for input validation
/// - Services for Firebase/API communication
/// - Repositories for data operations
/// - Controllers for business logic
/// - Providers for state management (Riverpod)
/// - Routes for navigation
/// - Views for UI components

// Constants
export 'constants/transaction_constants.dart';

// Enums
export 'enums/transaction_type.dart';
export 'enums/transaction_status.dart';
export 'enums/transaction_sort.dart';
export 'enums/recurring_frequency.dart';

// Validators
export 'validators/transaction_validator.dart';

// Services
export 'services/transaction_service.dart';

// Repositories
export 'repositories/transaction_repository.dart';

// Controllers
export 'controllers/transaction_controller.dart';

// Providers
export 'providers/transaction_provider.dart';

// Routes
export 'routes/transaction_routes.dart';

// Views - Pages
export 'views/pages/transactions_page.dart';
export 'views/pages/add_transaction_page.dart';
export 'views/pages/edit_transaction_page.dart';
export 'views/pages/transaction_details_page.dart';
export 'views/pages/recurring_transactions_page.dart';

// Views - Sections
export 'views/sections/transaction_summary_section.dart';
export 'views/sections/transactions_list_section.dart';

// Views - Widgets
export 'views/widgets/transaction_card.dart';
export 'views/widgets/transaction_type_chip.dart';
export 'views/widgets/transaction_filter_bar.dart';
export 'views/widgets/recurring_transaction_card.dart';

// Views - Dialogs
export 'views/dialogs/delete_transaction_dialog.dart';
export 'views/dialogs/duplicate_transaction_dialog.dart';
