import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class InnovationScreen extends StatefulWidget {
  final String analysisReport;

  const InnovationScreen({
    super.key,
    required this.analysisReport,
  });

  @override
  State<InnovationScreen> createState() => _InnovationScreenState();
}

class _InnovationScreenState extends State<InnovationScreen> {
  bool _isGenerating = true;
  String? _generatedImageUrl;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _generateInnovation();
  }

  Future<void> _generateInnovation() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final url = await apiService.generateInnovation(widget.analysisReport);
      
      setState(() {
        _isGenerating = false;
        _generatedImageUrl = url;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Local Innovation',
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
              Colors.black.withOpacity(0.85),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: _isGenerating
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(color: Color(0xFFD4AF37)),
                      SizedBox(height: 16),
                      Text(
                        'Generating stylized local innovation image...\nFiltering out European influences.',
                        textAlign: TextAlign.center,
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
                          'Error generating image:\n$_errorMessage',
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Pure Constantine Innovation',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'This generated piece isolates the local geometrical and botanical patterns discovered in the analysis, explicitly excluding Baroque curves and other European influences.',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _generatedImageUrl!,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 300,
                                      color: Colors.black45,
                                      child: const Center(
                                        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 300,
                                      color: Colors.black45,
                                      child: const Center(
                                        child: Icon(Icons.error, color: Colors.redAccent, size: 40),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
