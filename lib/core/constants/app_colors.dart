import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors
  static const Color primary = Color(0xFF1B3B28); // Dark Green from card/buttons
  static const Color primaryLight = Color(0xFFDFF7E2); // Pastel Green background
  static const Color accent = Color(0xFFC1F0C8); // Lighter accent

  // Text
  static const Color textPrimary = Color(0xFF1B3B28);
  static const Color textSecondary = Color(0xFF625B71);

  // Income/Expense
  static const Color income = Color(0xFF1B3B28); // Using dark green for positive/income in this design usually, or keep standard green
  static const Color incomeBackground = Color(0xFFDFF7E2);
  
  static const Color expense = Color(0xFFF44336); // Keep red for alerts but might style differently
  static const Color expenseBackground = Color(0xFFFFE5E5);

  // Backgrounds
  static const Color lightBackground = Color(0xFFFFFFFF); // Pure white
  static const Color surface = Color(0xFFF5F5F5); // Light grey for areas
}
