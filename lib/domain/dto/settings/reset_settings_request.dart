/// ============================================================================
/// Family Finance Manager
/// Reset Settings Request
/// ----------------------------------------------------------------------------
/// Request object used when resetting application settings to defaults.
/// ============================================================================
class ResetSettingsRequest {
  /// Family ID.
  final String familyId;

  const ResetSettingsRequest({
    required this.familyId,
  });
}
