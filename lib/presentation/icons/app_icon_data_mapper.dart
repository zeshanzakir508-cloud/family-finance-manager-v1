// lib/presentation/icons/app_icon_data_mapper.dart

import 'package:flutter/material.dart';

import 'app_icon.dart';

/// A mapper that converts [AppIcon] enum values to Material [IconData].
///
/// This class acts as the bridge between the semantic icon layer and the
/// underlying icon implementation. Currently uses Material Icons, but can be
/// easily swapped to support other icon packages.
///
/// Example:
/// ```dart
/// final iconData = AppIconDataMapper.of(AppIcon.home);
/// // Returns Icons.home
/// ```
abstract final class AppIconDataMapper {
  /// The complete mapping of [AppIcon] to Material [IconData].
  ///
  /// This map defines how semantic icons are translated to Material icons.
  /// Changes to this map affect the entire app's iconography.
  static const Map<AppIcon, IconData> _mappings = {
    // Navigation
    AppIcon.home: Icons.home,
    AppIcon.back: Icons.arrow_back,
    AppIcon.forward: Icons.arrow_forward,
    AppIcon.up: Icons.arrow_upward,
    AppIcon.down: Icons.arrow_downward,
    AppIcon.close: Icons.close,
    AppIcon.menu: Icons.menu,
    AppIcon.more: Icons.more_vert,
    AppIcon.moreHorizontal: Icons.more_horiz,

    // Actions
    AppIcon.add: Icons.add,
    AppIcon.remove: Icons.remove,
    AppIcon.delete: Icons.delete,
    AppIcon.edit: Icons.edit,
    AppIcon.save: Icons.save,
    AppIcon.cancel: Icons.cancel,
    AppIcon.refresh: Icons.refresh,
    AppIcon.search: Icons.search,
    AppIcon.filter: Icons.filter_list,
    AppIcon.sort: Icons.sort,
    AppIcon.share: Icons.share,
    AppIcon.download: Icons.download,
    AppIcon.upload: Icons.upload,
    AppIcon.print: Icons.print,

    // User & Profile
    AppIcon.person: Icons.person,
    AppIcon.account: Icons.account_circle,
    AppIcon.settings: Icons.settings,
    AppIcon.logout: Icons.logout,
    AppIcon.login: Icons.login,

    // Communication
    AppIcon.email: Icons.email,
    AppIcon.phone: Icons.phone,
    AppIcon.message: Icons.message,
    AppIcon.notification: Icons.notifications,
    AppIcon.chat: Icons.chat,

    // Data & Information
    AppIcon.info: Icons.info,
    AppIcon.help: Icons.help,
    AppIcon.warning: Icons.warning,
    AppIcon.error: Icons.error,
    AppIcon.success: Icons.check_circle,

    // Finance
    AppIcon.money: Icons.attach_money,
    AppIcon.creditCard: Icons.credit_card,
    AppIcon.payment: Icons.payment,
    AppIcon.wallet: Icons.account_balance_wallet,
    AppIcon.receipt: Icons.receipt,
    AppIcon.trendingUp: Icons.trending_up,
    AppIcon.trendingDown: Icons.trending_down,

    // Time & Calendar
    AppIcon.calendar: Icons.calendar_today,
    AppIcon.time: Icons.access_time,
    AppIcon.schedule: Icons.schedule,
    AppIcon.clock: Icons.timer,

    // Location
    AppIcon.location: Icons.location_on,
    AppIcon.map: Icons.map,
    AppIcon.pin: Icons.place,

    // Media
    AppIcon.photo: Icons.photo,
    AppIcon.camera: Icons.camera_alt,
    AppIcon.video: Icons.videocam,
    AppIcon.musicNote: Icons.music_note,
    AppIcon.image: Icons.image,

    // Documents
    AppIcon.file: Icons.insert_drive_file,
    AppIcon.folder: Icons.folder,
    AppIcon.pdf: Icons.picture_as_pdf,
    AppIcon.document: Icons.description,

    // Shopping
    AppIcon.cart: Icons.shopping_cart,
    AppIcon.bag: Icons.shopping_bag,
    AppIcon.checkout: Icons.checkout,

    // Status
    AppIcon.check: Icons.check,
    AppIcon.done: Icons.done,
    AppIcon.pending: Icons.pending,
    AppIcon.inProgress: Icons.hourglass_top,
    AppIcon.completed: Icons.verified,

    // Miscellaneous
    AppIcon.star: Icons.star,
    AppIcon.favorite: Icons.favorite,
    AppIcon.lock: Icons.lock,
    AppIcon.unlock: Icons.lock_open,
    AppIcon.visibility: Icons.visibility,
    AppIcon.visibilityOff: Icons.visibility_off,
    AppIcon.device: Icons.devices,
  };

  /// Returns the [IconData] associated with the given [AppIcon].
  ///
  /// If the icon is not found in the mapper, returns [Icons.help_outline]
  /// as a safe default to ensure the UI always has an icon to display.
  ///
  /// Parameters:
  ///   - [icon]: The semantic icon to look up.
  ///
  /// Returns:
  ///   The corresponding [IconData] or [Icons.help_outline] as fallback.
  ///
  /// Example:
  /// ```dart
  /// final iconData = AppIconDataMapper.of(AppIcon.home);
  /// // Returns Icons.home
  /// ```
  static IconData of(AppIcon icon) {
    return _mappings[icon] ?? Icons.help_outline;
  }
}
