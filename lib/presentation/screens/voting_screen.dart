import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/presentation/widgets/animated_button.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/screens/game_result_screen.dart';

class VotingScreen extends StatefulWidget {
  final List<PlayerRole> playerRoles;

  const VotingScreen({
    super.key,
    required this.playerRoles,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late ConfettiController _confettiController;
  PlayerRole? _selectedPlayer;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _vote() {
    if (_selectedPlayer == null) return;

    FeedbackService.playVoteSubmit();
    FeedbackService.mediumVibration();

    // Navegar a pantalla de resultados
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameResultScreen(
          playerRoles: widget.playerRoles,
          votedPlayer: _selectedPlayer!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),

          // Contenido principal
          Column(
            children: [
              const SizedBox(height: 40),
              // Imagen decorativa
              Image.asset(
                'assets/images/secret_file.png',
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                '¡HORA DE VOTAR!',
                style: TextStyle(
                  color: AppColors.acentoCTA,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Lista de jugadores
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: widget.playerRoles.length,
                  itemBuilder: (context, index) {
                    final playerRole = widget.playerRoles[index];
                    final isSelected = playerRole == _selectedPlayer;
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        transform: Matrix4.identity()
                          ..scale(isSelected ? 1.05 : 1.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() => _selectedPlayer = playerRole);
                              FeedbackService.playButtonTap();
                              FeedbackService.lightVibration();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.acentoCTA.withOpacity(0.2)
                                    : AppColors.fondoSecundario,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.acentoCTA
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.acentoCTA
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: isSelected
                                        ? AppColors.acentoCTA
                                        : AppColors.textoPrincipal,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    playerRole.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.acentoCTA
                                          : AppColors.textoPrincipal,
                                      fontSize: 18,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Botón de votar
              Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedButton(
                  text: 'VOTAR',
                  icon: Icons.how_to_vote,
                  onPressed: _vote,
                  enabled: _selectedPlayer != null,
                  variant: AnimatedButtonVariant.primary,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
