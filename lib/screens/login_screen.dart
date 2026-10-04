import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/time_theme.dart';

class LoginScreen extends StatefulWidget {
  final Function(String email, String name) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    // Form Validation
    if (_isSignUp && name.isEmpty) {
      setState(() => _errorMessage = "Please enter your full name.");
      return;
    }

    if (email.isEmpty) {
      setState(() => _errorMessage = "Please enter your email address.");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = "Please enter a valid email address.");
      return;
    }

    if (password.isEmpty) {
      setState(() => _errorMessage = "Please enter your password.");
      return;
    }

    if (_isSignUp && password.length < 6) {
      setState(() => _errorMessage = "Password must be at least 6 characters long.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        // Sign Up Flow: Creates user in Firebase & updates display name, then signs out
        await _authService.signUpWithEmail(email, password, name);
        if (mounted) {
          setState(() {
            _isSignUp = false; // Switch view to Sign In
            _passwordController.clear();
            _successMessage = "Account created successfully! Please sign in with your email & password.";
          });
        }
      } else {
        // Sign In Flow: Authenticates strictly with Firebase
        final credential = await _authService.signInWithEmail(email, password);
        final user = credential.user;
        final loggedInEmail = user?.email ?? email;
        final loggedInName = user?.displayName ?? (name.isNotEmpty ? name : loggedInEmail.split('@').first);
        
        widget.onLoginSuccess(loggedInEmail, loggedInName);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = AuthService.getReadableErrorMessage(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleGuestLogin() {
    widget.onLoginSuccess('guest@weathernow.app', 'Guest User');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: TimeTheme.getBackgroundGradient(TimeOfDayCategory.night),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66F59E0B),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Brand Title
                  const Text(
                    'WeatherNow',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'WEATHER REIMAGINED',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF59E0B),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Auth Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xDD152033),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0x33384AD0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSignUp ? 'Create Account' : 'Welcome Back',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isSignUp
                              ? 'Register with Firebase to sync weather alerts'
                              : 'Sign in to access personalized live forecasts',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Error Message Box
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: const Color(0x33EF4444),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0x66EF4444)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFFFCA5A5), height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Success Message Box
                        if (_successMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: const Color(0x3322C55E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0x6622C55E)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF22C55E), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF86EFAC), height: 1.3),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Name Field (Only visible during Sign Up)
                        if (_isSignUp) ...[
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: const TextStyle(color: Color(0xFF64748B)),
                              prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF2D82FE)),
                              filled: true,
                              fillColor: const Color(0xFF0F172A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Email Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: const TextStyle(color: Color(0xFF64748B)),
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2D82FE)),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Color(0xFF64748B)),
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF2D82FE)),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Auth Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D82FE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Text(
                                    _isSignUp ? 'Create Account' : 'Sign In',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Toggle Mode Button
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignUp = !_isSignUp;
                                _errorMessage = null;
                                _successMessage = null;
                              });
                            },
                            child: Text(
                              _isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Sign Up",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Guest Preview Button for Viva
                  OutlinedButton.icon(
                    onPressed: _handleGuestLogin,
                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFFF59E0B)),
                    label: const Text(
                      'Continue as Guest (Instant Preview)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0x66F59E0B)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

