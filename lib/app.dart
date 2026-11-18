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
    home: const HomeScreen(),
  );
}
