import 'dart:math';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/models/word_model.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/presentation/screens/debate_timer_screen.dart';
import 'package:flutter/material.dart';

class PlayerRole {
  final String name;
  final bool isImpostor;
  final String word;
  final String hint;

  PlayerRole({
    required this.name,
    required this.isImpostor,
    required this.word,
    required this.hint,
  });
}

class RoleRevealScreen extends StatefulWidget {
  final List<String> playerNames;
  final int impostorCount;
  final int debateTimeMinutes;
  final bool impostorHint;
  final Word secretWord;

  const RoleRevealScreen({
    super.key,
    required this.playerNames,
    required this.impostorCount,
    required this.debateTimeMinutes,
    required this.impostorHint,
    required this.secretWord,
  });

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen>
    with SingleTickerProviderStateMixin {
  late List<PlayerRole> _assignedRoles;
  int _currentPlayerIndex = 0;
  bool _isCardRevealed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _assignRoles();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _assignRoles() {
    List<String> players = List.from(widget.playerNames)..shuffle();
    List<PlayerRole> roles = [];

    for (int i = 0; i < players.length; i++) {
      bool isImpostor = i < widget.impostorCount;
      roles.add(PlayerRole(
        name: players[i],
        isImpostor: isImpostor,
        word: widget.secretWord.palabra,
        hint: widget.secretWord.pista,
      ));
    }
    roles.shuffle();
    _assignedRoles = roles;
  }

  void _nextPlayer() {
    FeedbackService.lightVibration();
    setState(() {
      if (_currentPlayerIndex < _assignedRoles.length - 1) {
        _currentPlayerIndex++;
        _isCardRevealed = false;
      } else {
        _goToDebate();
      }
    });
  }

  void _goToDebate() {
    FeedbackService.mediumVibration();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DebateTimerScreen(
          playerRoles: _assignedRoles,
          debateTimeMinutes: widget.debateTimeMinutes,
        ),
      ),
    );
  }

  void _revealCard() {
    setState(() => _isCardRevealed = true);
    _animationController.forward(from: 0.0);

    final PlayerRole currentPlayer = _assignedRoles[_currentPlayerIndex];
    if (currentPlayer.isImpostor) {
      FeedbackService.impostorRevealVibration();
    } else {
      FeedbackService.playerRevealVibration();
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlayerRole currentPlayer = _assignedRoles[_currentPlayerIndex];
    final bool isLastPlayer = _currentPlayerIndex == _assignedRoles.length - 1;

    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      appBar: AppBar(
        title: Text(
            'Jugador ${_currentPlayerIndex + 1} de ${_assignedRoles.length}'),
        backgroundColor: AppColors.fondoPrincipal,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mensaje superior con animación
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(_currentPlayerIndex),
                children: [
                  Text(
                    currentPlayer.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.acentoCTA,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¡Es tu turno!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textoPrincipal,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Toca para ver tu rol en secreto',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoSecundario,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 60),

            // Tarjeta DISCRETA con colores sutiles
            GestureDetector(
              onTap: _isCardRevealed ? null : _revealCard,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 320,
                decoration: BoxDecoration(
                  // Colores discretos según el rol
                  color: _isCardRevealed
                      ? (currentPlayer.isImpostor
                          ? AppColors.impostorBg
                          : AppColors.playerBg)
                      : AppColors.fondoSecundario,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isCardRevealed
                        ? (currentPlayer.isImpostor
                            ? AppColors.impostorBorder
                            : AppColors.playerBorder)
                        : AppColors.acentoCTA.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_isCardRevealed
                              ? (currentPlayer.isImpostor
                                  ? AppColors.impostorBorder
                                  : AppColors.playerBorder)
                              : AppColors.acentoCTA)
                          .withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: _isCardRevealed
                      ? ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildRoleCard(currentPlayer),
                        )
                      : _buildHiddenCard(),
                ),
              ),
            ),
            const SizedBox(height: 60),

            // Botón siguiente
            AnimatedOpacity(
              opacity: _isCardRevealed ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.acentoCTA,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: _isCardRevealed ? 8 : 0,
                ),
                onPressed: _isCardRevealed ? _nextPlayer : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastPlayer ? 'EMPEZAR JUEGO' : 'SIGUIENTE JUGADOR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isCardRevealed
                            ? AppColors.textoBoton
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastPlayer ? Icons.play_arrow : Icons.arrow_forward,
                      color: _isCardRevealed
                          ? AppColors.textoBoton
                          : Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Icon(
            Icons.touch_app_outlined,
            color: AppColors.acentoCTA,
            size: 80,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'TOCA PARA REVELAR',
          style: TextStyle(
            color: AppColors.acentoCTA,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard(PlayerRole role) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ERES:',
            style: TextStyle(
              color: AppColors.textoSecundario.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Icono discreto
          Icon(
            role.isImpostor ? Icons.person_off_outlined : Icons.person_outlined,
            color:
                role.isImpostor ? AppColors.impostorText : AppColors.playerText,
            size: 40,
          ),
          const SizedBox(height: 12),

          // Texto del rol con colores discretos
          Text(
            role.isImpostor ? 'IMPOSTOR' : 'NO-IMPOSTOR',
            style: TextStyle(
              color: role.isImpostor
                  ? AppColors.impostorText
                  : AppColors.playerText,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Separador sutil
          Container(
            height: 1,
            width: 100,
            color: AppColors.textoSecundario.withOpacity(0.3),
          ),
          const SizedBox(height: 24),

          // Pista o palabra
          Text(
            role.isImpostor
                ? (widget.impostorHint ? 'TU PISTA:' : 'Sin pista')
                : 'LA PALABRA:',
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Contenedor con el texto principal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.fondoSecundario.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: role.isImpostor
                    ? AppColors.impostorBorder
                    : AppColors.playerBorder,
                width: 1,
              ),
            ),
            child: Text(
              role.isImpostor
                  ? (widget.impostorHint ? role.hint : '¡Descúbrela!')
                  : role.word,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
