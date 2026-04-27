import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'volunteer_home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userId;
  const ProfileSetupScreen({super.key, required this.userId});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final List<String> _availableSkills = [
    'Medical', 'Teaching', 'Construction', 'Driving', 'Cooking', 'Logistics', 'First Aid', 'Translation'
  ];
  final List<String> _selectedSkills = [];
  double _radius = 10.0;
  final Map<String, bool> _availability = {
    'Mon': true, 'Tue': true, 'Wed': true, 'Thu': true, 'Fri': true, 'Sat': false, 'Sun': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete Your Profile',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tell us your skills so Gemini can find the best tasks for you.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  
                  const Text('Select Your Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  const Text('Weekly Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _availability.keys.map((day) {
                      final isAvailable = _availability[day]!;
                      return GestureDetector(
                        onTap: () => setState(() => _availability[day] = !isAvailable),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isAvailable ? AppColors.primary : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  day[0],
                                  style: TextStyle(color: isAvailable ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(day, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Preferred Radius', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${_radius.toInt()} km', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _radius,
                    min: 1,
                    max: 50,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _radius = val),
                  ),
                  
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      // Save to Firestore logic
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => VolunteerHomeScreen(userId: widget.userId)),
                      );
                    },
                    child: const Text('Save and Continue'),
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
