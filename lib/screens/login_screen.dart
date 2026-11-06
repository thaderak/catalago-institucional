import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// PANTALLA DE INICIO DE SESIÓN: LoginScreen (Ruta: /login y /#/login)
/// ============================================================================
/// Implementa autenticación con usuario y contraseña fijos ("admin" / "admin123"),
/// diseño dinámico con degradados de color de alta gama (Gradients),
/// validación de formulario, feedback de error y acceso directo al Catálogo SENATI.
class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  static const String hashRouteName = '/#/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Llave global del formulario para validar entradas
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para usuario y contraseña
  final _userInputController = TextEditingController();
  final _passwordInputController = TextEditingController();

  // Estados interactivos
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Credenciales requeridas
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
    // Limpiar mensaje de error previo
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

    // Pequeño delay de 400ms para sensación de proceso fluido y profesional
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    if (enteredUser == _validUser && enteredPassword == _validPassword) {
      // Credenciales correctas: navegar a HomeScreen limpiando la pila
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Credenciales incorrectas: mostrar error visual
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
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Autocompleta las credenciales de prueba al tocar la cápsula de sugerencia
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
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // FONDO DINÁMICO CON DEGRADADO DE COLOR CORPORATIVO
          // -------------------------------------------------------------------
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF001F3F), // Azul noche profundo
                  Color(0xFF003865), // Azul SENATI institucional
                  Color(0xFF0B3C5D), // Azul petróleo
                  Color(0xFF0284C7), // Azul cyan luminoso
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),

          // Círculos difusos decorativos para profundidad visual
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // CONTENIDO CENTRAL: TARJETA DE ACCESO CON BORDES DEFINIDOS
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // Borde marcado y elegante
                    border: Border.all(
                      color: AppTheme.borderMedium,
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Franja superior con degradado decorativo
                        Container(
                          height: 7,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF003865),
                                Color(0xFF0284C7),
                                Color(0xFF38BDF8),
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
                                // Ícono circular con degradado
                                Center(
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF003865),
                                          Color(0xFF0284C7),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF003865)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 14,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.cubes,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Título institucional
                                Text(
                                  'Catálogo SENATI',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.headingStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryBlue,
                                    letterSpacing: -0.3,
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

                                // Cápsula informativa de credenciales demo
                                InkWell(
                                  onTap: _fillDemoCredentials,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F9FF),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFBAE6FD),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.key,
                                          size: 13,
                                          color: Color(0xFF0284C7),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Demo: admin / admin123  (Toca para autocompletar)',
                                            style: AppTheme.bodyStyle(
                                              fontSize: 11.5,
                                              color: const Color(0xFF0369A1),
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
                                      horizontal: 12,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFFECACA),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.circleExclamation,
                                          size: 14,
                                          color: Color(0xFFDC2626),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: AppTheme.bodyStyle(
                                              fontSize: 12,
                                              color: const Color(0xFFB91C1C),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                ],

                                // Campo 1: Usuario
                                TextFormField(
                                  controller: _userInputController,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Usuario',
                                    hintText: 'admin',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.userCheck,
                                        size: 16,
                                        color: AppTheme.secondaryBlue,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppTheme.borderMedium,
                                        width: 1.5,
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
                                    color: AppTheme.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    hintText: 'admin123',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.lock,
                                        size: 16,
                                        color: AppTheme.secondaryBlue,
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: AppTheme.borderMedium,
                                        width: 1.5,
                                      ),
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

                                // Botón de Inicio con Degradado Dinámico
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF003865), // Azul SENATI
                                        Color(0xFF005696),
                                        Color(0xFF0284C7), // Cyan luminoso
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFF1E3A8A),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF003865)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    letterSpacing: 0.2,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward,
                                                size: 18,
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
