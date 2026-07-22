import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/view/all_requests_screen.dart';
import '../../../home/presentation/view/home_view.dart';
import '../../../notifications/presentation/view/notification_screen.dart';
import '../../../profile_screen/presentation/view/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  List<Widget> get pages => const [
    HomeScreen(),
    AllRequestsScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItemData> items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Home'),
    _NavItemData(icon: Icons.receipt_long, label: 'All requests'),
    _NavItemData(icon: Icons.notifications_none_rounded, label: 'Alerts'),
    _NavItemData(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  String _getLocalizedLabel(BuildContext context, int index) {
    switch (index) {
      case 0:
        return LocaleKeys.general_home.tr();
      case 1:
        return LocaleKeys.general_all_requests.tr();
      case 2:
        return LocaleKeys.general_alerts.tr();
      case 3:
        return LocaleKeys.Profile_Profile.tr();
      default:
        return '';
    }
  }

  AlignmentDirectional _alignment(int index) {
    switch (index) {
      case 0:
        return const AlignmentDirectional(-0.88, -1);
      case 1:
        return const AlignmentDirectional(-0.30, -1);
      case 2:
        return const AlignmentDirectional(0.28, -1);
      case 3:
        return const AlignmentDirectional(0.88, -1);
      default:
        return AlignmentDirectional.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(
                    items.length,
                        (index) => Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => onTap(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 6),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: currentIndex == index ? 0 : 1,
                              child: Icon(
                                items[index].icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: currentIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: currentIndex == index
                                    ? AppColors.accentRed
                                    : Colors.white,
                              ),
                              child: Text(_getLocalizedLabel(context, index)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 85,
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutBack,
                  alignment: _alignment(currentIndex),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 25,
                          color: Colors.black26,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      items[currentIndex].icon,
                      color: AppColors.accentRed,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.label,
  });
}