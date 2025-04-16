import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: Platform.isIOS ? dotenv.env['IOS_CLIENTID'] : null,
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google sign-in cancelled by user.");
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      print("Firebase sign-in successful");
      return userCredential;
    } catch (e) {
      print("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Failed to sign out: $e");
    }
  }

  Future<UserCredential?> signInOrSignUp(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          return await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (signUpError) {
          print('Sign-up error: ${signUpError.message}');
          return null;
        }
      } else {
        print('Sign-in error: ${e.message}');
        return null;
      }
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final providers = user.providerData.map((e) => e.providerId);
      if (providers.contains('google.com')) {
        await GoogleSignIn().signOut();
      }
    }
    await FirebaseAuth.instance.signOut();
  }
}

class FingerprintAuthService {
  final _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  Future<UserCredential?> authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        print('Signed in anonymously');
        return userCredential;
      }
      return null;
    } catch (e) {
      print("Biometric auth error: $e");
      return null;
    }
  }
}
