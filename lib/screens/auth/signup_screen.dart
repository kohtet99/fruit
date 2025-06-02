import 'package:assignment1/providers/auth_provider.dart';
import 'package:assignment1/screens/auth/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final bool _verificationSent = false; // Added to track verification status

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF58211B), Color(0xFF854442)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.user_add,
                        size: 64,
                        color: Color(0xFF58211B),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF58211B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Added verification success message
                      if (_verificationSent)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Verification email sent! Please check your inbox.',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                label: 'Email',
                                hint: 'you@example.com',
                                icon: Iconsax.user,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                label: 'Password',
                                hint: '••••••••',
                                icon: Iconsax.lock,
                                suffix: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye),
                                  onPressed: () => setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  }),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Min 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                // Disable button if verification already sent
                                onPressed: _verificationSent 
                                    ? null 
                                    : authProvider.isLoading ? null : _submit,
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        // Change button text based on state
                                        _verificationSent ? 'EMAIL SENT' : 'SIGN UP',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            
                            // Added resend verification button
                            if (_verificationSent)
                              TextButton(
                                onPressed: authProvider.isLoading 
                                    ? null 
                                    : () => _resendVerification(authProvider),
                                child: const Text("Resend verification email"),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

 void _submit() async {
  final authProvider = context.read<AuthProvider>();
  if (!_formKey.currentState!.validate()) return;
  try {
    await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!mounted) return;
    
    // Navigate to verification screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  } catch (_) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(authProvider.errorMessage ?? 'Signup failed')),
    );
  }
}

  // Added method to resend verification
  void _resendVerification(AuthProvider authProvider) async {
    try {
      await authProvider.resendVerificationEmail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}