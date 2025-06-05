import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment1/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _resetSent = false;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final loggedInEmail = authProvider.user?.email;
    if (loggedInEmail != null && loggedInEmail.isNotEmpty) {
      _emailController.text = loggedInEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.sendPasswordResetEmail(_emailController.text.trim());

    if (authProvider.errorMessage == null) {
      setState(() => _resetSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoggedIn = authProvider.user?.email != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF58211B),
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child:
            _resetSent
                ? _buildSuccessState()
                : _buildResetForm(authProvider, isLoggedIn),
      ),
    );
  }

  Widget _buildResetForm(AuthProvider authProvider, bool isLoggedIn) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          const SizedBox(height: 30),
          const Text(
            'Reset your password',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF58211B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Enter your email address and we will send you instructions to reset your password.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoggedIn,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          if (authProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                authProvider.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: authProvider.isLoading ? null : _submitResetRequest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color(0xFF58211B),
            ),
            child:
                authProvider.isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Send',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 16, color: Color(0xFF58211B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.mark_email_read_outlined,
          size: 80,
          color: Color(0xFF58211B),
        ),
        const SizedBox(height: 32),
        const Text(
          'Check your email',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF58211B),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'We sent password reset instructions to\n${_emailController.text}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFF58211B),
          ),
          child: const Text(
            'Return to Login',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => setState(() => _resetSent = false),
          child: const Text(
            'Resend Instructions',
            style: TextStyle(fontSize: 16, color: Color(0xFF58211B)),
          ),
        ),
      ],
    );
  }
}
