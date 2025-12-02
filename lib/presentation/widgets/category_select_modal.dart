import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
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
    FeedbackService.playButtonTap();
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
    FeedbackService.playButtonTap();
    // Devuelve la lista actualizada a la HomeScreen
    Navigator.of(context).pop(_selectedCategories);
  }

  // Mapa de imágenes por categoría (puedes actualizar las rutas cuando tengas las imágenes)
  final Map<String, String> _categoryImages = {
    'Animales': 'assets/images/animales.png',
    'Películas y Cine': 'assets/images/cine.png',
    'Hogar': 'assets/images/hogar.png',
    'Escuela / Universidad': 'assets/images/escuela.png',
    'Lugares': 'assets/images/lugares.png',
    'Comida': 'assets/images/comida.png',
    'Cosas Cotidianas': 'assets/images/cotidianas.png',
    'Celebridades': 'assets/images/celebridades.png',
    'Personajes de Cine y TV': 'assets/images/personajes.png',
    'Series y TV': 'assets/images/series.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Aumentado para ver mejor el grid
      decoration: BoxDecoration(
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
                Text(
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
                  child: Text('Guardar',
                      style: TextStyle(color: AppColors.textoBoton)),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          // --- Cuadrícula de Categorías ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1, // Ajusta la proporción de las tarjetas
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: widget.allCategories.length,
                itemBuilder: (context, index) {
                  final category = widget.allCategories[index];
                  final isSelected = _selectedCategories.contains(category);
                  
                  return GestureDetector(
                    onTap: () => _onCategoryTapped(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: AppColors.fondoSecundario,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.acentoCTA : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Imagen de fondo (o placeholder)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[800], // Fondo por si no carga la imagen
                              child: _buildCategoryImage(category),
                            ),
                          ),
                          
                          // Overlay oscuro para mejorar legibilidad del texto
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),

                          // Checkbox indicador
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.acentoCTA : Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: isSelected ? Colors.white : Colors.transparent,
                              ),
                            ),
                          ),

                          // Nombre de la categoría
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryImage(String category) {
    // Intenta cargar la imagen si está definida en el mapa
    if (_categoryImages.containsKey(category)) {
      return Image.asset(
        _categoryImages[category]!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Si falla la carga, muestra un icono
          return Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white24,
              size: 40,
            ),
          );
        },
      );
    }
    
    // Placeholder por defecto si no hay imagen asignada
    return Center(
      child: Icon(
        Icons.category_outlined,
        color: Colors.white24,
        size: 40,
      ),
    );
  }
}

