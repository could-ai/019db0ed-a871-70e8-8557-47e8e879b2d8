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
      appBar: AppBar(
        title: const Text('Local Innovation'),
      ),
      body: _isGenerating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Generating stylized local innovation image...\nFiltering out European influences.',
                    textAlign: TextAlign.center,
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
                      style: const TextStyle(color: Colors.red),
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
                        Text(
                          'Pure Constantine Innovation',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This generated piece isolates the local geometrical and botanical patterns discovered in the analysis, explicitly excluding Baroque curves and other European influences.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _generatedImageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 300,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 300,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
