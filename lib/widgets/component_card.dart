import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// Tarjeta dinámica y responsive optimizada para teléfonos y pantallas grandes
class ComponentCard extends StatelessWidget {
  final ComponentItem component;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ComponentCard({
    super.key,
    required this.component,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = AppTheme.getCategoryColor(component.category);
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Dismissible(
      key: Key(component.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
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
              '¿Desea eliminar "${component.name}" del catálogo?',
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
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Eliminar',
              style: AppTheme.bodyStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const FaIcon(
              FontAwesomeIcons.trashCan,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderMedium, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: catColor, width: isMobile ? 4.5 : 5),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: catColor.withValues(alpha: 0.08),
                highlightColor: catColor.withValues(alpha: 0.04),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 14,
                    vertical: isMobile ? 10 : 12,
                  ),
                  child: Row(
                    children: [
                      // Ícono dinámico FontAwesome responsive
                      Container(
                        width: isMobile ? 40 : 46,
                        height: isMobile ? 40 : 46,
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.35),
                            width: 1.4,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            component.iconData,
                            color: catColor,
                            size: isMobile ? 17 : 20,
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 10 : 14),

                      // Nombre del componente y Badge
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              component.name,
                              style: AppTheme.headingStyle(
                                fontSize: isMobile ? 14 : 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: catColor.withValues(alpha: 0.28),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                component.category,
                                style: AppTheme.bodyStyle(
                                  fontSize: isMobile ? 10.5 : 11,
                                  fontWeight: FontWeight.w700,
                                  color: catColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Cápsula de Precio con bordes verdes definidos
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 7 : 10,
                          vertical: isMobile ? 5 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.priceBadgeBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.priceBadgeBorder,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          component.formattedPrice,
                          style: AppTheme.bodyStyle(
                            fontSize: isMobile ? 12 : 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.priceGreen,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // Botón para eliminar componente directamente
                      Tooltip(
                        message: 'Eliminar componente',
                        child: InkWell(
                          key: ValueKey('delete-${component.id}'),
                          borderRadius: BorderRadius.circular(6),
                          onTap: onDelete,
                          child: Container(
                            width: isMobile ? 28 : 30,
                            height: isMobile ? 28 : 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFECACA),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Color(0xFFDC2626),
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // Indicador de navegación
                      Container(
                        width: isMobile ? 22 : 26,
                        height: isMobile ? 22 : 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.borderSubtle,
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_right,
                            color: AppTheme.textSecondary,
                            size: 16,
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
      ),
    );
  }
}
