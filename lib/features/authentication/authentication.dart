/// Authentication feature barrel export.
///
/// Exports all authentication-related components for easy import.
library authentication;

//--------------------------------------------------------------------------
// Constants
//--------------------------------------------------------------------------
export 'constants/auth_constants.dart';
export 'constants/auth_messages.dart';
export 'constants/auth_regex.dart';
export 'constants/auth_routes.dart';

//--------------------------------------------------------------------------
// Enums
//--------------------------------------------------------------------------
export 'enums/auth_provider.dart';
export 'enums/auth_result.dart';
export 'enums/auth_status.dart';
export 'enums/login_method.dart';
export 'enums/otp_type.dart';
export 'enums/password_strength.dart';
export 'enums/session_status.dart';
export 'enums/verification_status.dart';

//--------------------------------------------------------------------------
// Models
//--------------------------------------------------------------------------
export 'models/auth_session_model.dart';
export 'models/login_request_model.dart';
export 'models/login_response_model.dart';
export 'models/register_request_model.dart';
export 'models/password_reset_model.dart';
export 'models/otp_request_model.dart';
export 'models/otp_verification_model.dart';
export 'models/email_verification_model.dart';
export 'models/remember_me_model.dart';

//--------------------------------------------------------------------------
// Providers
//--------------------------------------------------------------------------
export 'providers/auth_controller_provider.dart';
export 'providers/auth_state_provider.dart';
export 'providers/current_user_provider.dart';
export 'providers/session_provider.dart';
export 'providers/splash_provider.dart';
export 'providers/onboarding_provider.dart';

//--------------------------------------------------------------------------
// Repositories
//--------------------------------------------------------------------------
export 'repositories/auth_repository.dart';
export 'repositories/auth_repository_impl.dart';

//--------------------------------------------------------------------------
// Services
//--------------------------------------------------------------------------
export 'services/auth_service.dart';
export 'services/firebase_auth_service.dart';
export 'services/session_service.dart';
export 'services/remember_me_service.dart';
export 'services/biometric_service.dart';
export 'services/token_service.dart';

//--------------------------------------------------------------------------
// Controllers
//--------------------------------------------------------------------------
export 'controllers/auth_controller.dart';
export 'controllers/login_controller.dart';
export 'controllers/register_controller.dart';
export 'controllers/forgot_password_controller.dart';
export 'controllers/otp_controller.dart';
export 'controllers/onboarding_controller.dart';

//--------------------------------------------------------------------------
// Validators
//--------------------------------------------------------------------------
export 'validators/email_validator.dart';
export 'validators/password_validator.dart';
export 'validators/username_validator.dart';
export 'validators/phone_validator.dart';
export 'validators/otp_validator.dart';

//--------------------------------------------------------------------------
// Helpers
//--------------------------------------------------------------------------
export 'helpers/auth_error_mapper.dart';
export 'helpers/auth_redirect_helper.dart';
export 'helpers/auth_permission_helper.dart';
export 'helpers/password_strength_helper.dart';
export 'helpers/auth_navigation_helper.dart';

//--------------------------------------------------------------------------
// Routes
//--------------------------------------------------------------------------
export 'routes/authentication_routes.dart';

//--------------------------------------------------------------------------
// Extensions
//--------------------------------------------------------------------------
export 'extensions/auth_status_extension.dart';
export 'extensions/login_method_extension.dart';

//--------------------------------------------------------------------------
// Views - Pages
//--------------------------------------------------------------------------
export 'views/pages/splash_page.dart';
export 'views/pages/onboarding_page.dart';
export 'views/pages/welcome_page.dart';
export 'views/pages/login_page.dart';
export 'views/pages/register_page.dart';
export 'views/pages/forgot_password_page.dart';
export 'views/pages/reset_password_page.dart';
export 'views/pages/verify_email_page.dart';
export 'views/pages/otp_page.dart';
export 'views/pages/account_blocked_page.dart';

//--------------------------------------------------------------------------
// Views - Sections
//--------------------------------------------------------------------------
export 'views/sections/login_form_section.dart';
export 'views/sections/register_form_section.dart';
export 'views/sections/social_login_section.dart';
export 'views/sections/password_section.dart';
export 'views/sections/otp_section.dart';
export 'views/sections/terms_section.dart';

//--------------------------------------------------------------------------
// Views - Widgets
//--------------------------------------------------------------------------
export 'views/widgets/login_button.dart';
export 'views/widgets/google_login_button.dart';
export 'views/widgets/remember_me_tile.dart';
export 'views/widgets/password_strength_indicator.dart';
export 'views/widgets/auth_header.dart';
export 'views/widgets/auth_footer.dart';
export 'views/widgets/auth_logo.dart';
export 'views/widgets/otp_input.dart';
export 'views/widgets/resend_timer.dart';
export 'views/widgets/verification_banner.dart';

//--------------------------------------------------------------------------
// Views - Dialogs
//--------------------------------------------------------------------------
export 'views/dialogs/logout_dialog.dart';
export 'views/dialogs/delete_account_dialog.dart';
export 'views/dialogs/resend_email_dialog.dart';
export 'views/dialogs/session_expired_dialog.dart';
