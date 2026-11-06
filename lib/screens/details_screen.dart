import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// Pantalla de Ficha Técnica Detallada responsive con opción de eliminación
class DetailsScreen extends StatelessWidget {
  static const String routeName = '/details';
  static const String hashRouteName = '/#/details';

  final ComponentItem? component;
  final ValueChanged<ComponentItem>? onDelete;

  const DetailsScreen({
    super.key,
    this.component,
    this.onDelete,
  });

  Future<void> _showDeleteDialog(BuildContext context, ComponentItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.borderMedium, width: 1.5),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: const FaIcon(
                FontAwesomeIcons.trashCan,
                color: Color(0xFFDC2626),
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Eliminar Componente',
                style: AppTheme.headingStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Está seguro de eliminar "${item.name}" del catálogo institucional?',
          style: AppTheme.bodyStyle(
            fontSize: 14,
            color: const Color(0xFF475569),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: AppTheme.bodyStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Eliminar',
              style: AppTheme.bodyStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    if (context.mounted && confirmed == true) {
      if (onDelete != null) {
        onDelete!(item);
      }
      Navigator.of(context).pop('delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = component ??
        ModalRoute.of(context)?.settings.arguments as ComponentItem?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalle del Componente',
            style: AppTheme.headingStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 54,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 16),
              Text(
                'No se encontró la información del componente seleccionado.',
                style: AppTheme.bodyStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al Catálogo'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    }

    final catColor = AppTheme.getCategoryColor(item.category);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(
          item.name,
          style: AppTheme.headingStyle(
            fontSize: isMobile ? 17 : 19,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trashCan,
              size: 17,
              color: Colors.white,
            ),
            tooltip: 'Eliminar este componente',
            onPressed: () => _showDeleteDialog(context, item),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20,
          vertical: isMobile ? 16 : 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderMedium, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    // Franja superior de acento con el color de la categoría
                    Container(
                      height: 6,
                      color: catColor,
                    ),
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 18.0 : 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ícono circular destacado superior con anillo/borde concéntrico
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: catColor.withValues(alpha: 0.25),
                                  width: 3,
                                ),
                              ),
                              child: Container(
                                width: isMobile ? 70 : 84,
                                height: isMobile ? 70 : 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: FaIcon(
                                    item.iconData,
                                    size: isMobile ? 30 : 38,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : 22),

                          // Título del Componente y Badge con bordes acentuados
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: AppTheme.headingStyle(
                                    fontSize: isMobile ? 19 : 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: catColor.withValues(alpha: 0.35),
                                    width: 1.3,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.layerGroup,
                                      size: 11,
                                      color: catColor,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      item.category,
                                      style: AppTheme.bodyStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: catColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          const Divider(color: AppTheme.borderSubtle, thickness: 1.2),
                          const SizedBox(height: 14),

                          // Sección: Ficha Técnica y Descripción
                          Text(
                            'Ficha Técnica y Descripción:',
                            style: AppTheme.headingStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style: AppTheme.bodyStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Bloque Destacado Verde: Responsive para teléfonos móviles
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 14 : 20,
                              vertical: isMobile ? 14 : 18,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.greenBoxBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.greenBoxBorder,
                                width: 1.6,
                              ),
                            ),
                            child: isMobile && screenWidth < 380
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Precio estimado:',
                                        style: AppTheme.bodyStyle(
                                          fontSize: 12,
                                          color: AppTheme.greenTextDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            size: 16,
                                            color: AppTheme.greenTextDark,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              item.stockStatus,
                                              style: AppTheme.bodyStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.greenTextDark,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme.greenBoxBorder,
                                            width: 1.4,
                                          ),
                                        ),
                                        child: Text(
                                          item.formattedPrice,
                                          style: AppTheme.headingStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.priceGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Precio estimado:',
                                              style: AppTheme.bodyStyle(
                                                fontSize: 12,
                                                color: AppTheme.greenTextDark,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  size: 16,
                                                  color: AppTheme.greenTextDark,
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    item.stockStatus,
                                                    style: AppTheme.bodyStyle(
                                                      fontSize: 12.5,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppTheme.greenTextDark,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme.greenBoxBorder,
                                            width: 1.4,
                                          ),
                                        ),
                                        child: Text(
                                          item.formattedPrice,
                                          style: AppTheme.headingStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.priceGreen,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 24),

                          // Botón Volver al Catálogo
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
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
                              icon: const Icon(Icons.arrow_back, size: 18),
                              label: Text(
                                'Volver al Catálogo',
                                style: AppTheme.bodyStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Botón Secundario: Eliminar este componente
                          SizedBox(
                            height: 44,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFDC2626),
                                side: const BorderSide(
                                  color: Color(0xFFFCA5A5),
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 14,
                                color: Color(0xFFDC2626),
                              ),
                              label: Text(
                                'Eliminar este Componente',
                                style: AppTheme.bodyStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFDC2626),
                                ),
                              ),
                              onPressed: () => _showDeleteDialog(context, item),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
