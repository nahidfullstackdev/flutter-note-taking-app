import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:students_note_app/theme/dark_mode.dart';
import 'package:students_note_app/theme/light_mode.dart';
import 'package:students_note_app/theme/theme_provider.dart';
import 'package:students_note_app/pages/home.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightMode,
      darkTheme: darkMode,
      home: const HomeScreen(),
    );
  }
}
