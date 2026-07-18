// lib/data/datasources/remote/firestore_family_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../../../domain/exceptions/family_exceptions.dart';
import '../../models/family_model.dart';
import '../../models/family_member_model.dart';

/// Data source for Firestore Family operations.
///
/// This class handles all direct communication with Firestore for family-related
/// operations and converts Firestore results to models. It is the only layer that
/// should contain Firestore query logic for families and family members.
///
/// This class MUST NOT contain any business logic, validation, UI code, or Riverpod code.
class FirestoreFamilyDataSource {
  final FirebaseFirestore _firestore;
  final Random _random;

  FirestoreFamilyDataSource({
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        _random = Random.secure();

  /// Collection reference for families.
  CollectionReference<Map<String, dynamic>> get _familiesCollection =>
      _firestore.collection('families');

  /// Collection reference for family members.
  CollectionReference<Map<String, dynamic>> get _membersCollection =>
      _firestore.collection('familyMembers');

  /// Document reference for a specific family.
  DocumentReference<Map<String, dynamic>> _familyDocument(String familyId) =>
      _familiesCollection.doc(familyId);

  /// Document reference for a specific family member.
  DocumentReference<Map<String, dynamic>> _memberDocument(String memberId) =>
      _membersCollection.doc(memberId);

  /// Gets the members subcollection for a family.
  CollectionReference<Map<String, dynamic>> _familyMembersCollection(String familyId) =>
      _familiesCollection.doc(familyId).collection('members');

  /// Executes a Firestore operation with consistent error handling.
  Future<T> _execute<T>(
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const FamilyDataException('Unexpected family data source error.'),
        stackTrace,
      );
    }
  }

  /// Executes a stream Firestore operation with consistent error handling.
  Stream<T> _executeStream<T>(
    Stream<T> Function() action,
  ) async* {
    try {
      await for (final value in action()) {
        yield value;
      }
    } on FirebaseException catch (e, stackTrace) {
      Error.throwWithStackTrace(_handleFirestoreException(e), stackTrace);
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        const FamilyDataException('Unexpected family stream error.'),
        stackTrace,
      );
    }
  }

  /// Converts FirestoreException to domain FamilyException.
  FamilyException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const FamilyDataException('Permission denied to access family data.');
      case 'not-found':
        return const FamilyNotFoundException('Family not found.');
      case 'already-exists':
        return const FamilyDataException('Family already exists.');
      case 'failed-precondition':
        return const FamilyDataException('Precondition failed for family operation.');
      case 'aborted':
        return const FamilyDataException('Family operation was aborted.');
      case 'out-of-range':
        return const FamilyDataException('Family operation out of range.');
      case 'unimplemented':
        return const FamilyDataException('Family operation not implemented.');
      case 'internal':
        return const FamilyDataException('Internal error accessing family data.');
      case 'unavailable':
        return const FamilyDataException('Family service is temporarily unavailable.');
      case 'deadline-exceeded':
        return const FamilyDataException('Family operation timed out.');
      default:
        return FamilyDataException('Family error: ${e.message ?? 'Unknown error'}');
    }
  }

  /// Converts Firestore DocumentSnapshot to FamilyModel.
  FamilyModel _documentToFamilyModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const FamilyDataException('Family document data is null.');
    }

    return FamilyModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
      icon: data['icon'] as String?,
      color: data['color'] as String?,
      createdBy: data['createdBy'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      joinCode: data['joinCode'] as String?,
      maxMembers: data['maxMembers'] as int? ?? 10,
      settings: (data['settings'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts Firestore DocumentSnapshot to FamilyMemberModel.
  FamilyMemberModel _documentToMemberModel(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw const FamilyDataException('Family member document data is null.');
    }

    final joinedAt = (data['joinedAt'] as Timestamp?)?.toDate();
    if (joinedAt == null) {
      throw const FamilyDataException('Family member joined date is required.');
    }

    return FamilyMemberModel(
      id: doc.id,
      familyId: data['familyId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      role: data['role'] as String? ?? 'member',
      permissions: (data['permissions'] as Map<String, dynamic>?) ?? {},
      joinedAt: joinedAt,
      invitedBy: data['invitedBy'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts FamilyModel to Firestore map for creation.
  Map<String, dynamic> _familyToCreateMap(FamilyModel model) {
    return {
      'name': model.name,
      'description': model.description,
      'icon': model.icon,
      'color': model.color,
      'createdBy': model.createdBy,
      'isActive': model.isActive,
      'joinCode': model.joinCode,
      'maxMembers': model.maxMembers,
      'settings': model.settings,
    };
  }

  /// Converts FamilyModel to Firestore map for updates.
  Map<String, dynamic> _familyToUpdateMap(FamilyModel model) {
    final map = <String, dynamic>{
      'name': model.name,
      'isActive': model.isActive,
      'maxMembers': model.maxMembers,
      'settings': model.settings,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.description != null) map['description'] = model.description;
    if (model.icon != null) map['icon'] = model.icon;
    if (model.color != null) map['color'] = model.color;
    if (model.joinCode != null) map['joinCode'] = model.joinCode;

    return map;
  }

  /// Creates a map for creating a new family with server timestamps.
  Map<String, dynamic> _createFamilyWithTimestamps(FamilyModel model) {
    return {
      ..._familyToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converts FamilyMemberModel to Firestore map for creation.
  Map<String, dynamic> _memberToCreateMap(FamilyMemberModel model) {
    return {
      'familyId': model.familyId,
      'userId': model.userId,
      'email': model.email,
      'displayName': model.displayName,
      'photoUrl': model.photoUrl,
      'role': model.role,
      'permissions': model.permissions,
      'joinedAt': model.joinedAt,
      'invitedBy': model.invitedBy,
      'isActive': model.isActive,
    };
  }

  /// Converts FamilyMemberModel to Firestore map for updates.
  Map<String, dynamic> _memberToUpdateMap(FamilyMemberModel model) {
    final map = <String, dynamic>{
      'role': model.role,
      'permissions': model.permissions,
      'isActive': model.isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only include optional fields if they have values
    if (model.displayName != null) map['displayName'] = model.displayName;
    if (model.photoUrl != null) map['photoUrl'] = model.photoUrl;

    return map;
  }

  /// Creates a map for creating a new family member with server timestamps.
  Map<String, dynamic> _createMemberWithTimestamps(FamilyMemberModel model) {
    return {
      ..._memberToCreateMap(model),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Generates a cryptographically secure join code.
  String _generateSecureJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final code = String.fromCharCodes(
      List.generate(6, (_) {
        final index = _random.nextInt(chars.length);
        return chars.codeUnitAt(index);
      }),
    );
    return code;
  }

  // ==================== Family Read Operations ====================

  /// Gets a family by ID.
  Future<FamilyModel> getFamily(String familyId) {
    return _execute(() async {
      final doc = await _familyDocument(familyId).get();
      if (!doc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }
      return _documentToFamilyModel(doc);
    });
  }

  /// Gets all families for a user.
  Future<List<FamilyModel>> getFamiliesByUserId(String userId) {
    return _execute(() async {
      // First, get all family memberships for this user
      final memberQuery = await _membersCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      if (memberQuery.docs.isEmpty) {
        return [];
      }

      // Then get the corresponding families in parallel
      final familyIds = memberQuery.docs
          .map((doc) => doc.data()['familyId'] as String?)
          .where((id) => id != null)
          .cast<String>()
          .toList();

      if (familyIds.isEmpty) {
        return [];
      }

      // Use Future.wait for parallel reads
      final familyDocs = await Future.wait(
        familyIds.map((id) => _familyDocument(id).get()),
      );

      final families = <FamilyModel>[];
      for (final doc in familyDocs) {
        if (doc.exists) {
          families.add(_documentToFamilyModel(doc));
        }
      }

      return families;
    });
  }

  /// Gets a family by join code.
  Future<FamilyModel> getFamilyByJoinCode(String joinCode) {
    return _execute(() async {
      final query = await _familiesCollection
          .where('joinCode', isEqualTo: joinCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const FamilyNotFoundException('Family not found with this join code.');
      }

      return _documentToFamilyModel(query.docs.first);
    });
  }

  // ==================== Family Write Operations ====================

  /// Creates a new family.
  Future<FamilyModel> createFamily(FamilyModel family) {
    return _execute(() async {
      final docRef = _familiesCollection.doc();
      final newFamily = family.copyWith(
        id: docRef.id,
      );

      await docRef.set(_createFamilyWithTimestamps(newFamily));

      // Get the created document with server timestamps
      final doc = await docRef.get();
      return _documentToFamilyModel(doc);
    });
  }

  /// Updates an existing family.
  Future<FamilyModel> updateFamily(FamilyModel family) {
    return _execute(() async {
      final docRef = _familyDocument(family.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }

      await docRef.update(_familyToUpdateMap(family));

      // Get the updated document with server timestamps
      final updatedDoc = await docRef.get();
      return _documentToFamilyModel(updatedDoc);
    });
  }

  /// Deletes a family (soft delete).
  Future<void> deleteFamily(String familyId) {
    return _execute(() async {
      final docRef = _familyDocument(familyId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }

      // Soft delete - mark as inactive
      await docRef.update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Permanently deletes a family and all its members.
  Future<void> deleteFamilyPermanent(String familyId) {
    return _execute(() async {
      final docRef = _familyDocument(familyId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }

      // Delete all family members
      final membersQuery = await _familyMembersCollection(familyId).get();

      final batch = _firestore.batch();

      // Delete the family
      batch.delete(docRef);

      // Delete all members from subcollection
      for (final memberDoc in membersQuery.docs) {
        batch.delete(memberDoc.reference);
      }

      // Also delete from the global members collection
      final globalMembersQuery = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .get();

      for (final memberDoc in globalMembersQuery.docs) {
        batch.delete(memberDoc.reference);
      }

      await batch.commit();
    });
  }

  /// Generates a new join code for a family.
  Future<String> generateJoinCode(String familyId) {
    return _execute(() async {
      final docRef = _familyDocument(familyId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }

      final code = _generateSecureJoinCode();

      await docRef.update({
        'joinCode': code,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return code;
    });
  }

  // ==================== Family Member Operations ====================

  /// Adds a member to a family.
  Future<FamilyMemberModel> addFamilyMember(FamilyMemberModel member) {
    return _execute(() async {
      // Check if family exists and is active
      final familyDoc = await _familyDocument(member.familyId).get();
      if (!familyDoc.exists) {
        throw const FamilyNotFoundException('Family not found.');
      }

      final familyData = familyDoc.data();
      if (familyData?['isActive'] != true) {
        throw const FamilyDataException('Family is not active.');
      }

      // Check if user is already a member
      final existingQuery = await _membersCollection
          .where('familyId', isEqualTo: member.familyId)
          .where('userId', isEqualTo: member.userId)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        throw const FamilyDataException('User is already a member of this family.');
      }

      // Create member in subcollection
      final memberRef = _familyMembersCollection(member.familyId).doc();
      final newMember = member.copyWith(
        id: memberRef.id,
        joinedAt: DateTime.now(),
      );

      // Use a batch for atomic writes
      final batch = _firestore.batch();

      // Add to subcollection
      batch.set(
        memberRef,
        _createMemberWithTimestamps(newMember),
      );

      // Add to global members collection
      final globalMemberRef = _membersCollection.doc(memberRef.id);
      batch.set(
        globalMemberRef,
        _createMemberWithTimestamps(newMember),
      );

      await batch.commit();

      // Get the created document with server timestamps
      final doc = await memberRef.get();
      return _documentToMemberModel(doc);
    });
  }

  /// Updates a family member.
  Future<FamilyMemberModel> updateFamilyMember(FamilyMemberModel member) {
    return _execute(() async {
      final memberRef = _familyMembersCollection(member.familyId).doc(member.id);
      final doc = await memberRef.get();

      if (!doc.exists) {
        throw const FamilyDataException('Family member not found.');
      }

      final updateData = _memberToUpdateMap(member);

      // Use a batch for atomic writes
      final batch = _firestore.batch();

      // Update in subcollection
      batch.update(memberRef, updateData);

      // Update in global members collection
      final globalMemberRef = _membersCollection.doc(member.id);
      batch.update(globalMemberRef, updateData);

      await batch.commit();

      // Get the updated document with server timestamps
      final updatedDoc = await memberRef.get();
      return _documentToMemberModel(updatedDoc);
    });
  }

  /// Removes a member from a family.
  Future<void> removeFamilyMember(String familyId, String userId) {
    return _execute(() async {
      // Find the member document
      final query = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const FamilyDataException('Family member not found.');
      }

      final memberDoc = query.docs.first;
      final memberId = memberDoc.id;

      // Use a batch for atomic writes
      final batch = _firestore.batch();

      // Delete from subcollection
      batch.delete(_familyMembersCollection(familyId).doc(memberId));

      // Delete from global members collection
      batch.delete(_membersCollection.doc(memberId));

      await batch.commit();
    });
  }

  /// Gets all members of a family.
  Future<List<FamilyMemberModel>> getFamilyMembers(String familyId) {
    return _execute(() async {
      final query = await _familyMembersCollection(familyId)
          .where('isActive', isEqualTo: true)
          .get();

      return query.docs.map(_documentToMemberModel).toList();
    });
  }

  /// Gets a specific family member.
  Future<FamilyMemberModel> getFamilyMember(String familyId, String userId) {
    return _execute(() async {
      final query = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const FamilyDataException('Family member not found.');
      }

      return _documentToMemberModel(query.docs.first);
    });
  }

  /// Checks if a user is in a family.
  Future<bool> isUserInFamily(String familyId, String userId) {
    return _execute(() async {
      final query = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    });
  }

  /// Updates a member's role.
  Future<void> updateFamilyMemberRole(String familyId, String userId, String role) {
    return _execute(() async {
      final query = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const FamilyDataException('Family member not found.');
      }

      final memberDoc = query.docs.first;
      final memberId = memberDoc.id;

      final updateData = {
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Use a batch for atomic writes
      final batch = _firestore.batch();

      // Update in subcollection
      batch.update(_familyMembersCollection(familyId).doc(memberId), updateData);

      // Update in global members collection
      batch.update(_membersCollection.doc(memberId), updateData);

      await batch.commit();
    });
  }

  /// Updates a member's permissions.
  Future<void> updateFamilyMemberPermissions(
    String familyId,
    String userId,
    Map<String, dynamic> permissions,
  ) {
    return _execute(() async {
      final query = await _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const FamilyDataException('Family member not found.');
      }

      final memberDoc = query.docs.first;
      final memberId = memberDoc.id;

      final updateData = {
        'permissions': permissions,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Use a batch for atomic writes
      final batch = _firestore.batch();

      // Update in subcollection
      batch.update(_familyMembersCollection(familyId).doc(memberId), updateData);

      // Update in global members collection
      batch.update(_membersCollection.doc(memberId), updateData);

      await batch.commit();
    });
  }

  // ==================== Stream Operations ====================

  /// Watches a family in real-time.
  Stream<FamilyModel> watchFamily(String familyId) {
    return _executeStream(
      () => _familyDocument(familyId).snapshots().map((doc) {
        if (!doc.exists) {
          throw const FamilyNotFoundException('Family not found.');
        }
        return _documentToFamilyModel(doc);
      }),
    );
  }

  /// Watches all families for a user in real-time.
  Stream<List<FamilyModel>> watchFamiliesByUserId(String userId) {
    return _executeStream(
      () => _membersCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .asyncMap((memberQuery) async {
            if (memberQuery.docs.isEmpty) {
              return <FamilyModel>[];
            }

            final familyIds = memberQuery.docs
                .map((doc) => doc.data()['familyId'] as String?)
                .where((id) => id != null)
                .cast<String>()
                .toList();

            if (familyIds.isEmpty) {
              return <FamilyModel>[];
            }

            // Use Future.wait for parallel reads
            final familyDocs = await Future.wait(
              familyIds.map((id) => _familyDocument(id).get()),
            );

            final families = <FamilyModel>[];
            for (final doc in familyDocs) {
              if (doc.exists) {
                families.add(_documentToFamilyModel(doc));
              }
            }
            return families;
          }),
    );
  }

  /// Watches all members of a family in real-time.
  Stream<List<FamilyMemberModel>> watchFamilyMembers(String familyId) {
    return _executeStream(
      () => _familyMembersCollection(familyId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((query) => query.docs.map(_documentToMemberModel).toList()),
    );
  }

  /// Watches a specific family member in real-time.
  Stream<FamilyMemberModel> watchFamilyMember(String familyId, String userId) {
    return _executeStream(
      () => _membersCollection
          .where('familyId', isEqualTo: familyId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .snapshots()
          .map((query) {
            if (query.docs.isEmpty) {
              throw const FamilyDataException('Family member not found.');
            }
            return _documentToMemberModel(query.docs.first);
          }),
    );
  }
}
