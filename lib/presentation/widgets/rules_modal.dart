import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RulesModal extends StatelessWidget {
  const RulesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.fondoDrawer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.acentoCTA,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline,
                      color: AppColors.textoBoton, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    '¿Cómo Jugar?',
                    style: TextStyle(
                      color: AppColors.textoBoton,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textoBoton),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRuleStep(
                      number: '1',
                      icon: Icons.settings,
                      title: 'Configuración',
                      description:
                          'Ajusta el número de jugadores, impostores y tiempo de debate.',
                    ),
                    _buildRuleStep(
                      number: '2',
                      icon: Icons.phone_android,
                      title: 'Reparte los Roles',
                      description:
                          'Pasa el teléfono para que cada jugador vea su rol en secreto.',
                    ),
                    _buildRuleStep(
                      number: '3',
                      icon: Icons.visibility_off,
                      title: 'Palabra Secreta',
                      description:
                          'Los NO-impostores reciben una palabra. Los impostores reciben una pista (o nada).',
                    ),
                    _buildRuleStep(
                      number: '4',
                      icon: Icons.chat_bubble_outline,
                      title: 'Debate',
                      description:
                          'Por turnos, cada jugador dice una palabra relacionada. ¡El impostor debe fingir!',
                    ),
                    _buildRuleStep(
                      number: '5',
                      icon: Icons.how_to_vote,
                      title: 'Votación',
                      description: 'Voten por quién creen que es el impostor.',
                    ),
                    _buildRuleStep(
                      number: '6',
                      icon: Icons.emoji_events,
                      title: 'Victoria',
                      description:
                          'Impostores ganan si no los descubren o adivinan la palabra. No-impostores ganan si atrapan al impostor.',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.acentoCTA,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '¡ENTENDIDO!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoBoton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleStep({
    required String number,
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.acentoCTA,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: AppColors.textoBoton,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.acentoCTA, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textoSecundario,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
