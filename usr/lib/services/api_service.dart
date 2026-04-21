import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final _supabase = Supabase.instance.client;

  /// Analyzes the artwork using Gemini 3 Pro (Gemini 1.5 Pro) via Supabase Edge Function
  Future<Map<String, dynamic>> analyzeArtwork(String base64Image) async {
    try {
      final response = await _supabase.functions.invoke(
        'analyze_art',
        body: {'image': base64Image},
      );
      
      if (response.status == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to analyze artwork: ${response.data}');
      }
    } catch (e) {
      throw Exception('Analysis error: $e');
    }
  }

  /// Generates a stylized local innovation image using an Edge Function
  Future<String> generateInnovation(String analysisText) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate_innovation',
        body: {'prompt': analysisText},
      );
      
      if (response.status == 200) {
        return response.data['imageUrl'] as String;
      } else {
        throw Exception('Failed to generate innovation: ${response.data}');
      }
    } catch (e) {
      throw Exception('Generation error: $e');
    }
  }
}
