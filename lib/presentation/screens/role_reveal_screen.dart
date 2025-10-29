import 'dart:math';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/models/word_model.dart';
import 'package:el_impostor_app/presentation/screens/debate_timer_screen.dart';
import 'package:flutter/material.dart';

// Modelo para guardar el rol asignado a cada jugador
class PlayerRole {
  final String name;
  final bool isImpostor;
  final String word; // La palabra secreta
  final String hint; // La pista

  PlayerRole({
    required this.name,
    required this.isImpostor,
    required this.word,
    required this.hint,
  });
}

class RoleRevealScreen extends StatefulWidget {
  // --- Datos recibidos desde HomeScreen ---
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

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  late List<PlayerRole> _assignedRoles;
  int _currentPlayerIndex = 0;
  bool _isCardRevealed = false;

  @override
  void initState() {
    super.initState();
    _assignRoles();
  }

  // Lógica para asignar los roles aleatoriamente
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
    roles.shuffle(); // Baraja los roles asignados
    _assignedRoles = roles;
  }

  // Avanza al siguiente jugador o al debate
  void _nextPlayer() {
    setState(() {
      if (_currentPlayerIndex < _assignedRoles.length - 1) {
        _currentPlayerIndex++;
        _isCardRevealed = false; // Oculta la tarjeta para el siguiente jugador
      } else {
        // Todos los jugadores han visto su rol, empieza el debate
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // Datos del jugador actual
    final PlayerRole currentPlayer = _assignedRoles[_currentPlayerIndex];
    final bool isLastPlayer = _currentPlayerIndex == _assignedRoles.length - 1;

    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      appBar: AppBar(
        title: Text(
            'Jugador ${_currentPlayerIndex + 1} de ${_assignedRoles.length}'),
        backgroundColor: AppColors.fondoSecundario,
        automaticallyImplyLeading: false, // Oculta la flecha de "atrás"
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Mensaje Superior ---
            Text(
              '${currentPlayer.name}, ¡es tu turno!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mira tu rol en secreto y pasa el teléfono.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoSecundario,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 60),

            // --- La Tarjeta Deslizable/Táctil ---
            GestureDetector(
              onTap: () => setState(() => _isCardRevealed = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 300,
                decoration: BoxDecoration(
                  color: _isCardRevealed
                      ? AppColors.fondoPrincipal
                      : AppColors.acentoCTA,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isCardRevealed
                        ? AppColors.acentoCTA
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: _isCardRevealed
                      ? _buildRoleCard(currentPlayer) // Muestra el rol
                      : _buildHiddenCard(), // Muestra "Toca para ver"
                ),
              ),
            ),
            const SizedBox(height: 60),

            // --- Botón de Siguiente ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acentoCTA,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              // El botón solo se activa si la tarjeta fue revelada
              onPressed: _isCardRevealed ? _nextPlayer : null,
              child: Text(
                isLastPlayer ? 'EMPEZAR JUEGO' : 'SIGUIENTE JUGADOR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      _isCardRevealed ? AppColors.textoBoton : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la tarjeta oculta
  Widget _buildHiddenCard() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.touch_app_outlined,
          color: AppColors.textoBoton,
          size: 60,
        ),
        SizedBox(height: 16),
        Text(
          'TOCA PARA REVELAR',
          style: TextStyle(
            color: AppColors.textoBoton,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget para la tarjeta que muestra el rol
  Widget _buildRoleCard(PlayerRole role) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ERES:',
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            role.isImpostor ? 'EL IMPOSTOR' : 'NO-IMPOSTOR',
            style: TextStyle(
              color: role.isImpostor ? Colors.red[400] : Colors.green[400],
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white24),
          const SizedBox(height: 30),
          Text(
            role.isImpostor
                ? (widget.impostorHint ? 'LA PISTA ES:' : 'No tienes pista')
                : 'LA PALABRA ES:',
            style: const TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            role.isImpostor
                ? (widget.impostorHint ? role.hint : '¡Descúbrela!')
                : role.word,
            style: const TextStyle(
              color: AppColors.textoPrincipal,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
