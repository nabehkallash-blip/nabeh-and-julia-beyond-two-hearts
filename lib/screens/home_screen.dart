import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF263E49), AppTheme.background, Color(0xFF17132D)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 42, left: 24, right: 24, height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/together.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ColoredBox(color: AppTheme.surface),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 245, 28, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('NABEH & JULIA',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 29, letterSpacing: 3,
                          fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      const Text('BEYOND TWO HEARTS',
                        style: TextStyle(color: AppTheme.gold, fontSize: 11,
                          letterSpacing: 4, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 18),
                      const Text(
                        'It began on two university benches.\nTwo shy hearts. One conversation.\nA story that was about to begin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 15),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity, height: 56,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.pink,
                            foregroundColor: const Color(0xFF291326),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(builder: (_) => const GameScreen()),
                          ),
                          child: const Text('BEGIN WHERE WE BEGAN',
                            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text('A little world made for two ♥',
                        style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
