import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';
import 'innovation_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final File imageFile;

  const AnalysisScreen({super.key, required this.imageFile});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isLoading = true;
  String _analysisReport = '';
  String _errorMessage = '';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final report = await apiService.analyzeImage(widget.imageFile);
      setState(() {
        _analysisReport = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePlayback() async {
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
      // Assume reading ends at some point, real impl needs listener
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    // In a real app we'd need to properly stop TTS here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Analysis Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/6/66/Carte_de_la_province_de_Constantine.jpg', // Map of Cirta / Constantine
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.85), // dark overlay to make text readable
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFD4AF37)),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing artwork...',
                        style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18),
                      ),
                    ],
                  ),
                )
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Error: $_errorMessage',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                            ),
                            child: Markdown(
                              data: _analysisReport,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 16, color: Colors.black87),
                                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            border: const Border(top: BorderSide(color: Color(0xFFD4AF37), width: 2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD4AF37),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                onPressed: _togglePlayback,
                                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                                label: Text(_isPlaying ? 'Stop' : 'Read Aloud'),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C3E50),
                                  foregroundColor: const Color(0xFFD4AF37),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
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
                                label: const Text('Innovation'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
