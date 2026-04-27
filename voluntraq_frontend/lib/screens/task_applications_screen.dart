import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'volunteer_profile_review_screen.dart';

class TaskApplicationsScreen extends StatelessWidget {
  final String taskId;
  const TaskApplicationsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    // Mock data for applicants
    final List<Map<String, dynamic>> applicants = [
      {'name': 'Alex Johnson', 'skills': ['Medical', 'First Aid'], 'match': 95, 'id': 'v1'},
      {'name': 'Sarah Smith', 'skills': ['Logistics', 'Driving'], 'match': 88, 'id': 'v2'},
      {'name': 'Mike Chen', 'skills': ['Construction'], 'match': 72, 'id': 'v3'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Applications'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final applicant = applicants[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(applicant['name'][0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(applicant['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Skills: ${applicant['skills'].join(", ")}'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Gemini Match: ${applicant['match']}%',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerProfileReviewScreen(volunteer: applicant),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Review Profile'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
