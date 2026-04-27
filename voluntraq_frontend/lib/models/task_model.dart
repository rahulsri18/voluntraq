enum TaskUrgency { critical, high, medium, low }

class Task {
  final String id;
  final String title;
  final String description;
  final String ngoName;
  final TaskUrgency urgency;
  final double distance; // in km
  final List<String> requiredSkills;
  final String locationName;
  final double latitude;
  final double longitude;
  final String category;
  final double estimatedHours;
  final DateTime createdAt;
  final String? imageUrl;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.ngoName,
    required this.urgency,
    required this.distance,
    required this.requiredSkills,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.estimatedHours,
    required this.createdAt,
    this.imageUrl,
  });

  // Mock data for initial frontend development
  static List<Task> get mockTasks => [
    Task(
      id: '1',
      title: 'Emergency Food Distribution',
      description: 'Distribution of essential food items to flood-affected families in the Riverside area. Volunteers are needed to help organize and hand out packages.',
      ngoName: 'Helping Hands NGO',
      urgency: TaskUrgency.critical,
      distance: 1.2,
      requiredSkills: ['Organization', 'Heavy Lifting'],
      locationName: 'Riverside Community Center',
      latitude: 12.9716,
      longitude: 77.5946,
      category: 'Food & Water',
      estimatedHours: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Task(
      id: '2',
      title: 'Mobile Medical Camp',
      description: 'Assisting doctors and nurses in setting up a mobile medical camp for elderly residents. No medical background required for logistics help.',
      ngoName: 'Care Network',
      urgency: TaskUrgency.high,
      distance: 2.5,
      requiredSkills: ['Medical', 'Logistics'],
      locationName: 'Central Park North',
      latitude: 12.9816,
      longitude: 77.6046,
      category: 'Medical',
      estimatedHours: 6,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Task(
      id: '3',
      title: 'Handwritten Survey Digitization',
      description: 'Collect and digitize community need surveys from the field. Use the app to take photos of paper surveys.',
      ngoName: 'VoluntraQ Admin',
      urgency: TaskUrgency.medium,
      distance: 0.8,
      requiredSkills: ['Photography', 'Data Entry'],
      locationName: 'Sunset Slums Office',
      latitude: 12.9616,
      longitude: 77.5846,
      category: 'Other',
      estimatedHours: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
