import 'dart:async';
import 'dart:math';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
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

class _DebateTimerScreenState extends State<DebateTimerScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late String _startingPlayer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showWarning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.debateTimeMinutes * 60;
    _startingPlayer = _selectRandomPlayer();
    _startTimer();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _selectRandomPlayer() {
    final random = Random();
    return widget.playerRoles[random.nextInt(widget.playerRoles.length)].name;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);

        // Timer tick de 59s a 11s
        if (_remainingSeconds >= 11 && _remainingSeconds <= 59) {
          FeedbackService.playTimerTick();
        }

        // Timer warning de 10s a 1s
        if (_remainingSeconds >= 1 && _remainingSeconds <= 10) {
          FeedbackService.playTimerWarning();
        }
      } else {
        timer.cancel();
        _navigateToVoting();
      }
    });
  }

  void _navigateToVoting() {
    _timer.cancel();
    FeedbackService.mediumVibration();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VotingScreen(
          playerRoles: widget.playerRoles,
        ),
      ),
    );
  }

  String _formatTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getTimeColor() {
    if (_remainingSeconds <= 10) return Colors.red[400]!;
    if (_remainingSeconds <= 30) return Colors.orange[400]!;
    return AppColors.acentoCTA;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      appBar: AppBar(
        title: const Text('DEBATE'),
        backgroundColor: AppColors.fondoSecundario,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              FeedbackService.playButtonTap();
              FeedbackService.lightVibration();
              _showDebateInfo();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título animado
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: const Text(
                '¡Hablen y encuentren al impostor!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textoPrincipalDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Jugador que empieza
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.fondoPrincipal,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.acentoCTA, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Empieza:',
                    style: TextStyle(
                      color: AppColors.textoSecundarioDark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        color: AppColors.acentoCTADark,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _startingPlayer,
                        style: const TextStyle(
                          color: AppColors.acentoCTADark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Timer circular con animación
            ScaleTransition(
              scale: _remainingSeconds <= 10
                  ? _pulseAnimation
                  : const AlwaysStoppedAnimation(1.0),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getTimeColor(),
                    width: 8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getTimeColor().withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _formatTime(),
                    style: TextStyle(
                      color: _getTimeColor(),
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Advertencia de tiempo
            if (_showWarning)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, double value, child) {
                    return Opacity(opacity: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber,
                            color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '¡Últimos segundos!',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 60),

            // Botón de votar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acentoCTA,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 8,
              ),
              onPressed: () {
                FeedbackService.playButtonTap();
                FeedbackService.mediumVibration();
                _navigateToVoting();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.how_to_vote, color: AppColors.textoBotonDark),
                  SizedBox(width: 12),
                  Text(
                    'IR A VOTACIÓN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoBotonDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDebateInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fondoDrawer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Consejos para el Debate',
          style: TextStyle(color: AppColors.textoPrincipalDark),
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Cada jugador dice UNA palabra relacionada',
                style: TextStyle(color: AppColors.textoSecundarioDark),
              ),
              SizedBox(height: 8),
              Text(
                '• El impostor debe fingir que conoce la palabra',
                style: TextStyle(color: AppColors.textoSecundarioDark),
              ),
              SizedBox(height: 8),
              Text(
                '• Observen las reacciones de los demás',
                style: TextStyle(color: AppColors.textoSecundarioDark),
              ),
              SizedBox(height: 8),
              Text(
                '• Hagan preguntas sutiles',
                style: TextStyle(color: AppColors.textoSecundarioDark),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido',
                style: TextStyle(color: AppColors.acentoCTADark)),
          ),
        ],
      ),
    );
  }
}
