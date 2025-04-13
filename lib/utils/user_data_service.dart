import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  static final UserDataService _instance = UserDataService._internal();

  factory UserDataService() => _instance;

  UserDataService._internal();

  final _firestore = FirebaseFirestore.instance;

  String? email;
  bool isPremium = false;
  Map<String, dynamic>? subscription; // can be null
  String? username;

  /// Fetch user data from Firestore
  Future<void> fetchUserData(String emailAddress) async {
    final doc =
        await _firestore.collection('app-users').doc(emailAddress).get();

    if (doc.exists) {
      final data = doc.data()!;
      email = data['email'];
      isPremium = data['isPremium'] ?? false;
      subscription = data['subscription']; // might be null or a map
      username = data['username'];
    }
  }

  /// Create or update user data
  Future<void> setUserData(
    String? emailAddress, {
    required String username,
    required bool isPremium,
    Map<String, dynamic>? subscription,
  }) async {
    if (emailAddress == null) {
      return;
    }

    await _firestore.collection('app-users').doc(emailAddress).set({
      'email': emailAddress,
      'username': username,
      'isPremium': isPremium,
      'subscription': subscription,
    }, SetOptions(merge: true));
  }

  /// Update specific field
  Future<void> updateUserField(
    String? emailAddress,
    String field,
    dynamic value,
  ) async {
    if (emailAddress == null) {
      return;
    }
    await _firestore.collection('app-users').doc(emailAddress).update({
      field: value,
    });
  }

  Future<void> validateAndExpireSubscription(String emailAddress) async {
    final doc =
        await _firestore.collection('app-users').doc(emailAddress).get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final subscription = data['subscription'];

    if (subscription != null && subscription['endDate'] != null) {
      final endDate = DateTime.parse(subscription['endDate']).toUtc();
      final now = DateTime.now().toUtc();

      if (now.isAfter(endDate)) {
        // Subscription has expired — update Firestore
        await _firestore.collection('app-users').doc(emailAddress).update({
          'subscription': null,
          'isPremium': false,
        });
      }
    }
  }

  /// Delete the user document
  Future<void> deleteUser(String emailAddress) async {
    await _firestore.collection('app-users').doc(emailAddress).delete();
  }
}
