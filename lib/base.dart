import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final int selectedIndex;
  final Widget child;

  const BasePage({Key? key, required this.selectedIndex, required this.child})
      : super(key: key);

  void _onNavTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/weather');
        break;
      case 2:
      // Already on Diary page
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/special');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5DE0E6), Color(0xFF004AAD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => _onNavTapped(context, index),
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}