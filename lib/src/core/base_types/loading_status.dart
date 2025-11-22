/// Represents the loading status of an asynchronous operation
enum LoadingStatus {
  /// Initial state, no operation has been started
  initial,

  /// Operation is in progress
  loading,

  /// Operation completed successfully
  success,

  /// Operation failed with an error
  error,
}
