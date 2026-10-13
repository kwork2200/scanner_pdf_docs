import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase service for managing authentication, database, storage, and analytics
class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseAnalytics get analytics => _analytics;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in anonymously
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Log analytics event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Upload file to Firebase Storage
  Future<String> uploadFile({
    required String path,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final ref = _storage.ref().child(path).child(fileName);
    await ref.putData(fileBytes as Uint8List);
    return await ref.getDownloadURL();
  }

  // Delete file from Firebase Storage
  Future<void> deleteFile(String filePath) async {
    final ref = _storage.ref().child(filePath);
    await ref.delete();
  }
}
