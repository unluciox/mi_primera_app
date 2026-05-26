import 'dart:async';
import 'package:flutter/material.dart';
import 'sprite_carousel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _titleOpacity;
  late Animation<double> _promptOpacity;

  int _bgIndex = 0;
  Timer? _bgTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Background cycling timer (every 5 seconds)
    _bgTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _bgIndex = (_bgIndex + 1) % 3;
        });
      }
    });

    // Logo fades in and scales up between 0.0 and 0.4 of the animation
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Title fades in between 0.4 and 0.7
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // Prompt fades in and blinks between 0.7 and 1.0
    _promptOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _bgTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainApp() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SpriteCarousel(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures the whole screen is tapable
        onTap: _navigateToMainApp,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cycling Background Images
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                'assets/images/fondo${_bgIndex + 1}.jpg',
                key: ValueKey<int>(_bgIndex),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            
            // Light semi-transparent overlay to ensure text is always readable
            Container(
              color: Colors.white.withOpacity(0.85),
            ),
            
            // Animated Foreground
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      
                      // Symbol Logo
                      Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Image.asset(
                            'assets/images/simboloo.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback icon in case image is missing
                              return const Icon(
                                Icons.restaurant,
                                size: 150,
                                color: Colors.deepOrange,
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Main Title
                      Opacity(
                        opacity: _titleOpacity.value,
                        child: const Text(
                          "¿Qué cocino hoy?",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      
                      const Spacer(flex: 2),
                      
                      // Touch to start prompt
                      Opacity(
                        opacity: _promptOpacity.value,
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 50.0),
                          child: Text(
                            "Toca cualquier parte para comenzar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
