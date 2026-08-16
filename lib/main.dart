import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PravahaApp());
}

class PravahaApp extends StatelessWidget {
  const PravahaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pravāha — Speech Fluency Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
