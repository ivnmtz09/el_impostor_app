import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/presentation/screens/game_result_screen.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:flutter/material.dart';

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
  String? _selectedPlayerName; // El nombre del jugador seleccionado para votar

  void _confirmVote() {
    if (_selectedPlayerName == null) return;

    // Busca el PlayerRole del jugador votado
    final PlayerRole votedPlayer = widget.playerRoles
        .firstWhere((role) => role.name == _selectedPlayerName);

    // Navega a la pantalla de resultados
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameResultScreen(
          playerRoles: widget.playerRoles,
          votedPlayer: votedPlayer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoSecundario,
      appBar: AppBar(
        title: const Text('VOTACIÓN'),
        backgroundColor: AppColors.fondoSecundario,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '¿Quién creen que es el impostor?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // --- Cuadrícula de Jugadores ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5, // Hace los botones más anchos que altos
              ),
              itemCount: widget.playerRoles.length,
              itemBuilder: (context, index) {
                final playerName = widget.playerRoles[index].name;
                final bool isSelected = _selectedPlayerName == playerName;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlayerName = playerName;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.acentoCTA
                          : AppColors.fondoPrincipal,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        playerName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.textoBoton
                              : AppColors.textoPrincipal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // --- Botón de Confirmar Voto ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.acentoCTA,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                // El botón se deshabilita si nadie ha sido seleccionado
                disabledBackgroundColor: Colors.grey[600],
              ),
              onPressed: _selectedPlayerName != null ? _confirmVote : null,
              child: Text(
                'CONFIRMAR VOTO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _selectedPlayerName != null
                      ? AppColors.textoBoton
                      : Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
