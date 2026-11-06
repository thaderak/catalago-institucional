import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// ============================================================================
/// FORMULARIO MODAL EMERGENTE: AddComponentModal
/// ============================================================================
/// Widget con estado que gestiona la entrada estructurada y validación de datos
/// para registrar un nuevo componente tecnológico en el Catálogo SENATI.
/// Emplea FormState, TextEditingController y Material Design 3.
class AddComponentModal extends StatefulWidget {
  /// Callback ejecutado cuando el usuario completa y valida el formulario exitosamente
  final ValueChanged<ComponentItem> onComponentAdded;

  const AddComponentModal({
    super.key,
    required this.onComponentAdded,
  });

  /// Despliegue asíncrono inteligente:
  /// - En pantallas de escritorio / Web (> 700px) abre un [showDialog] centrado.
  /// - En pantallas de teléfonos móviles abre un [showModalBottomSheet] táctil.
  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ComponentItem> onComponentAdded,
  }) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    if (isDesktop) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AddComponentModal(onComponentAdded: onComponentAdded),
          ),
        ),
      );
    } else {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.90,
            ),
            child: AddComponentModal(onComponentAdded: onComponentAdded),
          ),
        ),
      );
    }
  }

  @override
  State<AddComponentModal> createState() => _AddComponentModalState();
}

class _AddComponentModalState extends State<AddComponentModal> {
  // ===========================================================================
  // CONTROLADORES Y LLAVE DE FORMULARIO
  // ===========================================================================

  /// Llave global para acceder al estado del formulario y ejecutar validaciones
  final _formKey = GlobalKey<FormState>();

  /// Controlador de texto para el campo "Nombre del Componente"
  final _nameController = TextEditingController();

  /// Controlador de texto para el campo numérico "Precio"
  final _priceController = TextEditingController();

  /// Controlador de texto para el campo multilínea "Descripción Técnica"
  final _descriptionController = TextEditingController();

  /// Categoría seleccionada por defecto en el menú desplegable
  String _selectedCategory = 'Hardware';

  /// Lista de opciones disponibles para el Dropdown institucional
  final List<String> _availableCategories = [
    'Hardware',
    'Procesadores',
    'Almacenamiento',
    'Periféricos',
  ];

  @override
  void dispose() {
    // Liberación estricta de controladores en memoria
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // LÓGICA DE VALIDACIÓN Y PERSISTENCIA TEMPORAL
  // ===========================================================================

  /// Valida la integridad de los datos ingresados:
  /// - Campos no vacíos
  /// - Formato numérico válido > 0 para el precio
  /// - Descripción con al menos 5 caracteres
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Limpieza de caracteres de moneda si el usuario escribió "S/ " o comas
      final cleanPriceString = _priceController.text
          .replaceAll('S/', '')
          .replaceAll(',', '')
          .trim();
      final double parsedPrice = double.tryParse(cleanPriceString) ?? 0.0;

      // Creación de la nueva entidad con ID único basado en timestamp
      final newComponent = ComponentItem(
        id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        category: _selectedCategory,
        price: parsedPrice,
        description: _descriptionController.text.trim(),
      );

      // Inyección del nuevo componente al estado superior
      widget.onComponentAdded(newComponent);

      // Cierre del modal emergente
      Navigator.of(context).pop();

      // Retroalimentación visual inmediata al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Componente "${newComponent.name}" guardado exitosamente.',
                  style: AppTheme.bodyStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.priceGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF166534), width: 1.2),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ===========================================================================
  // INTERFAZ GRÁFICA DEL FORMULARIO
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 700;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(20))
            : BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderMedium, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(20))
            : BorderRadius.circular(16),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 24,
              vertical: isMobile ? 14 : 22,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tirador táctil visual para teléfonos móviles
                  if (isMobile) ...[
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],

                  // Cabecera con título e icono FontAwesome
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.plus,
                              size: 13,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Registrar Componente',
                            style: AppTheme.headingStyle(
                              fontSize: isMobile ? 17 : 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.borderSubtle, width: 1),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                            color: AppTheme.textSecondary,
                            size: 17,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          tooltip: 'Cerrar',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppTheme.borderSubtle, thickness: 1.2),
                  const SizedBox(height: 14),

                  // -----------------------------------------------------------
                  // CAMPO 1: Nombre del Componente (Texto con icono de laptop)
                  // -----------------------------------------------------------
                  TextFormField(
                    controller: _nameController,
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nombre del Componente',
                      hintText: 'Ej. Tarjeta de Video RTX 4070',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: FaIcon(
                          FontAwesomeIcons.laptop,
                          size: 16,
                          color: AppTheme.getCategoryColor(_selectedCategory),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingrese el nombre del componente';
                      }
                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // -----------------------------------------------------------
                  // CAMPO 2: Categoría (DropdownButtonFormField con icono jerarquía)
                  // -----------------------------------------------------------
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: FaIcon(
                          FontAwesomeIcons.sitemap,
                          size: 15,
                          color: AppTheme.secondaryBlue,
                        ),
                      ),
                    ),
                    items: _availableCategories.map((category) {
                      final color = AppTheme.getCategoryColor(category);
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(category),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleccione una categoría válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // -----------------------------------------------------------
                  // CAMPO 3: Precio (Numérico con máscara/ejemplo e icono moneda)
                  // -----------------------------------------------------------
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Precio (Ej. S/ 450.00)',
                      hintText: '450.00',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: FaIcon(
                          FontAwesomeIcons.dollarSign,
                          size: 15,
                          color: AppTheme.priceGreen,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingrese el precio del componente';
                      }
                      final cleanValue = value
                          .replaceAll('S/', '')
                          .replaceAll(',', '')
                          .trim();
                      final parsed = double.tryParse(cleanValue);
                      if (parsed == null || parsed <= 0) {
                        return 'Ingrese un precio numérico válido mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // -----------------------------------------------------------
                  // CAMPO 4: Descripción Técnica (Multilínea con icono documento)
                  // -----------------------------------------------------------
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: AppTheme.bodyStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Descripción Técnica',
                      hintText: 'Detalles técnicos, conectividad, especificaciones...',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 12, top: 14, right: 12),
                        child: FaIcon(
                          FontAwesomeIcons.fileLines,
                          size: 15,
                          color: AppTheme.secondaryBlue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingrese la descripción técnica';
                      }
                      if (value.trim().length < 5) {
                        return 'La descripción debe tener al menos 5 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // -----------------------------------------------------------
                  // BOTÓN DE ACCIÓN DESTACADA: Guardar Componente
                  // -----------------------------------------------------------
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFF1E3A8A),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        'Guardar Componente',
                        style: AppTheme.bodyStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
