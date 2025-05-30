// lib/utils/colors.dart
import 'package:flutter/material.dart';

// Light Theme Colors
const Color lightBackground = Color(0xFFFFFFFF);
const Color lightPrimary = Color.fromRGBO(21, 128, 61, 1.0);
const Color lightAccent = Color(0xFF4CD964);
const Color lightSurface = Color(0xFFF5F5F5);
const Color lightText = Color(0xFF18181B);

// Dark Theme Colors
const Color darkBackground = Color(0xFF121212);
const Color darkPrimary = Color.fromRGBO(20, 83, 45, 1.0);
const Color darkAccent = Color(0xFF4CD964);
const Color darkSurface = Color(0xFF1C1B20);
const Color darkText = Colors.white;
const Color white6Percent = Color(0x0FFFFFFF);

// Define Light Theme Color Scheme
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: lightPrimary,
  secondary: lightAccent,
  surface: lightSurface,
  onPrimary: Colors.white,
  onSecondary: lightBackground,
  onSurface: lightText,
  error: Colors.red,
  onError: Colors.white,
);

// Define Dark Theme Color Scheme
final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: darkPrimary,
  secondary: darkAccent,
  surface: darkSurface,
  onPrimary: Colors.white,
  onSecondary: white6Percent,
  onSurface: darkText,
  error: Colors.redAccent,
  onError: Colors.white,
);
