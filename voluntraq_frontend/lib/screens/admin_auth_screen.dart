import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart';
import 'admin_dashboard_screen.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ngoNameController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        final result = await AuthService.login(_emailController.text, _passwordController.text);
        if (mounted) {
          final role = await AuthService.getUserRole(result.user!.uid);
          await SessionManager.saveSession(result.user!.uid, role);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
            (route) => false,
          );
        }
      } else {
        final result = await AuthService.register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          dob: 'N/A', // Admin DOB not critical
          role: 'admin',
          ngoName: _ngoNameController.text,
        );
        if (mounted) {
          await SessionManager.saveSession(result.user!.uid, 'admin');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
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
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_center, color: Colors.white, size: 64),
                          const SizedBox(height: 24),
                          Text(
                            _isLogin ? 'NGO Admin Portal' : 'NGO Registration',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 48),
                          if (!_isLogin) ...[
                            _buildTextField(controller: _ngoNameController, label: 'NGO Name', icon: Icons.business),
                            const SizedBox(height: 20),
                            _buildTextField(controller: _nameController, label: 'Admin Name', icon: Icons.person),
                            const SizedBox(height: 20),
                          ],
                          _buildTextField(controller: _emailController, label: 'Work Email', icon: Icons.email),
                          const SizedBox(height: 20),
                          _buildTextField(controller: _passwordController, label: 'Password', icon: Icons.lock, isPassword: true),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 24),
                              ),
                              child: _isLoading ? const CircularProgressIndicator() : Text(_isLogin ? 'Sign In' : 'Register NGO'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () => setState(() => _isLogin = !_isLogin),
                            child: Text(
                              _isLogin ? 'Register a new NGO' : 'Back to Login',
                              style: const TextStyle(color: Colors.white70),
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
          Positioned(
            top: 40,
            left: 40,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
