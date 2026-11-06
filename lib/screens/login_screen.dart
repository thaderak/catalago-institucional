import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// PANTALLA DE ACCESO VANGUARDISTA: LoginScreen (Ruta: /login y /#/login)
/// ============================================================================
/// Diseñada con estética Obsidian Dark Tech inspirada en Linear, Vercel y Stripe:
/// - Fondos con gradiente mesh cósmico y orbes de luz ambiental.
/// - Tarjeta de vidrio acrílico oscuro (Glassmorphism) con micro-bordes.
/// - Botón principal con degradado Electric Indigo a Cyber Violet.
/// - Autenticación con credenciales fijas ("admin" / "admin123").
class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  static const String hashRouteName = '/#/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _userInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Credenciales fijas requeridas
  static const String _validUser = 'admin';
  static const String _validPassword = 'admin123';

  @override
  void dispose() {
    _userInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  /// Procesa la autenticación del usuario
  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final enteredUser = _userInputController.text.trim();
    final enteredPassword = _passwordInputController.text.trim();

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 380));

    if (!mounted) return;

    if (enteredUser == _validUser && enteredPassword == _validPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Usuario o contraseña incorrectos. Verifique sus credenciales.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Acceso denegado: Credenciales no válidas.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Autocompleta las credenciales de prueba al tocar la cápsula
  void _fillDemoCredentials() {
    setState(() {
      _userInputController.text = _validUser;
      _passwordInputController.text = _validPassword;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 500;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // FONDO CÓSMICO MESH OBSIDIAN CON DEGRADADO MULTI-NIVEL
          // -------------------------------------------------------------------
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF050811), // Midnight Black
                  Color(0xFF090D1A), // Deep Slate
                  Color(0xFF0E1629), // Indigo Tinted Obsidian
                  Color(0xFF080D1A), // Pure Obsidian
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),

          // Orbes de luz ambiental bioluminiscente (Glow Spheres)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentIndigo.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentCyan.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.3,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentViolet.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // TARJETA CENTRAL DE ACCESO (Aesthetic Dark Glassmorphism)
          // -------------------------------------------------------------------
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111A2D).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppTheme.borderMedium,
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 36,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: AppTheme.accentIndigo.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Franja superior con gradiente neón estético
                        Container(
                          height: 5,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6366F1), // Electric Indigo
                                Color(0xFF8B5CF6), // Cyber Violet
                                Color(0xFF06B6D4), // Cyan
                                Color(0xFF38BDF8), // Sky Blue
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 22 : 32,
                            vertical: 30,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Ícono circular con aura luminosa
                                Center(
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTheme.primaryGradient,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentIndigo
                                              .withValues(alpha: 0.45),
                                          blurRadius: 20,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.cubes,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Título institucional moderno
                                Text(
                                  'Catálogo SENATI',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.headingStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Portal de Gestión de Laboratorio TI',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 22),

                                // Cápsula interactiva de credenciales demo (Estilo Fintech)
                                InkWell(
                                  onTap: _fillDemoCredentials,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF082F49).withValues(alpha: 0.45),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.key,
                                          size: 13,
                                          color: Color(0xFF38BDF8),
                                        ),
                                        const SizedBox(width: 9),
                                        Expanded(
                                          child: Text(
                                            'Demo: admin / admin123  (Toca para autocompletar)',
                                            style: AppTheme.bodyStyle(
                                              fontSize: 12,
                                              color: const Color(0xFF7DD3FC),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Alerta visual de error en caso de fallo
                                if (_errorMessage != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF450A0A).withValues(alpha: 0.55),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF43F5E).withValues(alpha: 0.5),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.circleExclamation,
                                          size: 14,
                                          color: Color(0xFFFB7185),
                                        ),
                                        const SizedBox(width: 9),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: AppTheme.bodyStyle(
                                              fontSize: 12,
                                              color: const Color(0xFFFECDD3),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Campo 1: Usuario
                                TextFormField(
                                  controller: _userInputController,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Usuario',
                                    hintText: 'admin',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(13),
                                      child: FaIcon(
                                        FontAwesomeIcons.userCheck,
                                        size: 15,
                                        color: AppTheme.accentIndigo,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Por favor ingrese su usuario';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _handleLogin(),
                                ),
                                const SizedBox(height: 16),

                                // Campo 2: Contraseña
                                TextFormField(
                                  controller: _passwordInputController,
                                  obscureText: _obscurePassword,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    hintText: 'admin123',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(13),
                                      child: FaIcon(
                                        FontAwesomeIcons.lock,
                                        size: 15,
                                        color: AppTheme.accentIndigo,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: FaIcon(
                                        _obscurePassword
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        size: 15,
                                        color: AppTheme.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      tooltip: _obscurePassword
                                          ? 'Mostrar contraseña'
                                          : 'Ocultar contraseña',
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Por favor ingrese su contraseña';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _handleLogin(),
                                ),
                                const SizedBox(height: 24),

                                // Botón de Inicio con Degradado Electric Indigo
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentIndigo
                                            .withValues(alpha: 0.4),
                                        blurRadius: 18,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Ingresar al Catálogo',
                                                  style: AppTheme.bodyStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 19,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
