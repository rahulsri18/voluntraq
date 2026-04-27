import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'profile_setup_screen.dart';

class VolunteerProfileScreen extends StatelessWidget {
  final String userId;
  const VolunteerProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Mock data for user profile
    final String userName = "Alex Johnson";
    final List<String> userSkills = ["Medical", "First Aid", "Driving"];
    final List<Map<String, String>> appliedTasks = [
      {'title': 'Medical Aid Distribution', 'ngo': 'Red Cross', 'status': 'Pending Approval'},
      {'title': 'Flood Response Logistics', 'ngo': 'UNICEF', 'status': 'Approved'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSetupScreen(userId: userId)),
              );
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(userName),
                  const SizedBox(height: 40),
                  _buildSectionTitle('My Skills'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: userSkills.map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      side: BorderSide.none,
                    )).toList(),
                  ),
                  const SizedBox(height: 40),
                  _buildSectionTitle('Applied Tasks'),
                  const SizedBox(height: 16),
                  ...appliedTasks.map((task) => _buildTaskStatusCard(task)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(name[0], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Level 4 Volunteer', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            const Text('Joined April 2024', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildTaskStatusCard(Map<String, String> task) {
    final bool isApproved = task['status'] == 'Approved';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(task['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task['ngo']!, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isApproved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            task['status']!,
            style: TextStyle(
              color: isApproved ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
