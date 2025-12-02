import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/models/word_model.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';
import 'package:el_impostor_app/core/services/player_storage_service.dart';
import 'package:el_impostor_app/core/services/settings_storage_service.dart';
import 'package:el_impostor_app/data/repositories/word_repository.dart';
import 'package:el_impostor_app/presentation/screens/role_reveal_screen.dart';
import 'package:el_impostor_app/presentation/widgets/category_select_modal.dart';
import 'package:el_impostor_app/presentation/widgets/player_list_modal.dart';
import 'package:el_impostor_app/presentation/widgets/rules_modal.dart';
import 'package:el_impostor_app/presentation/widgets/animated_button.dart';
import 'package:el_impostor_app/presentation/widgets/page_transitions.dart';
import 'package:el_impostor_app/presentation/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:el_impostor_app/core/providers/theme_provider.dart';

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
  List<String> _selectedCategories = [];
  bool _isLoading = true;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _initializeGame();
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

  Future<void> _initializeGame() async {
    // Cargar datos secuencialmente para evitar condiciones de carrera
    await _loadGameData();
    await _loadSavedPlayers();
    await _loadSettings();

    // Validación final para asegurar que la configuración es consistente
    if (mounted) {
      setState(() {
        final maxImpostors = _calculateMaxImpostors(_playerNames.length).toDouble();
        if (_impostorCount > maxImpostors) {
          _impostorCount = maxImpostors;
        }
      });
    }
  }

  /// Carga los nombres de jugadores guardados
  Future<void> _loadSavedPlayers() async {
    try {
      final savedNames = await PlayerStorageService.loadPlayerNames();
      if (savedNames.isNotEmpty) {
        setState(() {
          _playerNames = savedNames;
          // Ajustar impostores según la cantidad de jugadores
          _impostorCount = _calculateMaxImpostors(_playerNames.length).toDouble();
        });
      }
    } catch (e) {
      print('Error al cargar jugadores guardados: $e');
    }
  }

  /// Carga los ajustes guardados
  Future<void> _loadSettings() async {
    try {
      final settings = await SettingsStorageService.loadSettings();
      if (!mounted) return;
      setState(() {
        _soundEffects = settings['soundEffects'];
        _vibration = settings['vibration'];
        _impostorHint = settings['impostorHint'];
        _debateTime = settings['debateTime'];
        if (settings['impostorCount'] != null) {
          _impostorCount = settings['impostorCount'];
        }
      });
      
      // Aplicar configuraciones globales
      FeedbackService.setSoundEnabled(_soundEffects);
      FeedbackService.setVibrationEnabled(_vibration);
    } catch (e) {
      print('Error al cargar ajustes: $e');
    }
  }

  /// Guarda los ajustes actuales
  Future<void> _saveSettings() async {
    try {
      await SettingsStorageService.saveSettings(
        soundEffects: _soundEffects,
        vibration: _vibration,
        impostorHint: _impostorHint,
        debateTime: _debateTime,
        impostorCount: _impostorCount,
      );
    } catch (e) {
      print('Error al guardar ajustes: $e');
    }
  }

  /// Calcula el máximo de impostores según la cantidad de jugadores
  int _calculateMaxImpostors(int playerCount) {
    if (playerCount <= 5) {
      return 1;
    } else if (playerCount <= 15) {
      return 2;
    } else {
      return 3;
    }
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
        // Calcular y ajustar el máximo de impostores según las nuevas reglas
        final maxImpostors = _calculateMaxImpostors(_playerNames.length);
        if (_impostorCount > maxImpostors) {
          _impostorCount = maxImpostors.toDouble();
        }
      });
      // Guardar los nombres actualizados
      await PlayerStorageService.savePlayerNames(_playerNames);
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
          FadeSlideTransition(
            page: RoleRevealScreen(
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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.acentoCTA),
          ),
        ),
      );
    }

    // Calcular máximo de impostores según las nuevas reglas
    final maxImpostors = _calculateMaxImpostors(_playerNames.length).toDouble();
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
                      setState(() {
                        _impostorCount = newValue;
                        _saveSettings();
                      });
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
                      setState(() {
                        _debateTime = newValue;
                        _saveSettings();
                      });
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
                    title: Text('Pista para Impostores',
                        style: TextStyle(
                            color: AppColors.textoPrincipal,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      _impostorHint
                          ? 'Los impostores recibirán una pista'
                          : 'Los impostores no recibirán pista',
                      style: TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    value: _impostorHint,
                    onChanged: (bool value) {
                      FeedbackService.lightVibration();
                      setState(() {
                        _impostorHint = value;
                        _saveSettings();
                      });
                    },
                    activeThumbColor: AppColors.acentoCTA,
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
                child: PulseEffect(
                  child: AnimatedButton(
                    text: 'INICIAR JUEGO',
                    icon: Icons.play_arrow_rounded,
                    onPressed: _startGame,
                    variant: AnimatedButtonVariant.primary,
                    width: double.infinity,
                    height: 60,
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
            decoration: BoxDecoration(
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
                  child: Icon(
                    Icons.tune,
                    color: AppColors.textoPrincipal,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
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
                // Tema Oscuro/Claro
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.fondoSecundario,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) => SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      title: Text('Modo Oscuro',
                          style: TextStyle(
                            color: AppColors.textoPrincipal,
                            fontWeight: FontWeight.w500,
                          )),
                      subtitle: Text(
                        themeProvider.isDarkMode ? 'Activado' : 'Desactivado',
                        style: TextStyle(
                            color: AppColors.textoSecundario, fontSize: 12),
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                        FeedbackService.lightVibration();
                      },
                      activeThumbColor: AppColors.acentoCTA,
                      inactiveTrackColor: Colors.grey[700],
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? AppColors.acentoCTA.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          themeProvider.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: themeProvider.isDarkMode
                              ? AppColors.acentoCTA
                              : AppColors.textoSecundario,
                        ),
                      ),
                    ),
                  ),
                ),

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
                    title: Text('Efectos de Sonido',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: Text(
                      _soundEffects ? 'Activado' : 'Desactivado',
                      style: TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    value: _soundEffects,
                    onChanged: (bool value) {
                      FeedbackService.playButtonTap();
                      setState(() {
                        _soundEffects = value;
                        _saveSettings();
                      });
                      FeedbackService.setSoundEnabled(value);
                      FeedbackService.lightVibration();
                    },
                    activeThumbColor: AppColors.acentoCTA,
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
                    title: Text('Vibración',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: Text(
                      _vibration ? 'Activado' : 'Desactivado',
                      style: TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    value: _vibration,
                    onChanged: (bool value) {
                      FeedbackService.playButtonTap();
                      setState(() {
                        _vibration = value;
                        _saveSettings();
                      });
                      FeedbackService.setVibrationEnabled(value);
                      if (value) FeedbackService.mediumVibration();
                    },
                    activeThumbColor: AppColors.acentoCTA,
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
                      child: Icon(Icons.help_outline,
                          color: AppColors.acentoCTA,
                    ),
                  ),
                    title: Text('Cómo Jugar',
                        style: TextStyle(
                          color: AppColors.textoPrincipal,
                          fontWeight: FontWeight.w500,
                        )),
                    subtitle: Text('Aprende las reglas del juego',
                        style: TextStyle(
                            color: AppColors.textoSecundario, fontSize: 12)),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _showRulesModal(context);
                      },
                      child: Icon(Icons.arrow_forward_ios,
                          color: AppColors.textoSecundario, size: 16),
                    ),
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
                    Text(
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
                Text(
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
              style: TextStyle(
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
                style: TextStyle(
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
                style: TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    color: AppColors.acentoCTA,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios,
                color: AppColors.textoSecundario, size: 16),
          ],
        ),
      ),
    );
  }
}
