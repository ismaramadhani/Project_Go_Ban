import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:nyoba_modul_5/screens/auth/profile_form_screen.dart';
import 'package:nyoba_modul_5/screens/auth/thank_you_screen.dart';
// import 'package:nyoba_modul_5/services/notification_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords don't match")),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  static const String defaultPhotoUrl =
      'https://i.pinimg.com/736x/d9/d6/60/d9d660923c381d94f3f3ab12a0a76fc9.jpg';

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final auth = FirebaseAuth.instance;
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Create initial profile document
        await FirebaseFirestore.instance
            .collection('Profile')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'profileCompleted': false,
        });

        if (!mounted) return;
        // Navigate to profile form
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ThankYouScreen()),
        );
        // await NotificationService().showNotification(
        //   'Registrasi Berhasil',
        //   'Akun Anda berhasil dibuat!',
        // );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        String photoUrl = _photoUrlController.text.trim();
        if (photoUrl.isEmpty || !_isValidUrl(photoUrl)) {
          photoUrl = defaultPhotoUrl;
        }

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
              "uid": userCredential.user!.uid,
              "email": _emailController.text.trim(),
              "username": _nameController.text.trim(),
              "photoUrl": photoUrl,
              "createdAt": FieldValue.serverTimestamp(),
            });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful")),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration failed")),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }

        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E0),
      body: Stack(
        children: [
          // Background elements - FIXED DEPRECATED withOpacity
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0x3341B06E), // Equivalent to .withOpacity(0.2)
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0x338DECB4), // Equivalent to .withOpacity(0.3)
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Header
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141E46),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Let's create you an account",
                      style: TextStyle(
                        color: Color(0xFF141E46),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Social login buttons - FIXED BUTTON SYNTAX
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Color(0xFF8DECB4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.facebook, color: Colors.blue),
                        label: const Text(
                          "Sign In with Facebook",
                          style: TextStyle(
                            color: Color(0xFF141E46),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Color(0xFF8DECB4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Text(
                          "G",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                        label: const Text(
                          "Sign In with Google",
                          style: TextStyle(
                            color: Color(0xFF141E46),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Divider
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Color(0xFF8DECB4))),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              color: Color(0xFF141E46),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Color(0xFF8DECB4))),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Registration form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          
                          // Register button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF41B06E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Color(0xFF141E46),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF41B06E),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Loading indicator - FIXED DEPRECATED withOpacity
          if (_isLoading)
            Container(
              color: const Color(0x80000000), // Equivalent to .withOpacity(0.5)
              child: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
  void initState() {
    super.initState();
    _photoUrlController.addListener(_updatePhotoPreview);
  }

  void _updatePhotoPreview() {
    setState(() {}); // Memicu pembaruan tampilan ketika URL berubah
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _photoUrlController.removeListener(_updatePhotoPreview);
    _photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background blur
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const SizedBox.expand(),
            ),
          ),
          // Blue wave background
          const Positioned(
            left: -120,
            top: -120,
            child: SizedBox(
              width: 300,
              height: 300,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4A90E2), Color(0xFF7BBDF5)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(300),
                  ),
                ),
              ),
            ),
          ),
          // Register container
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form container
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A90E2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Sign up to get started",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Photo preview section
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      color: Colors.grey[200],
                                    ),
                                    child: Image.network(
                                      _photoUrlController.text.isEmpty
                                          ? defaultPhotoUrl
                                          : _photoUrlController.text,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.image,
                                          size: 60,
                                          color: Colors.grey,
                                        );
                                      },
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    hintText: "Your Name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.isEmpty
                                              ? "Name is required"
                                              : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || !value.contains('@')
                                              ? "Enter a valid email"
                                              : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value == null || value.length < 6
                                              ? "Minimum 6 characters"
                                              : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          value != _passwordController.text
                                              ? "Passwords don't match"
                                              : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _photoUrlController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.image_outlined,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    hintText: "Photo URL (optional)",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4A90E2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child:
                                        _isLoading
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Text(
                                              "Register",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Already have an account? Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFF4A90E2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Loading indicator
          if (_isLoading) ...[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const SizedBox.expand(),
            ),
          ],
        ],
      ),
    );
  }
}
