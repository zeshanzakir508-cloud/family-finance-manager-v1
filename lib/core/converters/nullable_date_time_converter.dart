import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// ============================================================================
/// Nullable DateTime Converter
/// ============================================================================
class NullableDateTimeConverter
    implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) {
      return null;
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
      'Unsupported nullable DateTime value: $json',
    );
  }

  @override
  Object? toJson(DateTime? object) {
    if (object == null) {
      return null;
    }

    return Timestamp.fromDate(object);
  }
}
