import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:el_impostor_app/core/constants/app_theme.dart';
import 'package:el_impostor_app/core/providers/theme_provider.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:el_impostor_app/presentation/screens/splash_screen.dart';

class ElImpostorApp extends StatelessWidget {
  final WordRepository wordRepository;

  const ElImpostorApp({super.key, required this.wordRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'El Impostor',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(wordRepository: wordRepository),
        ),
      ),
    );
  }
}
