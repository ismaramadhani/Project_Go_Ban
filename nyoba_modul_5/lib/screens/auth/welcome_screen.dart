import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// Tambahkan import untuk layar login dan register
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E0),
      body: Stack(
        children: [
          // Background elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0x338DECB4), // .withOpacity(0.2)
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
                color: const Color(0x3341B06E), // .withOpacity(0.2)
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animasi
                  Container(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/icon/lokasi.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Judul
                  const Text(
                    "GOBAN",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF141E46),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Subjudul
                  const Text(
                    "Darurat ban bocor? Tenang, Go-Ban solusinya!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF141E46),
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF41B06E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Tombol Register
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Color(0xFF41B06E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF41B06E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Tombol Onboarding
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/onboarding');
                    },
                    child: const Text(
                      "Lihat Onboarding",
                      style: TextStyle(
                        color: Color(0xFF41B06E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(color: Colors.white),
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
          // Welcome content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie animation with subtle blur background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  width: 200,
                  height: 200,
                  
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Lottie.asset(
                        'assets/icon/lokasi.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  
                ),
                const SizedBox(height: 20),
                const Text(
                  "GOBAN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                    fontFamily: 'HelloBotuna',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Darurat ban bocor? Tenang, Go-Ban solusinya!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Login button with subtle blur background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                 
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                ),
                const SizedBox(height: 10),
                // Register button with subtle blur background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Color(0xFF4A90E2)),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Color(0xFF4A90E2)),
                        ),
                      ),
                    ),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}