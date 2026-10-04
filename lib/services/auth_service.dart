import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class AuthService {
  static bool _firebaseInitialized = false;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _firebaseInitialized = true;
    } catch (_) {
      _firebaseInitialized = false;
    }
  }

  static bool get isInitialized => _firebaseInitialized;

  User? get currentUser {
    if (!_firebaseInitialized) return null;
    return FirebaseAuth.instance.currentUser;
  }

  Stream<User?> get authStateChanges {
    if (!_firebaseInitialized) return const Stream.empty();
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    if (!_firebaseInitialized) {
      await initialize();
    }
    if (!_firebaseInitialized) {
      throw Exception("Firebase is not initialized. Please check your internet connection.");
    }
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail(String email, String password, String name) async {
    if (!_firebaseInitialized) {
      await initialize();
    }
    if (!_firebaseInitialized) {
      throw Exception("Firebase is not initialized. Please check your internet connection.");
    }

    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update display name on Firebase Auth user profile
    if (credential.user != null) {
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
    }

    // Sign out immediately so user is required to sign in after sign up
    await FirebaseAuth.instance.signOut();

    return credential;
  }

  Future<void> signOut() async {
    if (_firebaseInitialized) {
      await FirebaseAuth.instance.signOut();
    }
  }

  String get currentUserEmail {
    final user = currentUser;
    if (user != null && user.email != null && user.email!.isNotEmpty) {
      return user.email!;
    }
    return '';
  }

  String get currentUserName {
    final user = currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    return '';
  }

  static String getReadableErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address format is invalid.';
        case 'user-not-found':
          return 'No account found with this email. Please sign up first.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Incorrect email or password. Please verify your credentials.';
        case 'email-already-in-use':
          return 'This email is already registered. Please sign in instead.';
        case 'weak-password':
          return 'Password is too weak. Please use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many failed login attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'Email/password sign in is not enabled in Firebase Console.';
        default:
          return error.message ?? 'Authentication failed (${error.code}).';
      }
    }
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }
}

