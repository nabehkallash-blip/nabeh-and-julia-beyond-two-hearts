import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Chapter 6 is a separate Flame-powered action sequence. The rest of the
/// story continues to use its existing Flutter screens.
class ChapterSixEngineScreen extends StatefulWidget {
  const ChapterSixEngineScreen({super.key});

  @override
  State<ChapterSixEngineScreen> createState() => _ChapterSixEngineScreenState();
}

class _ChapterSixEngineScreenState extends State<ChapterSixEngineScreen> {
  late final ChapterSixFlameGame game;

  @override
  void initState() {
    super.initState();
    game = ChapterSixFlameGame(onWin: _finish);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _finish() {
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101522),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget<ChapterSixFlameGame>(game: game),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close),
                      ),
                      const SizedBox(width: 8),
                      const Text('BEYOND TWO HEARTS',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2)),
                      const Spacer(),
                      ValueListenableBuilder<int>(
                        valueListenable: game.health,
                        builder: (_, value, __) => Row(
                          children: List.generate(
                            3,
                            (i) => Icon(Icons.favorite,
                                color: i < value
                                    ? const Color(0xFFFF719F)
                                    : Colors.white24,
                                size: 19),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: game.progress,
                        builder: (_, value, __) => Text(
                          'THREAT $value / 3',
                          style: const TextStyle(
                              color: Color(0xFFFFD58A),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: game.message,
                          builder: (_, value, __) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xCC111827),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        label: 'DODGE',
                        icon: Icons.directions_run,
                        color: const Color(0xFF347A91),
                        onPressed: game.dodge,
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        label: 'FIRE',
                        icon: Icons.bolt,
                        color: const Color(0xFFB94F72),
                        onPressed: game.fire,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        ),
      );
}

/// The first engine pass uses original procedural art. Character sprites and
/// detailed environments can replace these shapes after the mechanics test.
class ChapterSixFlameGame extends FlameGame {
  ChapterSixFlameGame({required this.onWin});

  final VoidCallback onWin;
  final ValueNotifier<int> health = ValueNotifier<int>(3);
  final ValueNotifier<int> progress = ValueNotifier<int>(0);
  final ValueNotifier<String> message =
      ValueNotifier<String>('Stay close, Julia. Watch for the warning glow.');

  double playerX = 0.22;
  double enemyX = 0.83;
  double enemyHealth = 1;
  double attackClock = 2.2;
  double muzzleFlash = 0;
  double damageFlash = 0;
  bool enemyTelegraph = false;
  bool enemyDefeated = false;
  bool finished = false;
  double worldTime = 0;

  final _paint = Paint()..isAntiAlias = true;

  @override
  Color backgroundColor() => const Color(0xFF182333);

  @override
  void update(double dt) {
    super.update(dt);
    worldTime += dt;
    if (finished) return;
    if (muzzleFlash > 0) muzzleFlash = math.max(0.0, muzzleFlash - dt * 3.5);
    if (damageFlash > 0) damageFlash = math.max(0.0, damageFlash - dt * 2.2);
    if (enemyDefeated) {
      enemyX = math.min(1.08, enemyX + dt * 0.16);
      if (enemyX >= 1.04) _spawnNext();
      return;
    }
    enemyX = math.max(0.67, enemyX - dt * 0.012);
    attackClock -= dt;
    if (attackClock <= 0) {
      if (!enemyTelegraph) {
        enemyTelegraph = true;
        attackClock = 1.35;
        message.value = 'Julia: "Nabeh, move! Incoming!"';
      } else {
        enemyTelegraph = false;
        attackClock = 2.5;
        damageFlash = 1;
        health.value = math.max(0, health.value - 1);
        message.value = health.value == 0
            ? 'You were overwhelmed. Try again.'
            : 'The attack passed. Keep moving together.';
        if (health.value == 0) {
          finished = true;
        }
      }
    }
  }

  void dodge() {
    if (finished) {
      _reset();
      return;
    }
    if (enemyTelegraph) {
      enemyTelegraph = false;
      attackClock = 2.0;
      playerX = playerX < 0.4 ? 0.43 : 0.22;
      message.value = 'Perfect dodge! Julia is right behind you.';
    } else {
      playerX = playerX < 0.4 ? 0.43 : 0.22;
      message.value = 'Keep moving. Wait for the enemy to commit.';
    }
  }

  void fire() {
    if (finished || enemyDefeated) return;
    muzzleFlash = 1;
    if (!enemyTelegraph) {
      message.value = 'Wait for the enemy to expose itself!';
      return;
    }
    enemyHealth -= 0.5;
    enemyTelegraph = false;
    attackClock = 1.8;
    if (enemyHealth <= 0) {
      enemyDefeated = true;
      progress.value = math.min(3, progress.value + 1);
      message.value = progress.value == 3
          ? 'The path is clear. Julia runs into your arms!'
          : 'Threat cleared. Stay with Julia and keep advancing.';
      if (progress.value == 3) {
        finished = true;
        Future<void>.delayed(const Duration(milliseconds: 1800), onWin);
      }
    } else {
      message.value = 'Hit! One more opening will finish this threat.';
    }
  }

  void _spawnNext() {
    enemyDefeated = false;
    enemyHealth = 1;
    enemyX = 0.83;
    attackClock = 2.0;
    message.value = 'Another threat ahead. Stay alert.';
  }

  void _reset() {
    health.value = 3;
    progress.value = 0;
    playerX = 0.22;
    enemyX = 0.83;
    enemyHealth = 1;
    attackClock = 2.2;
    enemyTelegraph = false;
    enemyDefeated = false;
    finished = false;
    message.value = 'Stay close, Julia. Watch for the warning glow.';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    // Dusk sky and distant city silhouettes.
    _rect(canvas, Rect.fromLTWH(0, 0, w, h),
        const Color(0xFF1C2C3E));
    _rect(canvas, Rect.fromLTWH(0, h * .48, w, h * .52),
        const Color(0xFF27323B));
    for (var i = 0; i < 12; i++) {
      final x = i * w / 11;
      final buildingH = h * (.12 + (i % 4) * .035);
      _rect(
        canvas,
        Rect.fromLTWH(x, h * .48 - buildingH, w / 13, buildingH),
        const Color(0xFF172330),
      );
      for (var j = 0; j < 3; j++) {
        _rect(
          canvas,
          Rect.fromLTWH(x + 5 + j * 9, h * .48 - buildingH + 12, 3, 4),
          const Color(0x557FA5B9),
        );
      }
    }
    // Dusty road with perspective lines.
    final road = Path()
      ..moveTo(w * .12, h)
      ..lineTo(w * .34, h * .48)
      ..lineTo(w * .82, h * .48)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(road, _paint..color = const Color(0xFF46505A));
    for (var i = 0; i < 5; i++) {
      final y = h * (.62 + i * .09);
      canvas.drawLine(Offset(w * .3, y), Offset(w * .95, y),
          _paint..color = const Color(0x227F8992)..strokeWidth = 2);
    }
    // Cover objects.
    _drawCrate(canvas, w * .57, h * .72, w * .09, h * .16);
    _drawCrate(canvas, w * .88, h * .66, w * .07, h * .13);

    // Julia stays a little behind the playable character.
    _drawCharacter(canvas, w * (playerX - .10), h * .73, h * .23,
        const Color(0xFFB66B83), false, false);
    _drawCharacter(canvas, w * playerX, h * .70, h * .31,
        const Color(0xFF315D78), true, false);

    if (!enemyDefeated) {
      if (enemyTelegraph) {
        canvas.drawCircle(
          Offset(w * enemyX, h * .70),
          h * (.12 + .015 * math.sin(worldTime * 12).abs()),
          _paint..color = const Color(0x55FF704F),
        );
      }
      _drawCharacter(canvas, w * enemyX, h * .69, h * .29,
          const Color(0xFF6C5550), true, true);
    }
    if (muzzleFlash > 0) {
      canvas.drawCircle(Offset(w * (playerX + .055), h * .68),
          h * .045 * muzzleFlash, _paint..color = const Color(0xFFFFD58A));
      canvas.drawCircle(Offset(w * (playerX + .055), h * .68),
          h * .075 * muzzleFlash, _paint..color = const Color(0x44FFB45E));
    }
    if (damageFlash > 0) {
      _rect(canvas, Rect.fromLTWH(0, 0, w, h),
          Color.fromRGBO(255, 70, 70, damageFlash * .16));
    }
    if (finished && progress.value < 3) {
      _rect(canvas, Rect.fromLTWH(0, 0, w, h),
          const Color(0x990B1020));
      _drawCenteredText(canvas, 'YOU WERE HIT', w / 2, h * .45,
          h * .07, Colors.white);
      _drawCenteredText(canvas, 'TAP DODGE TO TRY AGAIN', w / 2, h * .55,
          h * .035, const Color(0xFFFFD58A));
    }
    if (progress.value == 3) {
      _rect(canvas, Rect.fromLTWH(0, 0, w, h),
          const Color(0x33220F27));
      _drawCenteredText(canvas, 'TOGETHER, AT LAST', w / 2, h * .34,
          h * .065, Colors.white);
    }
  }

  void _drawCharacter(Canvas canvas, double x, double ground, double height,
      Color clothes, bool armed, bool enemy) {
    final scale = height / 100;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(x, ground + 3 * scale),
          width: 48 * scale,
          height: 12 * scale),
      _paint..color = const Color(0x55000000),
    );
    // Legs and boots.
    _rect(canvas, Rect.fromLTWH(x - 15 * scale, ground - 34 * scale,
        12 * scale, 34 * scale), const Color(0xFF30343B),
        radius: 3 * scale);
    _rect(canvas, Rect.fromLTWH(x + 3 * scale, ground - 34 * scale,
        12 * scale, 34 * scale), const Color(0xFF242A32),
        radius: 3 * scale);
    // Torso with a shaded side to give a 2.5D silhouette.
    _rect(canvas, Rect.fromLTWH(x - 21 * scale, ground - 83 * scale,
        42 * scale, 53 * scale), clothes, radius: 9 * scale);
    _rect(canvas, Rect.fromLTWH(x + 7 * scale, ground - 81 * scale,
        14 * scale, 48 * scale), clothes.withOpacity(.55),
        radius: 5 * scale);
    // Head and hair/helmet.
    canvas.drawCircle(Offset(x, ground - 94 * scale), 15 * scale,
        _paint..color = const Color(0xFFC99578));
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(x, ground - 98 * scale),
          width: 31 * scale,
          height: 28 * scale),
      math.pi, math.pi, false,
      _paint
        ..color = enemy
            ? const Color(0xFF34343A)
            : const Color(0xFF30242C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8 * scale,
    );
    if (armed) {
      // Clearly fictional, simplified prop silhouette; no real-world detail.
      _rect(canvas, Rect.fromLTWH(x + 12 * scale, ground - 64 * scale,
          42 * scale, 6 * scale), const Color(0xFF20252B),
          radius: 2 * scale);
      _rect(canvas, Rect.fromLTWH(x + 25 * scale, ground - 59 * scale,
          8 * scale, 13 * scale), const Color(0xFF20252B),
          radius: 2 * scale);
    }
  }

  void _drawCrate(Canvas canvas, double x, double y, double width,
      double height) {
    _rect(canvas, Rect.fromLTWH(x, y, width, height),
        const Color(0xFF78634B), radius: 5);
    canvas.drawLine(Offset(x, y), Offset(x + width, y + height),
        _paint..color = const Color(0xFFB08D65)..strokeWidth = 3);
    canvas.drawLine(Offset(x + width, y), Offset(x, y + height),
        _paint..color = const Color(0xFFB08D65)..strokeWidth = 3);
  }

  void _rect(Canvas canvas, Rect rect, Color color, {double radius = 0}) {
    final p = _paint..color = color..style = PaintingStyle.fill;
    if (radius > 0) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(radius)), p);
    } else {
      canvas.drawRect(rect, p);
    }
  }

  void _drawCenteredText(Canvas canvas, String text, double x, double y,
      double fontSize, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(x - painter.width / 2, y - painter.height / 2));
  }
}
