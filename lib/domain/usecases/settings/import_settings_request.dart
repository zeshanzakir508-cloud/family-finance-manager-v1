/// Request object for importing application settings.
class ImportSettingsRequest {
  final String familyId;
  final Map<String, dynamic> data;

  const ImportSettingsRequest({
    required this.familyId,
    required this.data,
  });
}
