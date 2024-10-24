import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task/core/helper/storage_helper.dart';
import 'package:task/features/login/presentaion/views/login_view.dart';
import 'package:task/features/profile/presentaion/views/profile_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Set animation curve
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start animation
    _controller.forward();

    // Check token and navigate after delay
    Timer(const Duration(seconds: 4), () {
      _checkAccessToken(); // Call method to check token and navigate
    });
  }

  Future<void> _checkAccessToken() async {
    // Read the access token from storage
    String accessToken = await StorageHelper.instance.read('accessToken') ?? '';

    // Navigate to ProfileView if token exists, otherwise to LoginView
    if (accessToken.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const ProfileView()), // Token found, go to profile
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const LoginView()), // No token, go to login
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2), // Baby blue background color
      body: Center(
        child: ScaleTransition(
          scale: _animation, // Apply animation to logo
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons
                      .water_drop, // Example icon, replace with your app's logo
                  size: 50,
                  color: Color(0xFF4A90E2),
                ),
              ),
              SizedBox(height: 20),

              // App name or tagline
              Text(
                'MyApp', // Replace with your app name
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10),

              // Tagline or description (optional)
              Text(
                'Delivering Excellence', // Replace with your app tagline
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
