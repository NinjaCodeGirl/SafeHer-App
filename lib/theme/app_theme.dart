import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Main Lovable App Background
  static const Color darkBg = Color(0xFF0F0811);
  static const Color darkBgSecondary = Color(0xFF130919);
  static const Color darkBgRadial = Color(0xFF261233);
  static const Color activeEmergencyBg = Color(0xFF14070B);
  
  // Glass Card Backgrounds & Borders
  static const Color glassCard = Color(0x0CFFFFFF); // bg-white/[0.04]
  static const Color glassCardHover = Color(0x14FFFFFF); // bg-white/[0.08]
  static const Color glassBorder = Color(0x14FFFFFF); // border-white/[0.08]
  static const Color glassBorderLavender = Color(0x26E1D4F9); // border-lavender/15
  
  // Lavender Accent System
  static const Color lavender = Color(0xFFE1D4F9);
  static const Color lavenderMuted = Color(0xFFC3B1E1);
  static const Color lavenderBg = Color(0x26E1D4F9); // bg-lavender/15
  static const Color lavenderBorder = Color(0x66E1D4F9); // border-lavender/40

  // Emergency SOS Red Gradient & Accents
  static const Color emergencyRedStart = Color(0xFFFF4D6D);
  static const Color emergencyRedEnd = Color(0xFFE11D48);
  static const Color emergencyRedDark = Color(0xFF800F2F);
  static const Color emergencyRedGlow = Color(0x40FF3366); // rgba(255, 51, 102, 0.25)
  static const Color emergencyBadgeBg = Color(0x1AFF3366);
  
  // Mint Green Status Accents
  static const Color mintGreen = Color(0xFFA7F3D0);
  static const Color mintGreenBg = Color(0x26A7F3D0);
  static const Color statusGreenDot = Color(0xFF34D399);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA19FA8);
  static const Color textMuted = Color(0xFF718096);

  // Quick Action Tile Icon Circles
  static const Color fakeCallPurpleBg = Color(0x269C27B0);
  static const Color fakeCallPurple = Color(0xFFD8B4FE);
  
  static const Color safetyTimerTealBg = Color(0x26009688);
  static const Color safetyTimerTeal = Color(0xFF99F6E4);
  
  static const Color safeZonesBlueBg = Color(0x262196F3);
  static const Color safeZonesBlue = Color(0xFF93C5FD);
  
  static const Color nearbyHelpCoralBg = Color(0x26FF5722);
  static const Color nearbyHelpCoral = Color(0xFFFECDD3);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emergencyRedEnd,
        secondary: AppColors.lavender,
        surface: AppColors.darkBgSecondary,
        error: AppColors.emergencyRedStart,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.glassCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder, width: 1.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
