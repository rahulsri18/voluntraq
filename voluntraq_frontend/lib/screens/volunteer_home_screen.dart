import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';
import 'role_selector_screen.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'volunteer_profile_screen.dart';

class VolunteerHomeScreen extends StatefulWidget {
  final String userId;
  const VolunteerHomeScreen({super.key, required this.userId});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  bool _isLoading = true;
  List<dynamic> _tasks = [];
  List<dynamic> _filteredTasks = [];
  List<dynamic> _aiRecommendations = [];
  Timer? _refreshTimer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _startAutoRefresh();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTasks = _tasks.where((task) {
        final title = (task['title'] ?? '').toString().toLowerCase();
        final desc = (task['description'] ?? '').toString().toLowerCase();
        return title.contains(query) || desc.contains(query);
      }).toList();
    });
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchData(isAuto: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData({bool isAuto = false}) async {
    if (!isAuto) setState(() => _isLoading = true);
    try {
      final allTasks = await ApiService.getTasks();
      final recommended = await ApiService.getAIRecommendedTasks(widget.userId);

      setState(() {
        _tasks = allTasks;
        _filteredTasks = allTasks;
        _aiRecommendations = recommended;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading tasks: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: const Text(
              'VOLUNTRAQ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VolunteerProfileScreen(userId: widget.userId),
                    ),
                  );
                },
                icon: const Icon(Icons.account_circle),
              ),
              IconButton(
                onPressed: () async {
                  await SessionManager.clearSession();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectorScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppGradients.primaryGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Icon(
                          Icons.volunteer_activism,
                          size: 180,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello Volunteer!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Ready to make\nan impact today?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Search Bar
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search for relief tasks...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_aiRecommendations.isNotEmpty) ...[
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'AI Recommended Match',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TaskCard(
                                task: _mapToTask(_aiRecommendations.first),
                                isHero: true,
                                onTap: () => _navigateToDetail(
                                  _mapToTask(_aiRecommendations.first),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            const Row(
                              children: [
                                Icon(
                                  Icons.near_me_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Nearby Opportunities',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = _mapToTask(_filteredTasks[index]);
                                return TaskCard(
                                  task: task,
                                  onTap: () => _navigateToDetail(task),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Task _mapToTask(dynamic json) {
    return Task(
      id: json['id'] ?? json['key'] ?? 'unknown',
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? '',
      ngoName: json['ngoName'] ?? 'VoluntraQ Partner',
      urgency: _parseUrgency(json['urgency']),
      distance: json['distance']?.toDouble() ?? 1.2,
      requiredSkills: List<String>.from(json['requiredSkills'] ?? ['General']),
      locationName: json['location'] ?? 'Unknown Location',
      latitude: json['latitude']?.toDouble() ?? 12.9716,
      longitude: json['longitude']?.toDouble() ?? 77.5946,
      category: json['category'] ?? 'General',
      estimatedHours: json['estimatedHours']?.toDouble() ?? 4.0,
      createdAt: DateTime.now(),
    );
  }

  TaskUrgency _parseUrgency(String? urgency) {
    switch (urgency?.toLowerCase()) {
      case 'critical':
        return TaskUrgency.critical;
      case 'high':
        return TaskUrgency.high;
      case 'low':
        return TaskUrgency.low;
      default:
        return TaskUrgency.medium;
    }
  }

  void _navigateToDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
    );
  }
}
