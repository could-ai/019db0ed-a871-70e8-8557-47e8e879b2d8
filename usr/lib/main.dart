import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase - Replace with your actual credentials when connected
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://placeholder.supabase.co'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'placeholder_anon_key'),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<TtsService>(create: (_) => TtsService()),
      ],
      child: const ConstantineArtApp(),
    ),
  );
}

class ConstantineArtApp extends StatelessWidget {
  const ConstantineArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constantine Art Analysis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4A2F), // Earthy, historical tone
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.loraTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
