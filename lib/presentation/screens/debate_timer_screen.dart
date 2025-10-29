import 'dart:async';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/screens/voting_screen.dart';
import 'package:flutter/material.dart';

class DebateTimerScreen extends StatefulWidget {
  final List<PlayerRole> playerRoles;
  final int debateTimeMinutes;

  const DebateTimerScreen({
    super.key,
    required this.playerRoles,
    required this.debateTimeMinutes,
  });

  @override
  State<DebateTimerScreen> createState() => _DebateTimerScreenState();
}

class _DebateTimerScreenState extends State<DebateTimerScreen> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.debateTimeMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el timer si la pantalla se destruye
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _navigateToVoting(); // Navega automáticamente cuando el tiempo se acaba
      }
    });
  }

  void _navigateToVoting() {
    // Cancela el timer por si se navega manualmente
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VotingScreen(
          playerRoles: widget.playerRoles,
        ),
      ),
    );
  }

  // Formatea los segundos a "MM:SS"
  String _formatTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      appBar: AppBar(
        title: const Text('DEBATE'),
        backgroundColor: AppColors.fondoSecundario,
        automaticallyImplyLeading: false, // Sin flecha de atrás
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¡Hablen y encuentren al impostor!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // --- Círculo del Timer ---
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.acentoCTA,
                  width: 8,
                ),
              ),
              child: Center(
                child: Text(
                  _formatTime(),
                  style: const TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            // --- Botón de Votar ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acentoCTA,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _navigateToVoting,
              child: const Text(
                'IR A VOTACIÓN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoBoton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
