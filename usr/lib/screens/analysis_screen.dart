import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';
import 'innovation_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final File imageFile;
  final String base64Image;

  const AnalysisScreen({
    super.key,
    required this.imageFile,
    required this.base64Image,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isAnalyzing = true;
  String _analysisReport = '';
  String _errorMessage = '';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _performAnalysis();
  }

  @override
  void dispose() {
    // Ensure TTS stops when leaving screen
    final ttsService = Provider.of<TtsService>(context, listen: false);
    ttsService.stop();
    super.dispose();
  }

  Future<void> _performAnalysis() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.analyzeArtwork(widget.base64Image);
      
      setState(() {
        _isAnalyzing = false;
        _analysisReport = result['report'] ?? 'No report generated.';
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _togglePlayback() async {
    final ttsService = Provider.of<TtsService>(context, listen: false);
    if (_isPlaying) {
      await ttsService.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });
      await ttsService.speak(_analysisReport);
      // Wait roughly or add listener in TTS service to reset. 
      // For simplicity, we just manage toggle state manually.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Report'),
      ),
      body: _isAnalyzing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing stylistic details & botanical motifs...'),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error analyzing artwork:\n$_errorMessage\n\nPlease ensure Supabase edge functions are configured and try again.',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Markdown(
                        data: _analysisReport,
                        styleSheet: MarkdownStyleSheet(
                          p: Theme.of(context).textTheme.bodyLarge,
                          h1: Theme.of(context).textTheme.headlineMedium,
                          h2: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: 'tts_btn',
                            onPressed: _togglePlayback,
                            icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                            label: Text(_isPlaying ? 'Stop Reading' : 'Read Aloud'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              final ttsService = Provider.of<TtsService>(context, listen: false);
                              ttsService.stop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InnovationScreen(
                                    analysisReport: _analysisReport,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.auto_awesome),
                            label: const Text('Generate Innovation'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
