import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';

class ReportSubmissionScreen extends StatefulWidget {
  const ReportSubmissionScreen({super.key});

  @override
  State<ReportSubmissionScreen> createState() => _ReportSubmissionScreenState();
}

class _ReportSubmissionScreenState extends State<ReportSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  String _selectedCategory = 'Food & Water';
  XFile? _image;
  bool _isScanning = false;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Food & Water', 'Medical Help', 'Shelter', 'Sanitation', 'Education', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  Future<void> _detectLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
    } catch (e) {
      debugPrint('Location detection failed: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.camera);
    if (selected != null) {
      setState(() {
        _image = selected;
        _isScanning = true;
      });
      
      // Simulate Cloud Vision OCR process
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isScanning = false;
        _notesController.text = "AI Extracted: [Patient ID: 442, Urgent need for Antibiotics and Clean Bandages]";
      });
    }
  }

  void _handleSubmit() {
    // Simulate offline support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connectivity Low: Report queued for sync!'),
        backgroundColor: Colors.orange,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Field Report Submission'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationStatus(),
                    const SizedBox(height: 24),
                    const Text('Digitalize Paper Survey', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildImagePicker(),
                    const SizedBox(height: 32),
                    const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 24),
                    const Text('Field Observations', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildNotesField(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('Sync & Submit Report'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.gps_fixed, color: _currentPosition != null ? Colors.green : Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GPS Location', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                _currentPosition != null 
                  ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                  : 'Detecting...',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2, style: BorderStyle.solid),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_image == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: AppColors.primary),
                  const SizedBox(height: 12),
                  const Text('Capture Paper Survey', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const Text('AI will auto-extract text', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            else
              const Icon(Icons.description, size: 80, color: Colors.grey),
            
            if (_isScanning)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('AI Processing OCR...', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
      onChanged: (val) => setState(() => _selectedCategory = val!),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Add observations or AI will populate from scan...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
