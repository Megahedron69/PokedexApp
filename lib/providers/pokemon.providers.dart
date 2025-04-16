import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:new_app/core/api/PokeApi.dart';
import 'package:new_app/core/auth/auth_service.dart';

final allDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final isDarkMode = StateProvider<bool>((ref) => true);
final pokeMonColorProvider = StateProvider<Color>((ref) => Colors.transparent);
final pokeSpeciesDataProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {},
);
final selectedFilterProvider = StateProvider<List<String>>((ref) => ["all"]);
final isLoggedIn = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;

  AuthNotifier(this.ref) : super(FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user != null;
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    state = false;
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});
