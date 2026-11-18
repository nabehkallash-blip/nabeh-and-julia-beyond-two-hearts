import 'package:flutter/material.dart';
import 'music/music_controller.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class NabehAndJuliaApp extends StatefulWidget {
  const NabehAndJuliaApp({super.key});
  @override
  State<NabehAndJuliaApp> createState() => _NabehAndJuliaAppState();
}

class _NabehAndJuliaAppState extends State<NabehAndJuliaApp> {
  @override
  void initState() {
    super.initState();
    MusicController.start();
  }

  @override
  void dispose() {
    MusicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Nabeh & Julia: Beyond Two Hearts',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: const LaunchScreen(),
  );
}


class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});
  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  bool _showHome = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) setState(() => _showHome = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showHome) return const HomeScreen();
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF332044), Color(0xFF100D20), Color(0xFF102B3A)],
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: .48,
            child: Image.asset(
              'assets/images/together.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x22100D20), Color(0xEE100D20)],
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFD58A), width: 2),
                      boxShadow: const [
                        BoxShadow(color: Color(0x66FF78B7), blurRadius: 32, spreadRadius: 4),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFF211832),
                      child: Icon(Icons.favorite_rounded, color: Color(0xFFFF78B7), size: 58),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'NABEH  &  JULIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, letterSpacing: 2.1, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'BEYOND TWO HEARTS',
                    style: TextStyle(color: Color(0xFFFFD58A), fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 34),
                  const SizedBox(
                    width: 110,
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF78B7)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('A STORY MADE FOR TWO', style: TextStyle(color: Colors.white60, fontSize: 9, letterSpacing: 2)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
