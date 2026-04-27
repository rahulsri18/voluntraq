import 'package:flutter/material.dart';
import '../utils/constants.dart';

class VolunteerProfileReviewScreen extends StatelessWidget {
  final Map<String, dynamic> volunteer;
  const VolunteerProfileReviewScreen({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${volunteer['name']}\'s Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            volunteer['name'][0], 
                            style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(volunteer['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text('Verified Volunteer', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSection('Skills & Expertise', Wrap(
                    spacing: 8,
                    children: (volunteer['skills'] as List).map((s) => Chip(label: Text(s))).toList(),
                  )),
                  const SizedBox(height: 24),
                  _buildSection('Weekly Availability', Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: day == 'S' ? Colors.grey.shade200 : AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(day, style: TextStyle(color: day == 'S' ? Colors.grey : AppColors.primary, fontWeight: FontWeight.bold)),
                    )).toList(),
                  )),
                  const SizedBox(height: 24),
                  _buildSection('Location Radius', const Text('Within 15km of Disaster Zone', style: TextStyle(fontSize: 16))),
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Reject Application'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Volunteer Approved! Task assigned.'), backgroundColor: Colors.green),
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Approve & Assign'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}
