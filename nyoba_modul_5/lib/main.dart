import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nyoba_modul_5/firebase_options.dart';
// import 'package:nyoba_modul_5/screens/splash_screen.dart';
import 'package:nyoba_modul_5/screens/auth/login_screen.dart';
import 'package:nyoba_modul_5/screens/auth/register_screen.dart';
import 'package:nyoba_modul_5/screens/auth/forgot_password_screen.dart';
import 'package:nyoba_modul_5/screens/auth/welcome_screen.dart'; // nanti dibuat
import 'package:nyoba_modul_5/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password':
            (context) => const ForgotPasswordScreen(), // Buat nanti
        '/home': (context) => const HomeScreen(),
      },
      // home: Scaffold(body: Center(child: Text("Hello World"))),
    );
  }
}
