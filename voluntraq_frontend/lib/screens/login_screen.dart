import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import 'volunteer_home_screen.dart';
import 'profile_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        final result = await ApiService.login(_emailController.text, _passwordController.text);
        if (mounted) {
          await SessionManager.saveSession(result['uid'], result['userData']?['role'] ?? 'volunteer');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful! Welcome Back.'), backgroundColor: Colors.green),
          );
          print('Navigating to VolunteerHomeScreen...');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VolunteerHomeScreen(userId: result['uid'])),
            (route) => false,
          );
        }
      } else {
        final result = await ApiService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _dobController.text,
        );
        if (mounted) {
          await SessionManager.saveSession(result['uid'], 'volunteer');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful! Welcome Hero.'), backgroundColor: Colors.green),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProfileSetupScreen(userId: result['uid'])),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Full Screen)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.primaryGradient,
            ),
          ),
          
          // Main Content
          Row(
            children: [
              // Left Side: Branding
              if (MediaQuery.of(context).size.width > 800)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.volunteer_activism, size: 100, color: Colors.white),
                        const SizedBox(height: 24),
                        const Text(
                          'VoluntraQ',
                          style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'AI-Powered Disaster Relief',
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Right Side: Glass Form
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          padding: const EdgeInsets.all(48),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isLogin ? 'Welcome Back' : 'Create Account',
                                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _isLogin ? 'Sign in to continue your mission' : 'Join our network of heroes',
                                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                                const SizedBox(height: 48),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      if (!_isLogin) ...[
                                        _buildTextField(
                                          controller: _nameController,
                                          label: 'Full Name',
                                          icon: Icons.person_outline,
                                          hint: 'John Doe',
                                          validator: (v) => v!.isEmpty ? 'Enter name' : null,
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                      _buildTextField(
                                        controller: _emailController,
                                        label: 'Email Address',
                                        icon: Icons.email_outlined,
                                        hint: 'john@example.com',
                                        validator: (v) => v!.isEmpty ? 'Enter email' : null,
                                      ),
                                      const SizedBox(height: 24),
                                      if (!_isLogin) ...[
                                        _buildTextField(
                                          controller: _dobController,
                                          label: 'Date of Birth',
                                          icon: Icons.calendar_today_outlined,
                                          hint: 'DD/MM/YYYY',
                                          validator: (v) => v!.isEmpty ? 'Enter DOB' : null,
                                        ),
                                        const SizedBox(height: 24),
                                      ],
                                      _buildTextField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        icon: Icons.lock_outline,
                                        isPassword: true,
                                        hint: '••••••••',
                                        validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                                      ),
                                      const SizedBox(height: 48),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _handleSubmit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: AppColors.primary,
                                            padding: const EdgeInsets.symmetric(vertical: 24),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            elevation: 0,
                                          ),
                                          child: _isLoading 
                                            ? const CircularProgressIndicator()
                                            : Text(
                                                _isLogin ? 'Sign In' : 'Register',
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _isLogin ? "Don't have an account? " : "Already have an account? ",
                                            style: const TextStyle(color: Colors.white70),
                                          ),
                                          TextButton(
                                            onPressed: _toggleMode,
                                            child: Text(
                                              _isLogin ? 'Register Now' : 'Sign In',
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
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
              ),
            ],
          ),
          
          // Back Button
          Positioned(
            top: 40,
            left: 40,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(icon, color: Colors.white70, size: 22),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white70),
            ),
            errorStyle: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
