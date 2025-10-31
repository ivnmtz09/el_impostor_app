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
      newName = 'Jugador ${_playerNames.length + 1}';
    }
    setState(() {
      _playerNames.add(newName);
    });
    _nameController.clear();
    FocusScope.of(context).unfocus();
  }

  void _removePlayer(int index) {
    setState(() {
      _playerNames.removeAt(index);
    });
  }

  void _editPlayer(int index) {
    final TextEditingController editController = TextEditingController(
      text: _playerNames[index],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.fondoDrawer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Editar Jugador',
          style: TextStyle(color: AppColors.textoPrincipal),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,
          style: const TextStyle(color: AppColors.textoPrincipal),
          decoration: InputDecoration(
            labelText: 'Nombre',
            labelStyle: const TextStyle(color: AppColors.textoSecundario),
            filled: true,
            fillColor: AppColors.fondoSecundario,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.acentoCTA, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textoSecundario)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.acentoCTA,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                setState(() {
                  _playerNames[index] = editController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar',
                style: TextStyle(color: AppColors.textoBoton)),
          ),
        ],
      ),
    );
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_playerNames);
  }

  @override
  Widget build(BuildContext context) {
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveAndClose,
                    child: const Text('Guardar',
                        style: TextStyle(color: AppColors.textoBoton)),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _playerNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.fondoSecundario,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.acentoCTA.withOpacity(0.2),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.acentoCTA,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        _playerNames[index],
                        style: const TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: AppColors.acentoCTA, size: 20),
                            onPressed: () => _editPlayer(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red, size: 20),
                            onPressed: _playerNames.length > 3
                                ? () => _removePlayer(index)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.acentoCTA, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _addPlayer(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.acentoCTA,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: AppColors.textoBoton),
                      onPressed: _addPlayer,
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
}
