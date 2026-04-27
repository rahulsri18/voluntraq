import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/constants.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import 'role_selector_screen.dart';
import 'location_picker_screen.dart';
import 'task_applications_screen.dart';
import 'package:geolocator/geolocator.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<dynamic> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final tasks = await ApiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  void _showCreateTaskDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final locController = TextEditingController();
    String urgency = 'Medium';
    LatLng? pickedCoords;

    // Automatic Location Detection
    final position = await _determinePosition();
    if (position != null) {
      pickedCoords = LatLng(position.latitude, position.longitude);
      locController.text = "Detected: ${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}";
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Deploy New Relief Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Task Title')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(
                  controller: locController, 
                  decoration: InputDecoration(
                    labelText: 'Area Name (e.g. Zone A)',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.map_outlined, color: AppColors.primary),
                      onPressed: () async {
                        final result = await Navigator.push<LatLng>(
                          context,
                          MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
                        );
                        if (result != null) {
                          setDialogState(() {
                            pickedCoords = result;
                            locController.text = "Lat: ${result.latitude.toStringAsFixed(2)}, Lng: ${result.longitude.toStringAsFixed(2)}";
                          });
                        }
                      },
                    ),
                  ),
                ),
                if (pickedCoords != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('📍 Location Captured', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: urgency,
                  items: ['Low', 'Medium', 'High'].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                  onChanged: (v) => urgency = v!,
                  decoration: const InputDecoration(labelText: 'Urgency'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                await ApiService.createTask(
                  titleController.text, 
                  descController.text, 
                  locController.text, 
                  urgency,
                  lat: pickedCoords?.latitude,
                  lng: pickedCoords?.longitude,
                );
                Navigator.pop(context);
                _fetchTasks();
              },
              child: const Text('Deploy'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          // Top Row Metrics
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TopMetricCard(label: 'Open Tasks', value: _tasks.length.toString(), icon: Icons.assignment_late, color: Colors.orange),
                _TopMetricCard(label: 'Active Volunteers', value: '42', icon: Icons.people, color: Colors.blue),
                _TopMetricCard(label: 'Completed Tasks', value: '128', icon: Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                // Sidebar: Ranked Needs
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return _TaskListItem(task: task);
                          },
                        ),
                  ),
                ),
                // Map View with Heatmap
                Expanded(
                  flex: 3,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(12.9716, 77.5946),
                      zoom: 12,
                    ),
                    circles: _buildHeatmapCircles(),
                    markers: _buildMarkers(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTaskDialog,
        label: const Text('Deploy New Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Set<Circle> _buildHeatmapCircles() {
    return _tasks.where((t) => t['latitude'] != null).map((t) {
      final urgency = t['urgency'] ?? 'Medium';
      Color color = Colors.orange;
      if (urgency == 'High') color = Colors.red;
      if (urgency == 'Low') color = Colors.green;

      return Circle(
        circleId: CircleId("heat_${t['id'] ?? t['key']}"),
        center: LatLng(t['latitude'], t['longitude']),
        radius: 1000,
        fillColor: color.withOpacity(0.2),
        strokeWidth: 0,
      );
    }).toSet();
  }

  Set<Marker> _buildMarkers() {
    return _tasks.where((t) => t['latitude'] != null).map((t) {
      return Marker(
        markerId: MarkerId(t['id'] ?? t['key'] ?? 'm'),
        position: LatLng(t['latitude'], t['longitude']),
        infoWindow: InfoWindow(title: t['title']),
      );
    }).toSet();
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VoluntraQ Admin', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Disaster Response Hub', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Generating Impact Report... PDF will download shortly.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('Export Impact Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () async {
                  await SessionManager.clearSession();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RoleSelectorScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskListItem extends StatefulWidget {
  final dynamic task;
  const _TaskListItem({required this.task});

  @override
  State<_TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<_TaskListItem> {
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Opacity(
        opacity: _isCompleted ? 0.7 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isCompleted ? Colors.grey.shade50 : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isCompleted ? Colors.grey.shade100 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isCompleted,
                        activeColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) => setState(() => _isCompleted = val!),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getUrgencyColor(widget.task['urgency']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.task['urgency']?.toUpperCase() ?? 'MEDIUM', 
                          style: TextStyle(color: _getUrgencyColor(widget.task['urgency']), fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.task['category'] ?? 'General',
                    style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.task['title'] ?? 'Untitled', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  decoration: _isCompleted ? TextDecoration.lineThrough : null,
                  color: _isCompleted ? Colors.grey : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(widget.task['location'] ?? 'Unknown', style: const TextStyle(color: Colors.grey, fontSize: 12))),
                  Text('2h ago', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
              if (!_isCompleted) ...[
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${(widget.task['id']?.length ?? 5) % 8 + 1} Applied', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TaskApplicationsScreen(taskId: widget.task['id'] ?? '1')),
                        );
                      },
                      child: const Text('Review Applicants'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String? urgency) {
    if (urgency == 'High') return Colors.red;
    if (urgency == 'Low') return Colors.green;
    return Colors.orange;
  }
}

class _TopMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TopMetricCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
