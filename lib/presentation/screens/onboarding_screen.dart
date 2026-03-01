// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color kPrimary = Color(0xFF233662);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  final List<_OnboardPageData> pages = [
    _OnboardPageData(
      title: 'Find Talent Faster',
      subtitle:
      'Post recruitment requests and match with verified candidates in minutes.',
      icon: Icons.groups_sharp,
    ),
    _OnboardPageData(
      title: 'Manage Requests Easily',
      subtitle:
      'Track request status, interview schedules and offers from a single dashboard.',
      icon: Icons.work_history_rounded,
    ),
    _OnboardPageData(
      title: 'Collaborate & Hire',
      subtitle:
      'Assign requests to your team, share candidates, and close positions faster.',
      icon: Icons.how_to_reg_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
    } else {
      _finishOnboarding();
    }
  }

  void _skip() {
    _pageController.animateToPage(pages.length - 1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _finishOnboarding() {
    // Replace with your route e.g., '/login' or '/dashboard'
    Get.offAllNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // Top: Skip button aligned right
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(foregroundColor: kPrimary),
                  child: const Text('Skip'),
                )
              ],
            ),
          ),

          // PageView region
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) {
                final p = pages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // big circular illustration
                      Container(
                        height: media.height * 0.34,
                        width: media.height * 0.34,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [kPrimary.withOpacity(0.95), kPrimary.withOpacity(0.7)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimary.withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            )
                          ],
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Center(
                          child: Icon(p.icon, size: media.height * 0.13, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        p.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        p.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Indicators + Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18),
            child: Column(
              children: [
                _DotIndicator(count: pages.length, active: _page),

                const SizedBox(height: 18),

                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // show login (or other light action)
                        Get.toNamed('/login');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: kPrimary.withOpacity(0.18)),
                      ),
                      child: const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: Text(
                        _page == pages.length - 1 ? 'Get started' : 'Next',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int active;
  const _DotIndicator({required this.count, required this.active, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(count, (i) {
      final bool isActive = i == active;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: isActive ? 28 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? kPrimary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [BoxShadow(color: kPrimary.withOpacity(0.22), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
      );
    }));
  }
}

class _OnboardPageData {
  final String title;
  final String subtitle;
  final IconData icon;
  _OnboardPageData({required this.title, required this.subtitle, required this.icon});
}