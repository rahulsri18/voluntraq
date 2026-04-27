import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants.dart';
import 'volunteer_home_screen.dart';
import 'admin_auth_screen.dart';
import 'admin_dashboard_screen.dart';

import 'login_screen.dart';

class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({super.key});

  @override
  State<RoleSelectorScreen> createState() => _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends State<RoleSelectorScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _howKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _footerKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.primaryGradient,
            ),
          ),

          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Top Image Section
                _TopImageSection(),

                // Hero Section
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.volunteer_activism,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'VoluntraQ',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(color: Colors.white, fontSize: 48),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'AI-Powered Crisis Coordination & Recovery',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1000),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _RoleCard(
                                        title: 'Volunteer / Field Worker',
                                        description:
                                            'Accept tasks & submit reports',
                                        icon: FontAwesomeIcons.userLarge,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: _RoleCard(
                                        title: 'NGO Administrator',
                                        description:
                                            'Manage needs & match tasks',
                                        icon: FontAwesomeIcons.shieldHalved,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminAuthScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Stats Section
                _StatsSection(),

                // Opportunities Section
                _OpportunitiesSection(),

                // Network Showcase Section
                _NetworkShowcaseSection(),

                // About Section
                Container(
                  key: _aboutKey,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: 40,
                  ),
                  color: Colors.white,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Column(
                        children: [
                          const Text(
                            'Why VoluntraQ?',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'In the face of disaster, every second counts. VoluntraQ is a next-generation platform designed to bridge the gap between ground-level needs and administrative action.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _FeatureItem(
                                icon: Icons.auto_awesome,
                                title: 'AI Matching',
                                desc: 'Gemini-powered task assignment',
                              ),
                              _FeatureItem(
                                icon: Icons.map_outlined,
                                title: 'Live Heatmaps',
                                desc: 'Crisis visualization in real-time',
                              ),
                              _FeatureItem(
                                icon: Icons.offline_bolt_outlined,
                                title: 'Offline First',
                                desc: 'Work without internet connectivity',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Detailed Features Section
                Container(key: _featuresKey, child: _DetailedFeaturesSection()),

                // Testimonials Section
                _TestimonialsSection(),

                // How It Works
                Container(key: _howKey, child: _HowItWorksSection()),

                // Footer Section
                _FooterSection(),
              ],
            ),
          ),

          // Logo at Top Left
          Positioned(
            top: 40,
            left: 40,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOutQuart,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'VoluntraQ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Glass Navigation Header (Centered)
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavButton(
                          label: 'Home',
                          onTap: () => _scrollController.animateTo(
                            0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOutQuart,
                          ),
                        ),
                        _NavButton(
                          label: 'How it Works',
                          onTap: () => _scrollToSection(_howKey),
                        ),
                        _NavButton(
                          label: 'Features',
                          onTap: () => _scrollToSection(_featuresKey),
                        ),
                        _NavButton(
                          label: 'About',
                          onTap: () => _scrollToSection(_aboutKey),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: _isHovered
                  ? Colors.white.withOpacity(0.25)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: _isHovered ? Colors.white70 : Colors.white24,
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, 20),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.secondary.withOpacity(0.8)
                        : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_isHovered)
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OngoingTasksTicker extends StatefulWidget {
  @override
  State<_OngoingTasksTicker> createState() => _OngoingTasksTickerState();
}

class _OngoingTasksTickerState extends State<_OngoingTasksTicker> {
  late ScrollController _scrollController;
  late Timer _timer;
  final List<String> _tasks = [
    "🚨 RESCUE: 5 people stranded in Zone A",
    "💊 MEDICAL: Emergency supplies needed at Base 1",
    "🌊 FLOOD: Water level rising in North Sector",
    "🚚 LOGISTICS: Food truck arriving at Shelter 4",
    "🏥 HEALTH: First aid training starts at 2 PM",
    "🤝 MISSION: 10 volunteers deployed to Sector 7",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 2,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final task = _tasks[index % _tasks.length];
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              task,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.1,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: Colors.white.withOpacity(0.05),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: '50k+', label: 'Volunteers'),
              _StatItem(value: '200+', label: 'NGO Partners'),
              _StatItem(value: '1M+', label: 'Lives Impacted'),
              _StatItem(value: '15s', label: 'Response Time'),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                'How VoluntraQ Works',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ProcessColumn(
                      title: 'For Volunteers',
                      steps: [
                        'Register & set your skills/radius',
                        'Get AI-matched with urgent needs',
                        'Navigate to site & submit reports',
                        'Earn badges & build your impact profile',
                      ],
                      icon: Icons.person_outline,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: _ProcessColumn(
                      title: 'For NGOs',
                      steps: [
                        'Onboard your organization',
                        'Deploy tasks with urgency scoring',
                        'Monitor ground-zero heatmaps',
                        'Approve field reports & export data',
                      ],
                      icon: Icons.business_outlined,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessColumn extends StatelessWidget {
  final String title;
  final List<String> steps;
  final IconData icon;
  final Color color;

  const _ProcessColumn({
    required this.title,
    required this.steps,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ...steps.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color.withOpacity(0.1),
                  child: Text(
                    '${e.key + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    e.value,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailedFeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      decoration: BoxDecoration(gradient: AppGradients.primaryGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                'Powerful Platform Features',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 32,
                runSpacing: 32,
                children: [
                  _FeatureCard(
                    title: 'Gemini 1.5 Pro Matching',
                    desc:
                        'State-of-the-art AI analysis of volunteer skills against disaster urgency scores.',
                    icon: Icons.psychology_outlined,
                  ),
                  _FeatureCard(
                    title: 'Real-time Crisis Mapping',
                    desc:
                        'Google Maps integrated heatmaps showing need density and volunteer distribution.',
                    icon: Icons.layers_outlined,
                  ),
                  _FeatureCard(
                    title: 'Intelligent OCR Intake',
                    desc:
                        'Convert physical damage assessment forms into digital data instantly using Cloud Vision.',
                    icon: Icons.document_scanner_outlined,
                  ),
                  _FeatureCard(
                    title: 'Offline-First Reports',
                    desc:
                        'Ground workers can capture data without internet; syncs automatically when online.',
                    icon: Icons.wifi_off_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;

  const _FeatureCard({
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              const Text(
                'Voices from the Ground',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: _TestimonialCard(
                      quote:
                          'VoluntraQ allowed us to coordinate 500+ volunteers in hours during the 2024 floods. The matching was flawless.',
                      author: 'Dr. Emily Watson',
                      role: 'Director, MercyCorps',
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _TestimonialCard(
                      quote:
                          'I used to spend hours looking for where I was needed. Now, I just open the app and follow the AI recommendation.',
                      author: 'Mark Stevens',
                      role: 'Volunteer Lead',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final String role;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: AppColors.primary, size: 40),
          const SizedBox(height: 16),
          Text(
            quote,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            author,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(role, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          foregroundColor: _isHovered ? Colors.black : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _isHovered ? 20 : 0,
              color: Colors.black,
              margin: const EdgeInsets.only(top: 4),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary, size: 48),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterLinks({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              link,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _NetworkShowcaseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const Text(
                "The world's largest volunteer recruitment network",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "VoluntraQ is the best place to reach like-hearted individuals to support your organization, community group, or event. Our platform is connecting more volunteers with opportunities to take action than ever before.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _NetworkCard(
                      icon: Icons.public,
                      iconColor: Colors.blue,
                      title: "Join More Than 200,000 Organizations",
                      desc:
                          "Sign up to join our network of nonprofits, social-impact corporations, and community groups using VoluntraQ to find volunteers.",
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _NetworkCard(
                      icon: Icons.handyman,
                      iconColor: Colors.green,
                      title: "Explore Resources for Leaders of Volunteers",
                      desc:
                          "Check out our library of resources, guides, and webinars for finding and engaging dedicated volunteers to support your cause.",
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _NetworkCard(
                      icon: Icons.extension,
                      iconColor: Colors.amber,
                      title: "Check Out Frequently Asked Questions",
                      desc:
                          "Take advantage of everything that VoluntraQ has to offer and discover how our advanced coordination tools benefit you.",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String desc;

  const _NetworkCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: iconColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Learn More",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunitiesSection extends StatefulWidget {
  @override
  State<_OpportunitiesSection> createState() => _OpportunitiesSectionState();
}

class _OpportunitiesSectionState extends State<_OpportunitiesSection> {
  late ScrollController _scrollController;
  late Timer _timer;

  final List<Map<String, dynamic>> _roles = [
    {
      "title": "Brighten a Day as a Hospice Activity Volunteer",
      "org": "CorsoCare Hospice - Michigan",
      "loc": "Warren, MI",
      "color": Colors.blue.shade50,
    },
    {
      "title": "Volunteer HR Generalist",
      "org": "Noah Career Coaching",
      "loc": "Remote",
      "color": Colors.green.shade50,
    },
    {
      "title": "Volunteer Victim Advocates",
      "org": "Project S.A.V.E (Survivors Against Violence Efforts)",
      "loc": "Philadelphia, PA",
      "color": Colors.amber.shade50,
    },
    {
      "title": "Analista / Asistente de Marketing",
      "org": "Corporación Nuevas Voces",
      "loc": "International",
      "color": Colors.purple.shade50,
    },
    {
      "title": "Administrative Assistant",
      "org": "RICHMOND MUSEUM ASSN INC",
      "loc": "Richmond, CA",
      "color": Colors.orange.shade50,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const Text(
                  "Find your next volunteer opportunity on VoluntraQ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "See All Volunteer Opportunities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Container(
            height: 240,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final role = _roles[index % _roles.length];
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: _OpportunityCard(
                    title: role['title'],
                    org: role['org'],
                    loc: role['loc'],
                    color: role['color'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final String title;
  final String org;
  final String loc;
  final Color color;

  const _OpportunityCard({
    required this.title,
    required this.org,
    required this.loc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "VOLUNTEER",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            org,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
              Text(
                loc,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: const Color(0xFF1B1B1B),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FooterColumn(
                      title: 'Volunteer',
                      links: [
                        'Volunteer Opportunities',
                        'Done in a Day Opportunities',
                        'Organizations',
                        'Volunteer Resources',
                        'VoluntraQ Days',
                      ],
                    ),
                  ),
                  Expanded(
                    child: _FooterColumn(
                      title: 'Find a Job',
                      links: [
                        'Jobs',
                        'Internships',
                        'Organizations',
                        'Salary Explorer',
                        'Career Advice',
                      ],
                    ),
                  ),
                  Expanded(
                    child: _FooterColumn(
                      title: 'Post on VoluntraQ',
                      links: [
                        'Post a Job Listing',
                        'Post a Volunteer Opportunity',
                        'Add your Organization',
                        'Volunteer Engagement Resources',
                        'Recruit Graduate Students',
                      ],
                    ),
                  ),
                  Expanded(
                    child: _FooterColumn(
                      title: 'About Us',
                      links: [
                        'Our Story',
                        'Our Team',
                        'Data & Insights',
                        'Help Desk',
                        'Donate to VoluntraQ',
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              const Divider(color: Colors.white10),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.volunteer_activism,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'voluntraq',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connecting more than 200,000 organizations with millions of people\nlooking for social-impact jobs and volunteer opportunities.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _LangLink('English'),
                        _LangLink('Español'),
                        _LangLink('Português'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text(
                    'Copyright © 2026 VoluntraQ.org',
                    style: TextStyle(color: Colors.white30, fontSize: 12),
                  ),
                  const Spacer(),
                  _BottomLink('Terms'),
                  const SizedBox(width: 24),
                  _BottomLink('Privacy Policy'),
                  const SizedBox(width: 24),
                  _BottomLink('Site Map'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                link,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LangLink extends StatelessWidget {
  final String label;
  _LangLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _BottomLink extends StatelessWidget {
  final String label;
  _BottomLink(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white30, fontSize: 12),
    );
  }
}

class _TopImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'asset/pexels-rdne-6646916.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Center Mission Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.volunteer_activism,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'VOLUNTRAQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'UNITING HUMANITY THROUGH AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ticker Overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white12, width: 1),
                ),
              ),
              child: _OngoingTasksTicker(),
            ),
          ),
        ],
      ),
    );
  }
}
