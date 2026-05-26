import 'package:flutter/material.dart';
import 'sprites/revolver_animator.dart';
import 'sprites/submachine_animator.dart';
import 'screens/sprite_carousel.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}