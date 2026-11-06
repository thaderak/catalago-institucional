import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// Tarjeta dinámica y responsive optimizada con estética Obsidian Dark Tech
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
            backgroundColor: const Color(0xFF111A2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppTheme.borderMedium, width: 1.4),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF450A0A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.5)),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Color(0xFFFB7185),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              '¿Desea eliminar "${component.name}" del catálogo?',
              style: AppTheme.bodyStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
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
                  backgroundColor: const Color(0xFFE11D48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
          color: const Color(0xFF991B1B),
          borderRadius: BorderRadius.circular(16),
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
          color: const Color(0xFF111A2D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderMedium, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
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
                splashColor: catColor.withValues(alpha: 0.12),
                highlightColor: catColor.withValues(alpha: 0.05),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 14,
                    vertical: isMobile ? 10 : 13,
                  ),
                  child: Row(
                    children: [
                      // Ícono dinámico FontAwesome con aura bioluminiscente
                      Container(
                        width: isMobile ? 42 : 48,
                        height: isMobile ? 42 : 48,
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.35),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: catColor.withValues(alpha: 0.20),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                fontSize: isMobile ? 14.5 : 15.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: catColor.withValues(alpha: 0.35),
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

                      // Cápsula de Precio Estilo Fintech (Neon Mint)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 11,
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.priceGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              component.formattedPrice,
                              style: AppTheme.bodyStyle(
                                fontSize: isMobile ? 12 : 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.priceGreen,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 6),

                      // Botón para eliminar componente directamente
                      Tooltip(
                        message: 'Eliminar componente',
                        child: InkWell(
                          key: ValueKey('delete-${component.id}'),
                          borderRadius: BorderRadius.circular(8),
                          onTap: onDelete,
                          child: Container(
                            width: isMobile ? 28 : 32,
                            height: isMobile ? 28 : 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF450A0A).withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFF43F5E).withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Color(0xFFFB7185),
                                size: 12,
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
                          color: const Color(0xFF1E293B),
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
