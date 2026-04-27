class Volunteer {
  final String id;
  final String name;
  final String email;
  final List<String> skills;
  final double preferredRadius; // in km
  final Map<String, List<String>> availability; // Day -> [Time Slots]
  final int tasksCompleted;
  final int totalHours;

  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.skills,
    required this.preferredRadius,
    required this.availability,
    this.tasksCompleted = 0,
    this.totalHours = 0,
  });

  static Volunteer get mockVolunteer => Volunteer(
    id: 'v1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    skills: ['Medical', 'Driving', 'Teaching'],
    preferredRadius: 10.0,
    availability: {
      'Monday': ['Evening'],
      'Saturday': ['Morning', 'Afternoon'],
    },
    tasksCompleted: 15,
    totalHours: 42,
  );
}
