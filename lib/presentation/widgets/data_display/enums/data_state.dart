// lib/presentation/widgets/data_display/enums/data_state.dart

/// The state of the data being displayed.
enum DataState {
  /// Data is being loaded.
  loading,

  /// Data is empty.
  empty,

  /// Data is loaded successfully.
  loaded,

  /// Data failed to load.
  error,
}
