import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// Formulario modal emergente con estética Obsidian Dark Tech
class AddComponentModal extends StatefulWidget {
  final ValueChanged<ComponentItem> onComponentAdded;

  const AddComponentModal({
    super.key,
    required this.onComponentAdded,
  });

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
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Hardware';

  final List<String> _availableCategories = [
    'Hardware',
    'Procesadores',
    'Almacenamiento',
    'Periféricos',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final cleanPriceString = _priceController.text
          .replaceAll('S/', '')
          .replaceAll(',', '')
          .trim();
      final double parsedPrice = double.tryParse(cleanPriceString) ?? 0.0;

      final newComponent = ComponentItem(
        id: 'comp-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        category: _selectedCategory,
        price: parsedPrice,
        description: _descriptionController.text.trim(),
      );

      widget.onComponentAdded(newComponent);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppTheme.priceGreen,
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
          backgroundColor: const Color(0xFF062E25),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.priceBadgeBorder, width: 1.2),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 700;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111A2D),
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(22))
            : BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderMedium, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: isMobile
            ? const BorderRadius.vertical(top: Radius.circular(22))
            : BorderRadius.circular(20),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 26,
              vertical: isMobile ? 16 : 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isMobile) ...[
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
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
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.plus,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Registrar Componente',
                            style: AppTheme.headingStyle(
                              fontSize: isMobile ? 17 : 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
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

                  // CAMPO 1: Nombre
                  TextFormField(
                    controller: _nameController,
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: Colors.white,
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

                  // CAMPO 2: Categoría
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    dropdownColor: const Color(0xFF162238),
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: FaIcon(
                          FontAwesomeIcons.sitemap,
                          size: 15,
                          color: AppTheme.accentIndigo,
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
                            Text(category, style: const TextStyle(color: Colors.white)),
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

                  // CAMPO 3: Precio
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: AppTheme.bodyStyle(
                      fontSize: 14,
                      color: Colors.white,
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

                  // CAMPO 4: Descripción Técnica
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: AppTheme.bodyStyle(
                      fontSize: 13,
                      color: Colors.white,
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
                          color: AppTheme.accentIndigo,
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
                  const SizedBox(height: 22),

                  // BOTÓN DE ACCIÓN: Guardar Componente
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
                          color: AppTheme.accentIndigo.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
