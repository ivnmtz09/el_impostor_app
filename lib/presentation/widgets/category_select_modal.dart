import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CategorySelectModal extends StatefulWidget {
  final List<String> allCategories;
  final List<String> initiallySelectedCategories;

  const CategorySelectModal({
    super.key,
    required this.allCategories,
    required this.initiallySelectedCategories,
  });

  @override
  State<CategorySelectModal> createState() => _CategorySelectModalState();
}

class _CategorySelectModalState extends State<CategorySelectModal> {
  // Una lista local para guardar las selecciones temporales
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    // Copia la lista inicial
    _selectedCategories = List.from(widget.initiallySelectedCategories);
  }

  void _onCategoryTapped(String categoryName) {
    setState(() {
      if (_selectedCategories.contains(categoryName)) {
        // No permite deseleccionar si es la última seleccionada
        if (_selectedCategories.length > 1) {
          _selectedCategories.remove(categoryName);
        }
      } else {
        _selectedCategories.add(categoryName);
      }
    });
  }

  void _saveAndClose() {
    // Devuelve la lista actualizada a la HomeScreen
    Navigator.of(context).pop(_selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                  'Seleccionar Categorías',
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
          // --- Cuadrícula de Categorías (Chips) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12.0, // Espacio horizontal entre chips
                runSpacing: 12.0, // Espacio vertical entre líneas
                children: widget.allCategories.map((category) {
                  final bool isSelected =
                      _selectedCategories.contains(category);
                  return ChoiceChip(
                    label: Text(category),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.textoBoton
                          : AppColors.textoPrincipal,
                      fontWeight: FontWeight.bold,
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      _onCategoryTapped(category);
                    },
                    backgroundColor: AppColors.fondoSecundario,
                    selectedColor: AppColors.acentoCTA,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.acentoCTA
                            : AppColors.textoSecundario,
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
