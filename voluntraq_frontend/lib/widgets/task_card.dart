import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isHero;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.isHero = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isHero ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isHero 
              ? AppColors.primary.withOpacity(0.3) 
              : Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: isHero ? null : Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _UrgencyBadge(urgency: task.urgency, isHero: isHero),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined, 
                          size: 14, 
                          color: isHero ? Colors.white70 : AppColors.textSecondary
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.distance} km away',
                          style: TextStyle(
                            color: isHero ? Colors.white70 : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  task.title,
                  style: TextStyle(
                    color: isHero ? Colors.white : AppColors.textPrimary,
                    fontSize: isHero ? 26 : 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined, 
                      size: 16, 
                      color: isHero ? Colors.white60 : AppColors.primary.withOpacity(0.7)
                    ),
                    const SizedBox(width: 6),
                    Text(
                      task.ngoName,
                      style: TextStyle(
                        color: isHero ? Colors.white70 : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: task.requiredSkills.map((skill) => _SkillChip(
                    label: skill,
                    isHero: isHero,
                  )).toList(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isHero ? Colors.white : AppColors.primary,
                        foregroundColor: isHero ? AppColors.primary : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                if (isHero) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Icon(
                      Icons.keyboard_arrow_down, 
                      color: isHero ? Colors.white.withOpacity(0.5) : Colors.transparent
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UrgencyBadge extends StatelessWidget {
  final TaskUrgency urgency;
  final bool isHero;

  const _UrgencyBadge({required this.urgency, this.isHero = false});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (urgency) {
      case TaskUrgency.critical:
        color = isHero ? Colors.white : AppColors.critical;
        label = 'CRITICAL';
        break;
      case TaskUrgency.high:
        color = isHero ? Colors.white : AppColors.high;
        label = 'HIGH';
        break;
      case TaskUrgency.medium:
        color = isHero ? Colors.white : AppColors.medium;
        label = 'MEDIUM';
        break;
      case TaskUrgency.low:
        color = isHero ? Colors.white : AppColors.low;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHero ? Colors.white.withOpacity(0.2) : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final bool isHero;

  const _SkillChip({required this.label, required this.isHero});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isHero ? Colors.white.withOpacity(0.15) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: isHero ? Border.all(color: Colors.white24) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isHero ? Colors.white : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
