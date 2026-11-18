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
        (player.dx + details.delta.dx / size.width).clamp(0.07, 0.93).toDouble(),
        (player.dy + details.delta.dy / size.height).clamp(0.08, 0.92).toDouble(),
      );
      final distance = math.sqrt(
        math.pow(player.dx - destination.dx, 2) +
            math.pow(player.dy - destination.dy, 2),
      );
      if (distance < 0.105) completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHAPTER 01  ·  TWO BENCHES, ONE BEGINNING',
            style: TextStyle(fontSize: 10, letterSpacing: 1)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A little closer…',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text(
                'Damascus University. Two different benches. One conversation on two phones.',
                style: TextStyle(color: Colors.white70, height: 1.35, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        const Positioned.fill(child: _CampusBackdrop()),
                        Positioned(
                          left: size.width * 0.045,
                          top: size.height * 0.055,
                          child: const _MessageBubble(
                            text: 'Somewhere on campus…',
                            alignRight: false,
                          ),
                        ),
                        Positioned(
                          right: size.width * 0.04,
                          bottom: size.height * 0.055,
                          child: const _MessageBubble(
                            text: 'Both wishing they were a little braver.',
                            alignRight: true,
                          ),
                        ),
                        Positioned(
                          left: size.width * 0.055,
                          bottom: size.height * 0.22,
                          child: const _BenchPortrait(
                            name: 'Nabeh',
                            image: 'assets/images/nabeh.jpg',
                          ),
                        ),
                        Positioned(
                          right: size.width * 0.045,
                          top: size.height * 0.20,
                          child: const _BenchPortrait(
                            name: 'Julia',
                            image: 'assets/images/julia.jpg',
                          ),
                        ),
                        Positioned(
                          left: size.width * 0.37,
                          top: size.height * 0.43,
                          child: const _PathHint(),
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
                            onPanUpdate: (details) => _movePlayer(details, size),
                            child: const _PlayerLight(),
                          ),
                        ),
                        if (completed)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.68),
                              padding: const EdgeInsets.all(22),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: AppTheme.pink.withValues(alpha: 0.65),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          'assets/images/together.jpg',
                                          height: 125,
                                          width: 190,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.favorite,
                                            color: AppTheme.pink,
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        'The first step toward hello.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Two separate benches. One little light crossing the distance. This is where our story begins.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white70, height: 1.4),
                                      ),
                                      const SizedBox(height: 16),
                                      FilledButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('BACK TO OUR STORY'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.touch_app, color: AppTheme.gold, size: 19),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'DRAG THE LITTLE LIGHT FROM NABEH TOWARD JULIA’S HEART',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 9,
                        letterSpacing: .7,
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

class _CampusBackdrop extends StatelessWidget {
  const _CampusBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF263E49), Color(0xFF315044), Color(0xFF172F35)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, height: 90,
            child: Container(color: const Color(0xFFEDB879).withValues(alpha: .12))),
          Positioned(top: 105, left: -35, child: _Tree(size: 120)),
          Positioned(top: 35, right: -28, child: _Tree(size: 145)),
          Positioned(bottom: 0, left: 0, right: 0, height: 115,
            child: Container(color: const Color(0xFF172D31).withValues(alpha: .45))),
          Positioned.fill(
            child: CustomPaint(painter: _CampusPathPainter()),
          ),
          const Positioned(
            top: 12, right: 14,
            child: Text('DAMASCUS UNIVERSITY',
              style: TextStyle(color: Colors.white54, fontSize: 9, letterSpacing: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _Tree extends StatelessWidget {
  const _Tree({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => Icon(
    Icons.park_rounded, size: size,
    color: const Color(0xFF142F2D).withValues(alpha: .75),
  );
}

class _CampusPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5B98D).withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 34
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * .12, size.height * .82)
      ..cubicTo(size.width * .42, size.height * .65,
          size.width * .50, size.height * .48,
          size.width * .83, size.height * .20);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BenchPortrait extends StatelessWidget {
  const _BenchPortrait({required this.name, required this.image});
  final String name;
  final String image;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.gold.withValues(alpha: .85), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 12)],
        ),
        child: CircleAvatar(
          radius: 31,
          backgroundColor: AppTheme.surface,
          backgroundImage: AssetImage(image),
        ),
      ),
      const SizedBox(height: 5),
      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black, blurRadius: 5)])),
      const Icon(Icons.chair_alt_rounded, color: Color(0xFFD9B88B), size: 25),
    ],
  );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.text, required this.alignRight});
  final String text;
  final bool alignRight;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 170),
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xE9221930),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withValues(alpha: .12)),
    ),
    child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white70, height: 1.3)),
  );
}

class _PathHint extends StatelessWidget {
  const _PathHint();
  @override
  Widget build(BuildContext context) => const Column(
    children: [
      Icon(Icons.chat_bubble_outline, color: Colors.white60, size: 20),
      SizedBox(height: 4),
      Text('a message…', style: TextStyle(color: Colors.white54, fontSize: 9)),
    ],
  );
}

class _PlayerLight extends StatelessWidget {
  const _PlayerLight();
  @override
  Widget build(BuildContext context) => Container(
    width: 54, height: 54,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppTheme.gold.withValues(alpha: .18),
      boxShadow: const [BoxShadow(color: AppTheme.gold, blurRadius: 25, spreadRadius: 2)],
    ),
    child: const Icon(Icons.wb_sunny_rounded, color: AppTheme.gold, size: 29),
  );
}

class _HeartTarget extends StatelessWidget {
  const _HeartTarget({required this.completed});
  final bool completed;
  @override
  Widget build(BuildContext context) => Container(
    width: 58, height: 58,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppTheme.pink.withValues(alpha: .20),
      boxShadow: const [BoxShadow(color: AppTheme.pink, blurRadius: 27, spreadRadius: 4)],
    ),
    child: Icon(completed ? Icons.favorite : Icons.favorite_border,
      color: Colors.white, size: 34),
  );
}
