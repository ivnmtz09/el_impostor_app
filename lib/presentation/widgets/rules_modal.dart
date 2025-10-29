import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RulesModal extends StatelessWidget {
  const RulesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.fondoDrawer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: const Text(
        'Cómo Jugar',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textoPrincipal,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Configura la partida con tus amigos.',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. Pasa el teléfono para que cada jugador reciba su rol en secreto.',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. Si NO eres el impostor, recibirás una palabra secreta.',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4. Si ERES el impostor, recibirás una pista (o nada).',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5. Empieza el debate. Cada jugador debe decir una palabra relacionada con la palabra secreta. El impostor debe fingir y decir una palabra convincente.',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '6. Voten para eliminar al jugador que crean que es el impostor.',
              style: TextStyle(color: AppColors.textoPrincipal, fontSize: 16),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '¡ENTENDIDO!',
            style: TextStyle(
              color: AppColors.acentoCTA,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
