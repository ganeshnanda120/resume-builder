import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'state/resume_provider.dart';
import 'views/home_screen.dart';

// Global providers and theme controllers
final ResumeProvider resumeProvider = ResumeProvider();
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentMode, child) {
        return MaterialApp(
          title: 'Digital Heroes Resume Builder',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          
          // Light Theme Design
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6B00),
              primary: const Color(0xFFFF6B00),
              secondary: const Color(0xFFE05E00),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF9F9FB),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1A1A1A),
              elevation: 0,
            ),
          ),

          // Dark Theme Design
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF6B00),
              primary: const Color(0xFFFF6B00),
              secondary: const Color(0xFFFF8533),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121214),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1E1E24),
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E24),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          
          home: const HomeScreen(),
        );
      },
    );
  }
}
