import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const LizandraTVApp());
}

class LizandraTVApp extends StatelessWidget {
  const LizandraTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lizandra TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
