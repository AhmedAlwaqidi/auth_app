import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../getx_counter/views/getx_counter_page.dart';
import '../../riverpod_counter/views/riverpod_counter_page.dart';
import '../auth/login_page.dart';

/// Main navigation shell providing access to GetX Counter, Riverpod Counter,
/// and the Student Authentication portal.
class MainNavigationPage extends StatefulWidget {
  final AuthController authController;
  final int initialIndex;

  const MainNavigationPage({
    super.key,
    required this.authController,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const GetxCounterPage(),
      const RiverpodCounterPage(),
      LoginPage(controller: widget.authController),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt),
            label: 'GetX Counter',
          ),
          NavigationDestination(
            icon: Icon(Icons.waves_outlined),
            selectedIcon: Icon(Icons.waves),
            label: 'Riverpod Counter',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Student Auth',
          ),
        ],
      ),
    );
  }
}
