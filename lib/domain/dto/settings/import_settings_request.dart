/// ============================================================================
/// Family Finance Manager
/// Import Settings Request
/// ----------------------------------------------------------------------------
/// Request object used when importing application settings.
/// ============================================================================
class ImportSettingsRequest {
  /// Family ID.
  final String familyId;

  /// Settings data to import.
  final Map<String, dynamic> data;

  const ImportSettingsRequest({
    required this.familyId,
    required this.data,
  });
}
