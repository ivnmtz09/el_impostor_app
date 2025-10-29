import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PlayerListModal extends StatefulWidget {
  final List<String> initialPlayers;
  const PlayerListModal({super.key, required this.initialPlayers});

  @override
  State<PlayerListModal> createState() => _PlayerListModalState();
}

class _PlayerListModalState extends State<PlayerListModal> {
  late List<String> _playerNames;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Copia la lista para poder modificarla localmente
    _playerNames = List.from(widget.initialPlayers);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    String newName = _nameController.text.trim();
    if (newName.isEmpty) {
      // Si está vacío, añade "Jugador X"
      newName = 'Jugador ${_playerNames.length + 1}';
    }
    setState(() {
      _playerNames.add(newName);
    });
    _nameController.clear();
    // Oculta el teclado
    FocusScope.of(context).unfocus();
  }

  void _removePlayer(int index) {
    setState(() {
      _playerNames.removeAt(index);
    });
  }

  void _saveAndClose() {
    // Devuelve la lista actualizada a la HomeScreen
    Navigator.of(context).pop(_playerNames);
  }

  @override
  Widget build(BuildContext context) {
    // Se ajusta al teclado
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.fondoDrawer,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // --- Título y Botón de Guardar ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Editar Jugadores',
                    style: TextStyle(
                      color: AppColors.textoPrincipal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.acentoCTA,
                    ),
                    onPressed: _saveAndClose,
                    child: const Text('Guardar',
                        style: TextStyle(color: AppColors.textoBoton)),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            // --- Lista de Jugadores ---
            Expanded(
              child: ListView.builder(
                itemCount: _playerNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person,
                        color: AppColors.textoSecundario),
                    title: Text(
                      _playerNames[index],
                      style: const TextStyle(color: AppColors.textoPrincipal),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      // No permite eliminar si solo quedan 3 jugadores
                      onPressed: _playerNames.length > 3
                          ? () => _removePlayer(index)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white24),
            // --- Campo para Añadir Jugador ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColors.textoPrincipal),
                      decoration: InputDecoration(
                        labelText: 'Nombre del Jugador',
                        labelStyle:
                            const TextStyle(color: AppColors.textoSecundario),
                        filled: true,
                        fillColor: AppColors.fondoSecundario,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addPlayer(), // Añade con "Enter"
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.acentoCTA, size: 40),
                    onPressed: _addPlayer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
