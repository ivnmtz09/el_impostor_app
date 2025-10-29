import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/models/word_model.dart';
import 'package:el_impostor_app/data/local/categories_data.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/widgets/category_select_modal.dart';
import 'package:el_impostor_app/presentation/widgets/player_list_modal.dart';
import 'package:el_impostor_app/presentation/widgets/rules_modal.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Estados de configuración ---
  List<Word> _allWords = []; // Lista de todas las palabras cargadas
  List<String> _categories = []; // Lista de nombres de categorías únicos
  List<String> _playerNames = ['Jugador 1', 'Jugador 2', 'Jugador 3'];
  double _impostorCount = 1.0;
  double _debateTime = 3.0;
  bool _soundEffects = true;
  bool _vibration = true;
  bool _impostorHint = true;
  List<String> _selectedCategories = []; // Categorías seleccionadas

  @override
  void initState() {
    super.initState();
    _loadGameData();
  }

  // Carga y parsea los datos del JSON
  void _loadGameData() {
    // --- ESTA ES LA LÍNEA CORREGIDA ---
    _allWords = allWordsFromJson(allWordsData);
    // ----------------------------------
    _categories = _allWords.map((word) => word.categoria).toSet().toList();
    if (_categories.isNotEmpty) {
      // Selecciona la primera categoría por defecto
      _selectedCategories = [_categories[0]];
    }
  }

  // --- Método para mostrar el modal de reglas ---
  void _showRulesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const RulesModal();
      },
    );
  }

  // --- Método para mostrar el modal de jugadores ---
  void _showPlayerModal(BuildContext context) async {
    final List<String>? updatedNames = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return PlayerListModal(initialPlayers: _playerNames);
      },
    );

    if (updatedNames != null && updatedNames.isNotEmpty) {
      setState(() {
        _playerNames = updatedNames;
        // Ajusta el número de impostores si es mayor que los jugadores
        if (_impostorCount >= _playerNames.length) {
          _impostorCount = (_playerNames.length - 1)
              .clamp(1.0, _playerNames.length.toDouble())
              .toDouble();
        }
      });
    }
  }

  // --- Método para mostrar el modal de categorías ---
  void _showCategoryModal(BuildContext context) async {
    final List<String>? categories = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext modalContext) => CategorySelectModal(
        allCategories: _categories,
        initiallySelectedCategories: _selectedCategories,
      ),
    );

    if (categories != null && categories.isNotEmpty) {
      setState(() => _selectedCategories = categories);
    }
  }

  // --- Método para INICIAR EL JUEGO ---
  void _startGame() {
    // 1. Filtra las palabras que pertenecen a las categorías seleccionadas
    final List<Word> categoryWords = _allWords
        .where((word) => _selectedCategories.contains(word.categoria))
        .toList();

    // 2. Control de error por si no hay palabras
    if (categoryWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text('Error: No hay palabras en las categorías seleccionadas')),
      );
      return;
    }

    // 3. Selecciona una palabra secreta al azar
    final secretWord = (categoryWords..shuffle()).first;

    // 4. Navega a la pantalla de revelación de roles
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleRevealScreen(
          playerNames: _playerNames,
          impostorCount: _impostorCount.toInt(),
          debateTimeMinutes: _debateTime.toInt(),
          impostorHint: _impostorHint,
          secretWord: secretWord,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lógica para ajustar los sliders dinámicamente
    double maxImpostors = (_playerNames.length - 1).clamp(1, 20).toDouble();
    int impostorDivisions = ((maxImpostors - 1).toInt().clamp(1, 10)).toInt();
    if (_impostorCount > maxImpostors) {
      _impostorCount = maxImpostors;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EL IMPOSTOR'),
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Tu Imagen de Impostor ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset(
                    'assets/images/impostor.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                // --- Fila de Jugadores ---
                _buildConfigRow(
                  title: 'Jugadores',
                  value: '${_playerNames.length}',
                  icon: Icons.people_outline,
                  onTap: () => _showPlayerModal(context),
                ),
                const SizedBox(height: 16),
                // --- Fila de Categorías ---
                _buildConfigRow(
                  title: 'Categorías',
                  value: '${_selectedCategories.length} seleccionadas',
                  icon: Icons.category_outlined,
                  onTap: () => _showCategoryModal(context),
                ),
                const SizedBox(height: 16),
                // --- Slider de Impostores ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildSliderRow(
                    'Impostores',
                    _impostorCount,
                    1.0,
                    maxImpostors,
                    impostorDivisions,
                    (newValue) => setState(() => _impostorCount = newValue),
                  ),
                ),
                const SizedBox(height: 16),
                // --- Slider de Tiempo ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildSliderRow(
                    'Tiempo de Debate (min)',
                    _debateTime,
                    1.0,
                    10.0,
                    9,
                    (newValue) => setState(() => _debateTime = newValue),
                  ),
                ),
                const SizedBox(height: 16),
                // --- Switch de Pista ---
                SwitchListTile(
                  title: const Text('Pista para Impostores',
                      style: TextStyle(
                          color: AppColors.textoPrincipal, fontSize: 18)),
                  value: _impostorHint,
                  onChanged: (bool value) =>
                      setState(() => _impostorHint = value),
                  activeColor: AppColors.acentoCTA,
                  inactiveTrackColor: Colors.grey[700],
                  tileColor: AppColors.fondoSecundario,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  secondary: const Icon(Icons.lightbulb_outline,
                      color: AppColors.textoPrincipal),
                ),
                // Espacio para que el botón de abajo no tape
                const SizedBox(height: 120),
              ],
            ),
          ),
          // --- Botón de Iniciar Juego (fijo abajo) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              color: AppColors.fondoPrincipal
                  .withOpacity(0.9), // Fondo con transparencia
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.acentoCTA,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _startGame, // Llama a la función de navegación
                child: const Text(
                  'INICIAR JUEGO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoBoton,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.fondoDrawer,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.fondoPrincipal,
            ),
            child: Text(
              'Configuración',
              style: TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Efectos de Sonido',
                style: TextStyle(color: AppColors.textoPrincipal)),
            value: _soundEffects,
            onChanged: (bool value) => setState(() => _soundEffects = value),
            activeColor: AppColors.acentoCTA,
            inactiveTrackColor: Colors.grey[700],
          ),
          SwitchListTile(
            title: const Text('Vibración',
                style: TextStyle(color: AppColors.textoPrincipal)),
            value: _vibration,
            onChanged: (bool value) => setState(() => _vibration = value),
            activeColor: AppColors.acentoCTA,
            inactiveTrackColor: Colors.grey[700],
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading:
                const Icon(Icons.help_outline, color: AppColors.textoPrincipal),
            title: const Text('Cómo Jugar',
                style: TextStyle(color: AppColors.textoPrincipal)),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              _showRulesModal(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined,
                color: AppColors.textoPrincipal),
            title: const Text('Volver al Inicio',
                style: TextStyle(color: AppColors.textoPrincipal)),
            onTap: () => Navigator.pop(context), // Cierra el drawer
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max,
      int divisions, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toInt()}',
          style: const TextStyle(color: AppColors.textoPrincipal, fontSize: 18),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toInt().toString(),
          activeColor: AppColors.acentoCTA,
          inactiveColor: Colors.grey[700],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildConfigRow(
      {required String title,
      required String value,
      IconData? icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.fondoSecundario,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.textoPrincipal, size: 22),
              const SizedBox(width: 16),
            ],
            Text(title,
                style: const TextStyle(
                    color: AppColors.textoPrincipal, fontSize: 18)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textoSecundario, fontSize: 16)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textoSecundario, size: 16),
          ],
        ),
      ),
    );
  }
}
