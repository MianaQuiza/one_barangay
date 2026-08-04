import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purokController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _purokController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        purokZone: _purokController.text.trim(),
        contactNumber: _contactController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🗺️ Placing the background outside the Scaffold keeps it full-screen and fixed
    // even when the keyboard slides up.
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/ph_map_bg.png'),
          fit: BoxFit.cover,
          opacity: 1.0,
          colorFilter: ColorFilter.mode(
            AppColors.primaryDark.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        // Making the Scaffold transparent so the background shows through
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Frosted Glass Back Button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.65),
                    shape: const CircleBorder(),
                    side: BorderSide(color: Colors.white.withOpacity(0.9), width: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Header Text
                Text(
                  'Create Account',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.navy,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join your barangay community and stay informed.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // 💳 Glassmorphism Registration Form Container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.9),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 👤 Full Name Input
                                TextFormField(
                                  controller: _nameController,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    hintText: 'Juan Dela Cruz',
                                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
                                ),
                                const SizedBox(height: 16),

                                // 📍 Purok / Zone Input
                                TextFormField(
                                  controller: _purokController,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Purok / Zone',
                                    hintText: 'e.g., Zone 4',
                                    prefixIcon: const Icon(Icons.map_outlined, color: AppColors.primary),
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
                                ),
                                const SizedBox(height: 16),

                                // 📱 Contact Number Input
                                TextFormField(
                                  controller: _contactController,
                                  keyboardType: TextInputType.phone,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Contact Number',
                                    hintText: '09XX XXX XXXX',
                                    prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
                                ),
                                const SizedBox(height: 16),

                                // 📧 Email Input
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    hintText: 'resident@barangay.gov.ph',
                                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email address' : null,
                                ),
                                const SizedBox(height: 16),

                                // 🔑 Password Input
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: theme.textTheme.bodyLarge,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: '••••••••',
                                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                                    fillColor: Colors.white.withOpacity(0.8),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                                ),
                                
                                // ⚠️ Error Banner
                                if (_error != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.danger.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.danger.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _error!,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: AppColors.danger,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 24),

                                // 🔘 Submit Button
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shadowColor: AppColors.primary.withOpacity(0.3),
                                      elevation: 4,
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Register Account',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}