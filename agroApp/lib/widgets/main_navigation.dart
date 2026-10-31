import 'package:flutter/material.dart';

import 'package:agroapp/pages/dashboard/dashboard.dart';
import 'package:agroapp/pages/outorga/outorga.dart';
import 'package:agroapp/widgets/bottom_navigation.dart';
import 'package:agroapp/pages/modulos/modulos_page.dart';
import 'package:agroapp/pages/perfil/perfil_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    OutorgasPage(),
    ModulosPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
