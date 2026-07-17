/// Base contract for all application models.
///
/// Every model in the application should extend this class to ensure a
/// consistent structure and API.
///
/// Note:
/// - This class is intentionally NOT annotated with @JsonSerializable.
/// - Concrete models are responsible for implementing JSON serialization.
abstract class BaseModel {
  /// Unique identifier of the document/object.
  String get id;

  /// Date and time when this record was created.
  DateTime get createdAt;

  /// Date and time when this record was last updated.
  DateTime get updatedAt;

  /// Soft delete flag.
  ///
  /// Records are never permanently deleted immediately. Instead,
  /// they are marked as deleted and can be restored if required.
  bool get isDeleted;

  /// Date and time when the record was soft deleted.
  ///
  /// Null if the record has not been deleted.
  DateTime? get deletedAt;

  /// Model schema version.
  ///
  /// Useful for future migrations when the data structure evolves.
  int get version;

  /// Converts the model into a JSON-compatible map.
  Map<String, dynamic> toJson();

  /// Converts the model into a Firestore-compatible map.
  ///
  /// Currently this can be identical to [toJson()], but keeping it separate
  /// allows future customization (e.g. Firestore Timestamps).
  Map<String, dynamic> toFirestore();
}
