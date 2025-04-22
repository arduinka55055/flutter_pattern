import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, AppRouter.calendarList),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Empty expanded space at top
              const Expanded(flex: 1, child: SizedBox.shrink()),

              // Main Content
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.blueAccent, Colors.lightBlue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              'The Scheduler',
                              style: TextStyle(
                                fontSize: screenSize.shortestSide * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      // Image
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                          maxHeight: 200,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'images/cat.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: EdgeInsets.all(screenSize.height * 0.02),
                child: const Text(
                  '© 2025 Vitiaz Denys (SudoHub Team). All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),

              // Empty expanded space at the bottom
              const Expanded(flex: 1, child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
