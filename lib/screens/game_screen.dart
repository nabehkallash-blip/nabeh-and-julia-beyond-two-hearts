import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Offset player = const Offset(0.16, 0.78);
  final Offset destination = const Offset(0.82, 0.22);
  bool completed = false;

  void _movePlayer(DragUpdateDetails details, Size size) {
    if (completed) return;

    setState(() {
      player = Offset(
        (player.dx + details.delta.dx / size.width).clamp(0.07, 0.93),
        (player.dy + details.delta.dy / size.height).clamp(0.08, 0.92),
      );

      final distance = math.sqrt(
        math.pow(player.dx - destination.dx, 2) +
            math.pow(player.dy - destination.dy, 2),
      );

      if (distance < 0.105) {
        completed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHAPTER 01  ·  THE FIRST LIGHT',
          style: TextStyle(fontSize: 12, letterSpacing: 1.2),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find your way to her.',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 7),
              const Text(
                'Drag the glowing heart through the night to reach Julia.',
                style: TextStyle(color: Colors.white60, height: 1.4),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF302044),
                              Color(0xFF17142D),
                              Color(0xFF101B31),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: size.width * 0.12,
                              top: size.height * 0.18,
                              child: const _Star(),
                            ),
                            Positioned(
                              left: size.width * 0.68,
                              top: size.height * 0.52,
                              child: const _Star(),
                            ),
                            Positioned(
                              left: size.width * 0.36,
                              top: size.height * 0.72,
                              child: const _Star(),
                            ),
                            Positioned(
                              left: destination.dx * size.width - 29,
                              top: destination.dy * size.height - 29,
                              child: _HeartTarget(completed: completed),
                            ),
                            Positioned(
                              left: player.dx * size.width - 27,
                              top: player.dy * size.height - 27,
                              child: GestureDetector(
                                onPanUpdate: (details) =>
                                    _movePlayer(details, size),
                                child: const _PlayerHeart(),
                              ),
                            ),
                            if (completed)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.all(24),
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surface,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: AppTheme.pink.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.favorite,
                                            color: AppTheme.pink,
                                            size: 42,
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Two hearts, one beginning.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'You found Julia. This is only the beginning.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          FilledButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('BACK TO HOME'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Icon(Icons.touch_app, color: AppTheme.gold, size: 19),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'HOLD THE HEART AND DRAG IT TOWARD THE GLOW',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
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

class _PlayerHeart extends StatelessWidget {
  const _PlayerHeart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.pink.withValues(alpha: 0.18),
        boxShadow: const [
          BoxShadow(color: AppTheme.pink, blurRadius: 24, spreadRadius: 2),
        ],
      ),
      child: const Icon(
        Icons.favorite_rounded,
        color: AppTheme.pink,
        size: 30,
      ),
    );
  }
}

class _HeartTarget extends StatelessWidget {
  const _HeartTarget({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.violet.withValues(alpha: 0.20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.violet.withValues(alpha: 0.8),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(
        completed ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
        size: 34,
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.auto_awesome,
      color: AppTheme.gold,
      size: 18,
      shadows: [Shadow(color: AppTheme.gold, blurRadius: 12)],
    );
  }
}
