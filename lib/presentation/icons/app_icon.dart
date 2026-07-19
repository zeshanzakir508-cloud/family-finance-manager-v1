// lib/presentation/icons/app_icon.dart

/// An enumeration of all semantic icons used throughout the application.
///
/// This enum serves as the single source of truth for icon identifiers,
/// providing type-safe, compile-time constant references to icons.
///
/// Example:
/// ```dart
/// final icon = AppIcon.home;
/// ```
enum AppIcon {
  // Navigation
  home,
  back,
  forward,
  up,
  down,
  close,
  menu,
  more,
  moreHorizontal,

  // Actions
  add,
  remove,
  delete,
  edit,
  save,
  cancel,
  refresh,
  search,
  filter,
  sort,
  share,
  download,
  upload,
  print,

  // User & Profile
  person,
  account,
  settings,
  logout,
  login,

  // Communication
  email,
  phone,
  message,
  notification,
  chat,

  // Data & Information
  info,
  help,
  warning,
  error,
  success,

  // Finance
  money,
  creditCard,
  payment,
  wallet,
  receipt,
  trendingUp,
  trendingDown,

  // Time & Calendar
  calendar,
  time,
  schedule,
  clock,

  // Location
  location,
  map,
  pin,

  // Media
  photo,
  camera,
  video,
  musicNote,
  image,

  // Documents
  file,
  folder,
  pdf,
  document,

  // Shopping
  cart,
  bag,
  checkout,

  // Status
  check,
  done,
  pending,
  inProgress,
  completed,

  // Miscellaneous
  star,
  favorite,
  lock,
  unlock,
  visibility,
  visibilityOff,
  device,
}
