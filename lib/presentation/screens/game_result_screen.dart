import 'package:confetti/confetti.dart';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/widgets/animated_button.dart';
import 'package:flutter/material.dart';

class GameResultScreen extends StatefulWidget {
  final List<PlayerRole> playerRoles;
  final PlayerRole votedPlayer; // El jugador que fue votado

  const GameResultScreen({
    super.key,
    required this.playerRoles,
    required this.votedPlayer,
  });

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Esperar a que el widget esté completamente montado antes de iniciar animaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // Determinar si los honestos ganaron
      final bool impostorWasCaught = widget.votedPlayer.isImpostor;
      
      // Reproducir sonido y vibración
      if (impostorWasCaught) {
        FeedbackService.playWinSound();
        FeedbackService.victoryVibration();
        if (mounted) {
          _confettiController.play();
        }
      } else {
        FeedbackService.playLoseSound();
        FeedbackService.defeatVibration();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Verificar que el widget esté montado y tenga datos válidos
    if (widget.playerRoles.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.fondoSecundario,
        body: Center(
          child: Text(
            'Error: No hay datos de jugadores',
            style: TextStyle(color: AppColors.textoPrincipal),
          ),
        ),
      );
    }

    // --- Lógica de Victoria ---
    final bool impostorWasCaught = widget.votedPlayer.isImpostor;
    final String title;
    final String message;
    final Color resultColor;

    if (impostorWasCaught) {
      title = '¡IMPOSTOR DESCUBIERTO!';
      message = '¡Los Civiles ganan la partida!';
      resultColor = Colors.green[400]!;
    } else {
      title = '¡VOTO EQUIVOCADO!';
      message = '¡Los Impostores ganan la partida!';
      resultColor = Colors.red[400]!;
    }

    final String secretWord = widget.playerRoles.first.word;
    final String impostorNames =
        widget.playerRoles.where((r) => r.isImpostor).map((r) => r.name).join(', ');

    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
          
          // Contenido
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Título con animación (con verificación de mounted)
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut, // Cambiado de elasticOut a easeOut para evitar problemas
                  builder: (context, double value, child) {
                    if (!mounted) return const SizedBox.shrink();
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: resultColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Mensaje (con verificación de mounted)
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    if (!mounted) return const SizedBox.shrink();
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textoPrincipal,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Divider(color: Colors.white24),
                const SizedBox(height: 40),
                
                // Información con animación escalonada
                _buildInfoRow('El jugador votado fue:', widget.votedPlayer.name, 1000),
                const SizedBox(height: 20),
                _buildInfoRow('El/Los Impostor(es) era(n):', impostorNames, 1200),
                const SizedBox(height: 20),
                _buildInfoRow('La palabra secreta era:', secretWord, 1400),
                const SizedBox(height: 60),
                
                // Botón de Jugar de Nuevo (con verificación de mounted)
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1600),
                  builder: (context, double value, child) {
                    if (!mounted) return const SizedBox.shrink();
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: AnimatedButton(
                    text: 'JUGAR DE NUEVO',
                    icon: Icons.refresh,
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                    variant: AnimatedButtonVariant.primary,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, int delayMs) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: delayMs),
      builder: (context, double animValue, child) {
        if (!mounted) return const SizedBox.shrink();
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - animValue)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textoPrincipal,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
