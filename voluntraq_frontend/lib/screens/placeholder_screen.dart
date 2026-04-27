import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SimplePlaceholderScreen extends StatelessWidget {
  final String title;
  const SimplePlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 80, color: AppColors.primary.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              '$title Page coming soon...',
              style: const TextStyle(fontSize: 20, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
