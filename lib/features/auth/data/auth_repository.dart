import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/family_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In with Email and Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Up with Email and Password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign In with Google
  Future<UserCredential?> signInWithGoogle() async {
    // TODO: Implement Google Sign In
    throw UnimplementedError('Google Sign In not implemented yet');
  }

  // Sign In with Phone
  Future<void> signInWithPhone(String phoneNumber) async {
    // TODO: Implement Phone Sign In
    throw UnimplementedError('Phone Sign In not implemented yet');
  }

  // Create User Profile
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        email: email,
        name: name,
        role: 'guest',
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(uid).set(userModel.toJson());
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Create Family
  Future<FamilyModel> createFamily({
    required String adminId,
    required String familyName,
  }) async {
    try {
      final inviteCode = _generateInviteCode();
      final familyModel = FamilyModel(
        id: '',
        familyName: familyName,
        adminId: adminId,
        members: [adminId],
        inviteCode: inviteCode,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('families')
          .add(familyModel.toFirestore());
      
      // Update user role
      await _firestore.collection('users').doc(adminId).update({
        'role': 'admin',
        'familyId': docRef.id,
      });

      return FamilyModel(
        id: docRef.id,
        familyName: familyModel.familyName,
        adminId: familyModel.adminId,
        members: familyModel.members,
        inviteCode: familyModel.inviteCode,
        createdAt: familyModel.createdAt,
      );
    } catch (e) {
      throw Exception('Failed to create family: $e');
    }
  }

  // Join Family
  Future<void> joinFamily({
    required String userId,
    required String inviteCode,
  }) async {
    try {
      final familyQuery = await _firestore
          .collection('families')
          .where('inviteCode', isEqualTo: inviteCode)
          .limit(1)
          .get();

      if (familyQuery.docs.isEmpty) {
        throw Exception('Invalid invite code');
      }

      final familyDoc = familyQuery.docs.first;
      final familyId = familyDoc.id;

      // Add user to family members
      await familyDoc.reference.update({
        'members': FieldValue.arrayUnion([userId]),
      });

      // Update user profile
      await _firestore.collection('users').doc(userId).update({
        'role': 'member',
        'familyId': familyId,
      });
    } catch (e) {
      throw Exception('Failed to join family: $e');
    }
  }

  // Get Current User
  UserModel? getCurrentUserModel() {
    final user = _auth.currentUser;
    if (user == null) return null;

    // This is a simplified version. In production, fetch from Firestore
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      role: 'guest',
      createdAt: DateTime.now(),
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current Auth User
  User? getCurrentAuthUser() {
    return _auth.currentUser;
  }

  // Helper: Generate Invite Code
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final code = List.generate(6, (index) {
      final charIndex = (random + index) % chars.length;
      return chars[charIndex];
    }).join();
    return code;
  }

  // Helper: Handle Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

