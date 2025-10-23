// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';
import 'pages/introduction_animation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('hasSeenIntro');
  
  final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  
  runApp(MyApp(hasSeenIntro: hasSeenIntro));
}

class MyApp extends StatelessWidget {
  final bool hasSeenIntro;
  
  const MyApp({super.key, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cornerstone Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      // Start with intro screen if not seen, otherwise login
      home: hasSeenIntro ? const LoginPage() : const IntroWrapper(),
    );
  }
}

class IntroWrapper extends StatelessWidget {
  const IntroWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionAnimationScreen(
      onComplete: () async {
        // Save that user has seen intro
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasSeenIntro', true);
        
        // Navigate to login with fade animation
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
    );
  }
}