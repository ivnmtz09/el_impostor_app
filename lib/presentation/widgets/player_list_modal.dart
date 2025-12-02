import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
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
    // Verificar límite máximo de 30 jugadores
    if (_playerNames.length >= 30) {
      FeedbackService.heavyVibration();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Máximo 30 jugadores permitidos'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String newName = _nameController.text.trim();
    if (newName.isEmpty) {
      // Generar nombre único si está vacío
      int counter = 1;
      String baseName = 'Jugador';
      newName = '$baseName $counter';
      while (_playerNames.contains(newName)) {
        counter++;
        newName = '$baseName $counter';
      }
    } else {
      // Verificar si el nombre ya existe (case-insensitive)
      final normalizedNewName = newName.toLowerCase();
      if (_playerNames.any((name) => name.toLowerCase() == normalizedNewName)) {
        FeedbackService.heavyVibration();
        _showDuplicateNameAlert(newName);
        return;
      }
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
        title: Text(
          'Editar Jugador',
          style: TextStyle(color: AppColors.textoPrincipal),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,

          style: TextStyle(color: AppColors.textoPrincipal),
          decoration: InputDecoration(
            labelText: 'Nombre',
            labelStyle: TextStyle(color: AppColors.textoSecundario),
            filled: true,
            fillColor: AppColors.fondoSecundario,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: AppColors.acentoCTA, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
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
              final editedName = editController.text.trim();
              if (editedName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('El nombre no puede estar vacío'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              // Verificar si el nombre ya existe (case-insensitive, excluyendo el actual)
              final normalizedEditedName = editedName.toLowerCase();
              final nameExists = _playerNames.asMap().entries.any(
                    (entry) =>
                        entry.key != index &&
                        entry.value.toLowerCase() == normalizedEditedName,
                  );

              if (nameExists) {
                FeedbackService.heavyVibration();
                // Cerrar el diálogo de edición primero si es necesario, o mostrar encima
                // En este caso, mostramos la alerta encima
                _showDuplicateNameAlert(editedName);
                return;
              }

              setState(() {
                _playerNames[index] = editedName;
              });
              Navigator.pop(context);
            },
            child: Text('Guardar',
                style: TextStyle(color: AppColors.textoBoton)),
          ),
        ],
      ),
    );
  }

  void _saveAndClose() {
    FeedbackService.playButtonTap();
    Navigator.of(context).pop(_playerNames);
  }

  void _showDuplicateNameAlert(String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.fondoDrawer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nombre Duplicado',
                style: TextStyle(
                  color: AppColors.textoPrincipal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'El nombre "$name" ya está en la lista.\nPor favor, elige otro nombre.',
                style: TextStyle(
                  color: AppColors.textoSecundario,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.acentoCTA,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: AppColors.textoBoton,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Jugadores',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_playerNames.length >= 30)
                        Text(
                          'Máximo alcanzado (30)',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.acentoCTA,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveAndClose,
                    child: Text('Guardar',
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
                          style: TextStyle(
                            color: AppColors.acentoCTA,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        _playerNames[index],
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
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
                      style: TextStyle(color: AppColors.textoPrincipal),
                      decoration: InputDecoration(
                        labelText: 'Nombre del Jugador',
                        labelStyle:
                            TextStyle(color: AppColors.textoSecundario),
                        filled: true,
                        fillColor: AppColors.fondoSecundario,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
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
                      icon: Icon(Icons.add, color: AppColors.textoBoton),
                      onPressed: _playerNames.length >= 30 ? null : _addPlayer,
                      tooltip: _playerNames.length >= 30
                          ? 'Máximo 30 jugadores'
                          : 'Agregar jugador',
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
