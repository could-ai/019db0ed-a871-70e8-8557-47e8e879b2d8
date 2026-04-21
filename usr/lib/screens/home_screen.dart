import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _analyzeImage() {
    if (_selectedImage == null) return;
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisScreen(
            imageFile: _selectedImage!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Algerian Stucco (Zellij) vibe background
          gradient: RadialGradient(
            colors: [
              Color(0xFFE8DCC4), // Light stucco
              Color(0xFFC7A97A), // Deeper earthy tone
              Color(0xFF8B6B4A), // Rich historic brown
            ],
            center: Alignment.center,
            radius: 1.5,
          ),
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1540304675762-b91c4d9bc27d?q=80&w=800&auto=format&fit=crop'), // Subtle textured background
            fit: BoxFit.cover,
            opacity: 0.15,
            colorFilter: ColorFilter.mode(Color(0xFFC7A97A), BlendMode.multiply),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Golden Arabic Calligraphy Title
                    Text(
                      'مفكك شفرات فن سيرتا',
                      style: GoogleFonts.amiri(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFD700), // Gold
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Constantine Art Decoder',
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 2.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Vintage Map of Cirta Placeholder (or image container)
                    if (_selectedImage == null)
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFD700), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1582650549929-e85dcfaf4699?q=80&w=800&auto=format&fit=crop'), // Vintage map aesthetic
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Color(0xFF6B4A2F), BlendMode.color),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            'Vintage Map of Cirta',
                            style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 320,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFD700), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 40),

                    if (_selectedImage == null) ...[
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.camera_alt,
                            label: 'Camera',
                            onPressed: () => _pickImage(ImageSource.camera),
                          ),
                          _buildActionButton(
                            icon: Icons.photo_library,
                            label: 'Gallery',
                            onPressed: () => _pickImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Analysis Button
                      ElevatedButton(
                        onPressed: _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3B4D), // Deep teal/blue accent often in Zellij
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
                          ),
                          elevation: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFFFFD700)),
                            const SizedBox(width: 12),
                            Text(
                              'Analyze Artwork Roots',
                              style: GoogleFonts.lora(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () => setState(() => _selectedImage = null),
                        icon: const Icon(Icons.refresh, color: Colors.white70),
                        label: const Text(
                          'Choose Another Image',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C4A3B), Color(0xFF1A2E24)], // Deep green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFFFFD700)),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.lora(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}