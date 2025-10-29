import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:flutter/material.dart';

class GameResultScreen extends StatelessWidget {
  final List<PlayerRole> playerRoles;
  final PlayerRole votedPlayer; // El jugador que fue votado

  const GameResultScreen({
    super.key,
    required this.playerRoles,
    required this.votedPlayer,
  });

  @override
  Widget build(BuildContext context) {
    // --- Lógica de Victoria ---
    final bool impostorWasCaught = votedPlayer.isImpostor;
    final String title;
    final String message;
    final Color resultColor;

    if (impostorWasCaught) {
      title = '¡IMPOSTOR DESCUBIERTO!';
      message = '¡Los No-Impostores ganan la partida!';
      resultColor = Colors.green[400]!;
    } else {
      title = '¡VOTO EQUIVOCADO!';
      message = '¡Los Impostores ganan la partida!';
      resultColor = Colors.red[400]!;
    }

    final String secretWord = playerRoles.first.word;
    final String impostorNames =
        playerRoles.where((r) => r.isImpostor).map((r) => r.name).join(', ');

    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: resultColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.white24),
            const SizedBox(height: 40),
            Text(
              'El jugador votado fue:',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoSecundario, fontSize: 16),
            ),
            Text(
              votedPlayer.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoPrincipal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'El/Los Impostor(es) era(n):',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoSecundario, fontSize: 16),
            ),
            Text(
              impostorNames,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoPrincipal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'La palabra secreta era:',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoSecundario, fontSize: 16),
            ),
            Text(
              secretWord,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textoPrincipal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            // --- Botón de Jugar de Nuevo ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acentoCTA,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Regresa a la HomeScreen, eliminando todas las pantallas anteriores
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'JUGAR DE NUEVO',
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
