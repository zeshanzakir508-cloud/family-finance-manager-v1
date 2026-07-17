import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// ============================================================================
/// Family Finance Manager
/// Storage Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Firebase Storage.
///
/// Responsibilities:
/// • Upload files
/// • Upload bytes
/// • Download URLs
/// • Delete files
/// • File metadata
///
/// NOTE:
/// This service contains generic Firebase Storage operations only.
/// Business logic belongs in repository implementations.
/// ============================================================================
class StorageService {
  StorageService({
    required FirebaseStorage storage,
  }) : _storage = storage;

  final FirebaseStorage _storage;

  /// Returns a storage reference.
  Reference reference(String path) {
    return _storage.ref(path);
  }

  /// Uploads raw bytes.
  Future<TaskSnapshot> uploadBytes({
    required String path,
    required Uint8List bytes,
    SettableMetadata? metadata,
  }) {
    return reference(path).putData(
      bytes,
      metadata,
    );
  }

  /// Uploads a local file.
  Future<TaskSnapshot> uploadFile({
    required String path,
    required String filePath,
    SettableMetadata? metadata,
  }) {
    return reference(path).putFile(
      Uri.file(filePath).toFilePath().isNotEmpty
          ? File(filePath)
          : throw ArgumentError('Invalid file path.'),
      metadata,
    );
  }

  /// Returns the download URL.
  Future<String> getDownloadUrl(
    String path,
  ) {
    return reference(path).getDownloadURL();
  }

  /// Returns metadata for a file.
  Future<FullMetadata> getMetadata(
    String path,
  ) {
    return reference(path).getMetadata();
  }

  /// Updates file metadata.
  Future<FullMetadata> updateMetadata({
    required String path,
    required SettableMetadata metadata,
  }) {
    return reference(path).updateMetadata(
      metadata,
    );
  }

  /// Deletes a file.
  Future<void> deleteFile(
    String path,
  ) {
    return reference(path).delete();
  }

  /// Returns true if a file exists.
  Future<bool> fileExists(
    String path,
  ) async {
    try {
      await reference(path).getMetadata();
      return true;
    } on FirebaseException {
      return false;
    }
  }

  /// Lists all files in a folder.
  Future<ListResult> listAll(
    String path,
  ) {
    return reference(path).listAll();
  }
}
