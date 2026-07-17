/// Defines activity log event types.
enum ActivityType {
  create,
  update,
  delete,
  login,
  logout,
}

extension ActivityTypeExtension on ActivityType {
  String get value => name;

  bool get isCreate => this == ActivityType.create;

  bool get isUpdate => this == ActivityType.update;

  bool get isDelete => this == ActivityType.delete;

  bool get isLogin => this == ActivityType.login;

  bool get isLogout => this == ActivityType.logout;

  static ActivityType fromValue(String value) {
    return ActivityType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => ActivityType.create,
    );
  }
}
