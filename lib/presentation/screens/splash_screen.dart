import 'dart:async';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    // Simula un tiempo de carga
    Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          // Navega a la HomeScreen reemplazando la Splash
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra tu imagen de splash.png
            Image.asset(
              'assets/images/splash.png',
              width: 200, // Ajusta el tamaño
              height: 200, // Ajusta el tamaño
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            // Muestra el spinner de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.acentoCTA),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando...',
              style: TextStyle(
                color: AppColors.textoPrincipal.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
