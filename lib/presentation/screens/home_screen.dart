import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/models/word_model.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/widgets/category_select_modal.dart';
import 'package:el_impostor_app/presentation/widgets/player_list_modal.dart';
import 'package:el_impostor_app/presentation/widgets/rules_modal.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final WordRepository wordRepository;

  const HomeScreen({super.key, required this.wordRepository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<String> _categories = [];
  List<String> _playerNames = ['Jugador 1', 'Jugador 2', 'Jugador 3'];
  double _impostorCount = 1.0;
  double _debateTime = 3.0;
  bool _soundEffects = true;
  bool _vibration = true;
  bool _impostorHint = true;
  bool _isDarkMode = true;
  List<String> _selectedCategories = [];
  bool _isLoading = true;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _loadGameData();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadGameData() async {
    try {
      final categories = await widget.wordRepository.getCategories();
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) {
          _selectedCategories = [_categories[0]];
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error al cargar datos: $e'),
          ),
        );
      }
    }
  }

  void _showRulesModal(BuildContext context) {
    FeedbackService.lightVibration();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => const RulesModal(),
    );
  }

  void _showPlayerModal(BuildContext context) async {
    FeedbackService.lightVibration();
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
        if (_impostorCount >= _playerNames.length) {
          _impostorCount = (_playerNames.length - 1)
              .clamp(1.0, _playerNames.length.toDouble())
              .toDouble();
        }
      });
    }
  }

  void _showCategoryModal(BuildContext context) async {
    FeedbackService.lightVibration();
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

  Future<void> _startGame() async {
    FeedbackService.mediumVibration();
    try {
      List<Word> categoryWords = [];
      for (String category in _selectedCategories) {
        final words = await widget.wordRepository.getWordsByCategory(category);
        categoryWords.addAll(words);
      }

      if (categoryWords.isEmpty) {
        if (mounted) {
          FeedbackService.heavyVibration();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('No hay palabras en las categorías seleccionadas'),
            ),
          );
        }
        return;
      }

      categoryWords.shuffle();
      final secretWord = categoryWords.first;

      if (mounted) {
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
    } catch (e) {
      print('Error al iniciar juego: $e');
      if (mounted) {
        FeedbackService.heavyVibration();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error al iniciar juego: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.acentoCTA),
          ),
        ),
      );
    }

    double maxImpostors = (_playerNames.length - 1).clamp(1, 20).toDouble();
    int impostorDivisions = ((maxImpostors - 1).toInt().clamp(1, 10)).toInt();
    if (_impostorCount > maxImpostors) {
      _impostorCount = maxImpostors;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EL IMPOSTOR'),
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Imagen con animación
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                      'assets/images/impostor.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Jugadores
                _buildConfigRow(
                  title: 'Jugadores',
                  value: '${_playerNames.length}',
                  icon: Icons.people_outline,
                  onTap: () => _showPlayerModal(context),
                ),
                const SizedBox(height: 16),

                // Categorías
                _buildConfigRow(
                  title: 'Categorías',
                  value: '${_selectedCategories.length} seleccionadas',
                  icon: Icons.category_outlined,
                  onTap: () => _showCategoryModal(context),
                ),
                const SizedBox(height: 16),

                // Impostores Slider
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildSliderRow(
                    'Impostores',
                    _impostorCount,
                    1.0,
                    maxImpostors,
                    impostorDivisions,
                    (newValue) {
                      FeedbackService.lightVibration();
                      setState(() => _impostorCount = newValue);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Tiempo de Debate Slider
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildSliderRow(
                    'Tiempo de Debate (min)',
                    _debateTime,
                    1.0,
                    10.0,
                    9,
                    (newValue) {
                      FeedbackService.lightVibration();
                      setState(() => _debateTime = newValue);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Switch de Pista
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SwitchListTile(
                    title: const Text('Pista para Impostores',
                        style: TextStyle(
                            color: AppColors.textoPrincipal,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      _impostorHint
                          ? 'Los impostores recibirán una pista'
                          : 'Los impostores no recibirán pista',
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    value: _impostorHint,
                    onChanged: (bool value) {
                      FeedbackService.lightVibration();
                      setState(() => _impostorHint = value);
                    },
                    activeColor: AppColors.acentoCTA,
                    inactiveTrackColor: Colors.grey[700],
                    tileColor: AppColors.fondoSecundario,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _impostorHint
                            ? AppColors.acentoCTA.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: _impostorHint
                            ? AppColors.acentoCTA
                            : AppColors.textoSecundario,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),

          // Botón Iniciar Juego flotante con animación
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(_fabAnimation),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.fondoPrincipal.withOpacity(0.0),
                      AppColors.fondoPrincipal.withOpacity(0.8),
                      AppColors.fondoPrincipal,
                    ],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.acentoCTA,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 8,
                    shadowColor: AppColors.acentoCTA.withOpacity(0.4),
                  ),
                  onPressed: _startGame,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.textoBoton,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'INICIAR JUEGO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoBoton,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.fondoDrawer,
      child: Column(
        children: [
          // Header del Drawer con gradiente
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.fondoPrincipal,
                  Color(0xFF374151),
                  AppColors.acentoCTA,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.textoPrincipal,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Configuración',
                  style: TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personaliza tu experiencia',
                  style: TextStyle(
                    color: AppColors.textoPrincipal.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Opciones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Efectos de Sonido
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: const Text('Efectos de Sonido',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: Text(
                      _soundEffects ? 'Activado' : 'Desactivado',
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    value: _soundEffects,
                    onChanged: (bool value) {
                      setState(() => _soundEffects = value);
                      FeedbackService.setSoundEnabled(value);
                      FeedbackService.lightVibration();
                    },
                    activeColor: AppColors.acentoCTA,
                    inactiveTrackColor: Colors.grey[700],
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _soundEffects
                            ? AppColors.acentoCTA.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _soundEffects ? Icons.volume_up : Icons.volume_off,
                        color: _soundEffects
                            ? AppColors.acentoCTA
                            : AppColors.textoSecundario,
                      ),
                    ),
                  ),
                ),

                // Vibración
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: const Text('Vibración',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: Text(
                      _vibration ? 'Activado' : 'Desactivado',
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    value: _vibration,
                    onChanged: (bool value) {
                      setState(() => _vibration = value);
                      FeedbackService.setVibrationEnabled(value);
                      if (value) FeedbackService.mediumVibration();
                    },
                    activeColor: AppColors.acentoCTA,
                    inactiveTrackColor: Colors.grey[700],
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _vibration
                            ? AppColors.acentoCTA.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _vibration ? Icons.vibration : Icons.mobile_off,
                        color: _vibration
                            ? AppColors.acentoCTA
                            : AppColors.textoSecundario,
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.white12, height: 1),
                ),

                // Cómo Jugar
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.acentoCTA.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.help_outline,
                          color: AppColors.acentoCTA),
                    ),
                    title: const Text('Cómo Jugar',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: const Text('Aprende las reglas del juego',
                        style: TextStyle(
                            color: AppColors.textoSecundario, fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: AppColors.textoSecundario, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      _showRulesModal(context);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Footer con créditos
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.fondoPrincipal.withOpacity(0.5),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.code,
                        color: AppColors.acentoCTA.withOpacity(0.8), size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Desarrollado con',
                      style: TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.favorite,
                        color: Colors.red.withOpacity(0.8), size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'IvnMtz09',
                  style: TextStyle(
                    color: AppColors.acentoCTA,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'v1.0.0 • ${DateTime.now().year}',
                  style: TextStyle(
                    color: AppColors.textoSecundario.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.acentoCTA.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toInt()}',
                style: const TextStyle(
                  color: AppColors.acentoCTA,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toInt().toString(),
            activeColor: AppColors.acentoCTA,
            inactiveColor: Colors.grey[700],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigRow({
    required String title,
    required String value,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        FeedbackService.lightVibration();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.fondoSecundario,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.acentoCTA.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.acentoCTA, size: 22),
              ),
              const SizedBox(width: 16),
            ],
            Text(title,
                style: const TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    color: AppColors.acentoCTA,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textoSecundario, size: 16),
          ],
        ),
      ),
    );
  }
}
