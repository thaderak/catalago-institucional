import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';

/// Pantalla de Ficha Técnica Detallada con diseño Obsidian Dark Tech
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
          '¿Está seguro de eliminar "${item.name}" del catálogo institucional?',
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
        backgroundColor: AppTheme.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceDark,
          title: Text(
            'Detalle del Componente',
            style: AppTheme.headingStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 54,
                color: Color(0xFFFB7185),
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
        backgroundColor: AppTheme.surfaceDark,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppTheme.borderSubtle,
            height: 1,
          ),
        ),
        title: Text(
          item.name,
          style: AppTheme.headingStyle(
            fontSize: isMobile ? 17 : 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trashCan,
              size: 16,
              color: Color(0xFFFB7185),
            ),
            tooltip: 'Eliminar este componente',
            onPressed: () => _showDeleteDialog(context, item),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : 22,
          vertical: isMobile ? 18 : 28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111A2D),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.borderMedium, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  children: [
                    // Franja superior de acento con el color neón de la categoría
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            catColor,
                            catColor.withValues(alpha: 0.6),
                            AppTheme.accentIndigo,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Ícono circular destacado superior con halo concéntrico
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: catColor.withValues(alpha: 0.3),
                                  width: 2.5,
                                ),
                              ),
                              child: Container(
                                width: isMobile ? 74 : 88,
                                height: isMobile ? 74 : 88,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF162238),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: catColor.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: catColor.withValues(alpha: 0.25),
                                      blurRadius: 18,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: FaIcon(
                                    item.iconData,
                                    size: isMobile ? 32 : 40,
                                    color: catColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 18 : 24),

                          // Título del Componente y Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: AppTheme.headingStyle(
                                    fontSize: isMobile ? 20 : 23,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 5.5,
                                ),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: catColor.withValues(alpha: 0.4),
                                    width: 1.2,
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
                                    const SizedBox(width: 6),
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
                          const SizedBox(height: 18),

                          const Divider(color: AppTheme.borderSubtle, thickness: 1.2),
                          const SizedBox(height: 16),

                          // Sección: Ficha Técnica y Descripción
                          Text(
                            'Ficha Técnica y Descripción:',
                            style: AppTheme.headingStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.description,
                            style: AppTheme.bodyStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Bloque Destacado Verde Fintech
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 16 : 22,
                              vertical: isMobile ? 16 : 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.greenBoxBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppTheme.greenBoxBorder,
                                width: 1.4,
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
                                            color: AppTheme.priceGreen,
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
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF041E18),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppTheme.priceGreen.withValues(alpha: 0.5),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Text(
                                          item.formattedPrice,
                                          style: AppTheme.headingStyle(
                                            fontSize: 20,
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
                                                  color: AppTheme.priceGreen,
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF041E18),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppTheme.priceGreen.withValues(alpha: 0.5),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Text(
                                          item.formattedPrice,
                                          style: AppTheme.headingStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.priceGreen,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 26),

                          // Botón Volver al Catálogo con Degradado
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
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_back_rounded, size: 18, color: Colors.white),
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
                            height: 46,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFFB7185),
                                side: const BorderSide(
                                  color: Color(0xFF991B1B),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 14,
                                color: Color(0xFFFB7185),
                              ),
                              label: Text(
                                'Eliminar este Componente',
                                style: AppTheme.bodyStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFB7185),
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
