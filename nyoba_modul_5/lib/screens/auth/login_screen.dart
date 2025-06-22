
// Remove unused imports
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nyoba_modul_5/screens/auth/profile_form_screen.dart';
import 'package:nyoba_modul_5/screens/home/home_screen.dart';
// import 'package:nyoba_modul_5/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Tambahkan ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nyoba_modul_5/screens/auth/welcome_screen.dart';
import 'package:nyoba_modul_5/screens/home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  void _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedEmail = prefs.getString('remembered_email');
    if (rememberedEmail != null) {
      setState(() {
        _emailController.text = rememberedEmail;
        _rememberMe = true;
      });
    }
  }
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Jika remember me dicentang, simpan email
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString(
            'remembered_email',
            _emailController.text.trim(),
          );
        } else {
          await prefs.remove('remembered_email');
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );

        // await NotificationService().showNotification(
        //   'Login Berhasil',
        //   'Selamat datang kembali!',
        // );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

      } on FirebaseAuthException catch (e) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
      } finally {

        if (mounted) {
          setState(() => _isLoading = false);
        }

        setState(() => _isLoading = false);

      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {

      setState(() => _isLoading = true);

      setState(() => _isLoading = true); // Tambahkan ini
      final googleSignIn = GoogleSignIn(
        clientId:
            "475941342310-0srr90qk2d1f4jrts4ddfi90lv6d4psk.apps.googleusercontent.com",
      );
      GoogleSignInAccount? currentUser = googleSignIn.currentUser;

      if (currentUser == null) {
        currentUser = await googleSignIn.signIn();
        if (currentUser == null) return;
      }

      final GoogleSignInAuthentication googleAuth =
          await currentUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await googleSignIn.disconnect();

      if (!mounted) return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Google login successful"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
      );
      // await NotificationService().showNotification(
      //   'Login Berhasil',
      //   'Selamat datang kembali!',
      // );
    } on Exception catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on Exception catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google login failed: $e")));
    } finally {

      if (mounted) {
        setState(() => _isLoading = false);
      }

      setState(() => _isLoading = false); // Tambahkan ini

    }
  }

  Future<void> _loginWithFacebook() async {
    try {
      setState(() => _isLoading = true);
      
      // Gunakan login default untuk Flutter
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        // Dapatkan access token
        final AccessToken accessToken = result.accessToken!;
        
        // Buat credential
        final OAuthCredential facebookAuthCredential = 
            FacebookAuthProvider.credential(accessToken.tokenString);
        
        // Login ke Firebase
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Facebook login successful")),
        );
        
        // Lanjutkan ke profil
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
        );
        // await NotificationService().showNotification(
        //   'Login Berhasil',
        //   'Selamat datang kembali!',
        // );
      } else {
        if (!mounted) return;
      setState(() => _isLoading = true); // Tambahkan ini
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        await FirebaseAuth.instance.signInWithCredential(
          facebookAuthCredential,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Facebook login successful"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Facebook login failed: ${result.status}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Facebook login error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Facebook login error: $e")));
    } finally {
      setState(() => _isLoading = false); // Tambahkan ini
    }
  }

  // Logic for forgot password
  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent! Please check your email."),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Failed to send password reset email"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null && mounted) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const ProfileFormScreen()),
    //     );
    //   }
    // });

    // Check if the user is already logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // User is not logged in, stay on the login screen
      }
    });
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
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(
                  0x338DECB4,
                ), // Equivalent to .withOpacity(0.3)
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(
                  0x3341B06E,
                ), // Equivalent to .withOpacity(0.2)
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
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.exit_to_app,
                    //     color: Color(0xFF141E46),
                    //   ),
                    //   onPressed: () {
                    //     // Kembali ke welcome screen
                    //     Navigator.pushReplacementNamed(context, '/welcome');
                    //   },
                    // ),
                    // Di dalam Scaffold di LoginScreen

                    // Logo/Header
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141E46),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Let's get you in",
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
                        onPressed: _loginWithFacebook,
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
                        onPressed: _loginWithGoogle,
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
                            fontSize: 18,
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

                    // Email form
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
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
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
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF41B06E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        "SIGN IN",
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          activeColor: const Color(0xFF41B06E),
                        ),
                        const Text(
                          "Remember me",
                          style: TextStyle(
                            color: Color(0xFF141E46),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),

                    // Forgot password & Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF41B06E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Color(0xFF141E46),
                                fontFamily: 'Poppins',
                              ),
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
          // Login container
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen(),
                                  ), // Kembali ke WelcomeScreen
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Sign In",
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
                                  "Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A90E2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Sign in to continue",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    hintText: "akun.anda@gmail.com",
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
                                    hintText: "••••••••",
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
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value!;
                                        });
                                      },
                                      activeColor: const Color(0xFF4A90E2),
                                    ),
                                    const Text("Remember me"),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: _forgotPassword,
                                      child: const Text(
                                        "Lupa Password?",
                                        style: TextStyle(
                                          color: Color(0xFF4A90E2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4A90E2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Sign in",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "Or",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton(
                                          onPressed: _loginWithFacebook,
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.facebook,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: OutlinedButton(
                                          onPressed: _loginWithGoogle,
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.g_mobiledata,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Don't have an account? Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                "Sign Up",
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
            Center(
              child: SizedBox(
                width: 500,
                height: 500,
                child: Lottie.asset(
                  'assets/icon/loading.json', // Pastikan path ini benar
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
