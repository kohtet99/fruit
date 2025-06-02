
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _user = _auth.currentUser;

    _auth.authStateChanges().listen((firebaseUser) {
      if (_user != firebaseUser) {
        _user = firebaseUser;
      }
      _isInitialized = true;
      _errorMessage = null;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _user = userCredential.user;
      await _sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      throw Exception(_errorMessage);
    } catch (e) {
      _errorMessage = "SignUp Failed: ${e.toString()}";
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _sendEmailVerification() async {
    if (_user != null && !_user!.emailVerified) {
      await _user!.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    if (_user != null) {
      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  void checkVerificationStatus() async {
  if (_user != null && !_user!.emailVerified) {
    await reloadUser();
    if (!_user!.emailVerified) {
      _errorMessage = 'Please verify your email to continue';
      notifyListeners();
    }
  }
}


  Future<void> resendVerificationEmail() async {
    try {
      _isLoading = true;
      notifyListeners();
      if (_user != null && !_user!.emailVerified) {
        await _user!.sendEmailVerification();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _user = userCredential.user;

      if (_user != null && !_user!.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email address'
        );
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e);
      throw Exception(_errorMessage);
    } catch (e) {
      _errorMessage = "SignIn Failed: ${e.toString()}";
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.signOut();
      await Hive.box('wishlist').clear();
       _user = null;
    } catch (e) {
      _errorMessage = "SignOut Failed: ${e.toString()}";
      throw Exception(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'email-not-verified':
        return 'Please verify your email address first. Check your inbox.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
