import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'diary.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dashboardButton({
      required String imagePath,
      required String label,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF56C1FF), Color(0xFF005AAA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.leckerliOne(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: GoogleFonts.leckerliOne(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF005AAA),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCDFFD8), Color(0xFF94B9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dashboardButton(
              imagePath: 'img/weather.png',
              label: 'Weather',
              onTap: () {
                // TODO: Navigate to Weather page
              },
            ),
            const SizedBox(height: 40),
            dashboardButton(
              imagePath: 'img/diary.png',
              label: 'Diary',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryPage()),
                );
              },
            ),
            const SizedBox(height: 40),
            dashboardButton(
              imagePath: 'img/special.png',
              label: 'Special',
              onTap: () {
                // TODO: Navigate to Special page
              },
            ),
            const SizedBox(height: 40),
            dashboardButton(
              imagePath: 'img/logout.png',
              label: 'Log Out',
              onTap: () {
                Navigator.pop(context); // Or SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
