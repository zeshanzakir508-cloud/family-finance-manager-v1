import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// ============================================================================
/// Family Finance Manager
/// DateTime Converter
/// ----------------------------------------------------------------------------
/// Converts between Firestore Timestamp and Dart DateTime.
///
/// Used by json_serializable models.
///
/// Firestore  -> Timestamp
/// App        -> DateTime
/// ============================================================================
class DateTimeConverter
    implements JsonConverter<DateTime, Object?> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) {
      return DateTime.now();
    }

    if (json is Timestamp) {
      return json.toDate();
    }

    if (json is DateTime) {
      return json;
    }

    if (json is String) {
      return DateTime.parse(json);
    }

    throw ArgumentError(
      'Unsupported DateTime value: $json',
    );
  }

  @override
  Object toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
