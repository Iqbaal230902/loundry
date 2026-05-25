import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/home/home_content.dart';
import 'screens/orders/orders_content.dart';
import 'screens/promo/promo_content.dart';
import 'screens/profile/profile_content.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const LaundryApp(),
    ),
  );
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class LaundryHomePage extends StatefulWidget {
  const LaundryHomePage({super.key});

  @override
  State<LaundryHomePage> createState() => _LaundryHomePageState();
}

class _LaundryHomePageState extends State<LaundryHomePage> {
  int _selectedIndex = 0;

  void _onNavigateToPromo() {
    setState(() {
      _selectedIndex = 2; // Index Promo
    });
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Light blue background for active icon
          color: isSelected ? const Color(0xFFE0F2FE) : Colors.transparent, 
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon,
          // Blue color for active, Grey for inactive
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[400], 
          size: 26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContentWidget(
        key: const ValueKey('home'),
        onNavigateToPromo: _onNavigateToPromo,
      ),
      const OrdersContentWidget(key: ValueKey('orders')),
      const PromoContentWidget(key: ValueKey('promo')),
      const ProfileContentWidget(key: ValueKey('profile')),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[_selectedIndex],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35), // Pill shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08), // Soft shadow
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 4 Requested Icons: Home, Search, Globe, Compass
                      _buildNavItem(0, CupertinoIcons.house_fill, CupertinoIcons.house),
                      _buildNavItem(1, CupertinoIcons.search, CupertinoIcons.search),
                      _buildNavItem(2, CupertinoIcons.globe, CupertinoIcons.globe),
                      _buildNavItem(3, CupertinoIcons.compass, CupertinoIcons.compass),
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
}
