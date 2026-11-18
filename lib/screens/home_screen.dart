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
            colors: [
              Color(0xFF261638),
              AppTheme.background,
              Color(0xFF17132D),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 70,
                right: 24,
                child: _FloatingHeart(size: 25, opacity: 0.35),
              ),
              const Positioned(
                top: 190,
                left: 28,
                child: _FloatingHeart(size: 16, opacity: 0.25),
              ),
              const Positioned(
                bottom: 145,
                right: 48,
                child: _FloatingHeart(size: 19, opacity: 0.30),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_rounded,
                        size: 58,
                        color: AppTheme.pink,
                        shadows: [
                          Shadow(color: AppTheme.pink, blurRadius: 28),
                        ],
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'NABEH & JULIA',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 31,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'BEYOND TWO HEARTS',
                        style: TextStyle(
                          color: AppTheme.gold,
                          fontSize: 12,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Two hearts. One journey.\nA thousand little moments.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.6,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 54),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.pink,
                            foregroundColor: const Color(0xFF291326),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const GameScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'BEGIN OUR STORY',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'A little world made for two ♥',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
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

class _FloatingHeart extends StatelessWidget {
  const _FloatingHeart({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite_rounded,
      size: size,
      color: AppTheme.pink.withValues(alpha: opacity),
    );
  }
}
