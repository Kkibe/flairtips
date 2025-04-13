// lib/utils/colors.dart
import 'package:flutter/material.dart';

// Define color constants
const Color greenColor = Color(0xFF46A56C);

// Light Theme Colors
const Color kLightBackground = Color(0xFFFFFFFF);
const Color kLightPrimary = Colors.purpleAccent;
const Color kLightAccent = Color(0xFFFFC107);
const Color kLightSurface = Color(0xFFF5F5F5);
const Color kLightText = Color(0xFF18181B);

// Dark Theme Colors
const Color kDarkBackground = Color(0xFF121212);
const Color kDarkPrimary = Colors.purpleAccent;
const Color kDarkAccent = Colors.purpleAccent;
const Color kDarkSurface = Color(0xFF1C1B20);
const Color kDarkText = Colors.white;
const Color white6Percent = Color(0x0FFFFFFF);

// Define Light Theme Color Scheme
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kLightPrimary,
  secondary: kLightAccent,
  surface: kLightSurface,
  onPrimary: Colors.white,
  onSecondary: kLightBackground,
  onSurface: kLightText,
  error: Colors.red,
  onError: Colors.white,
);

// Define Dark Theme Color Scheme
final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: kDarkPrimary,
  secondary: kDarkAccent,
  surface: kDarkSurface,
  onPrimary: Colors.white,
  onSecondary: white6Percent,
  onSurface: kDarkText,
  error: Colors.redAccent,
  onError: Colors.white,
);
