import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/auth/auth_service.dart';
import 'package:new_app/core/utils/ToastHelper.dart';
import 'package:new_app/providers/pokemon.providers.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _hidePass = true;

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      final email = _emailController.text.trim();
      final password = _passController.text.trim();

      final user = await AuthService().signInOrSignUp(email, password);

      if (user != null) {
        showToast(
          context: context,
          toastType: ToastificationType.success,
          title: "It’s a Wild Sign-In!",
          description: "Gotta catch em all",
        );
      } else {
        showToast(
          context: context,
          toastType: ToastificationType.error,
          title: "Oops! Something went wrong",
          description: "We couldn't sign you in. Try again.",
        );
      }
    }
  }

  String? validateMyEmailInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? validateMyPassInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    final passRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passRegex.hasMatch(value.trim())) {
      return "Minimum 8 chars, one letter & one number";
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/pokemon-png.png',
                  width: size.width * 0.6,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),
                const Text(
                  "Welcome to Pokédex",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Please sign in to continue",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 32),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: validateMyEmailInput,
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: _hidePass,
                  validator: validateMyPassInput,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                      icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B4CCA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(thickness: 1.2),
                const SizedBox(height: 16),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Image.network(
                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                      height: 32,
                      width: 32,
                      fit: BoxFit.contain,
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      final account = await AuthService().signInWithGoogle();
                      if (account != null) {
                        showToast(
                          context: context,
                          toastType: ToastificationType.success,
                          title: "It’s a Wild Sign-In!",
                          description: "Gotta catch em all",
                        );
                      } else {
                        showToast(
                          context: context,
                          toastType: ToastificationType.error,
                          title: "Oops! Something went wrong",
                          description: "We couldn't sign you in. Try again.",
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Biometric Auth Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: const Text(
                      "Use Fingerprint",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      final credential =
                          await FingerprintAuthService()
                              .authenticateWithBiometrics();

                      if (credential != null) {
                        showToast(
                          context: context,
                          toastType: ToastificationType.success,
                          title: "Biometric login",
                          description: "You're in, Trainer!",
                        );
                      } else {
                        showToast(
                          context: context,
                          toastType: ToastificationType.error,
                          title: "Biometric failed",
                          description: "Try again or use another method.",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0074e4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
