/// Base contract for all application models.
///
/// Every model in the application must extend this class to ensure
/// a consistent structure and API.
///
/// Notes:
/// - This class is intentionally NOT annotated with @JsonSerializable.
/// - Concrete models are responsible for JSON serialization.
/// - Every model should remain immutable.
abstract class BaseModel {
  /// Unique identifier.
  String get id;

  /// Record creation timestamp.
  DateTime get createdAt;

  /// Last update timestamp.
  DateTime get updatedAt;

  /// Indicates whether the record has been soft deleted.
  bool get isDeleted;

  /// Soft deletion timestamp.
  ///
  /// Null if the record has not been deleted.
  DateTime? get deletedAt;

  /// Model schema version.
  ///
  /// Increment only when the stored data structure changes.
  int get version;

  /// Converts the model into a JSON-compatible map.
  Map<String, dynamic> toJson();
}
