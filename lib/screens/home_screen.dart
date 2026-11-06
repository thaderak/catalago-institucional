import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/initial_components.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';
import '../widgets/add_component_modal.dart';
import '../widgets/component_card.dart';
import '../widgets/filter_chip_bar.dart';

/// ============================================================================
/// PANTALLA PRINCIPAL: HomeScreen (Catálogo Tecnológico SENATI)
/// ============================================================================
/// Presenta el catálogo de componentes en interfaz Obsidian Dark Tech vanguardista:
/// - Filtrado reactivo en tiempo real por categoría y texto.
/// - Inserción y eliminación reactiva de componentes.
/// - Diseño responsive para pantallas móviles y de escritorio.
/// - Cierre de sesión seguro con retorno al Login.
class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  static const String hashRouteName = '/#/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista mutable de componentes tecnológicos cargada en memoria
  late List<ComponentItem> _allComponents;

  // Estado del filtro de categoría seleccionado
  String _selectedCategory = 'Todos';

  // Estados y controladores para el motor de búsqueda en tiempo real
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allComponents = List.from(initialComponents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // GETTERS COMPUTADOS (LÓGICA DE NEGOCIO Y FILTRADO)
  // ===========================================================================

  Map<String, int> get _categoryCounts {
    final Map<String, int> counts = {'Todos': _allComponents.length};
    for (final item in _allComponents) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    return counts;
  }

  List<ComponentItem> get _filteredComponents {
    return _allComponents.where((item) {
      final matchesCategory = _selectedCategory == 'Todos' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ===========================================================================
  // MÉTODOS DE MANIPULACIÓN DEL ESTADO (CRUD Y ACCIONES)
  // ===========================================================================

  void _addNewComponent(ComponentItem newComponent) {
    setState(() {
      _allComponents.insert(0, newComponent);
    });
  }

  void _deleteComponent(ComponentItem component) {
    showDialog<bool>(
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
          '¿Está seguro de eliminar "${component.name}" del catálogo institucional?',
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
    ).then((confirmed) {
      if (confirmed == true) {
        _executeDelete(component);
      }
    });
  }

  void _executeDelete(ComponentItem component) {
    final index = _allComponents.indexWhere((c) => c.id == component.id);
    if (index == -1) return;

    setState(() {
      _allComponents.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.trashCan,
              color: Color(0xFFFB7185),
              size: 15,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Se eliminó "${component.name}".',
                style: AppTheme.bodyStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1118),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE11D48), width: 1.2),
        ),
        action: SnackBarAction(
          label: 'DESHACER',
          textColor: const Color(0xFF38BDF8),
          onPressed: () {
            setState(() {
              _allComponents.insert(index, component);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showDeletePeripheralDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final currentPeripherals = _allComponents
              .where((c) =>
                  c.category.toLowerCase() == 'periféricos' ||
                  c.category.toLowerCase() == 'perifericos')
              .toList();

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF111A2D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              border: Border(
                top: BorderSide(color: AppTheme.borderMedium, width: 1.4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF450A0A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFF43F5E).withValues(alpha: 0.4),
                          ),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Color(0xFFFB7185),
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Eliminar Periférico',
                        style: AppTheme.headingStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: AppTheme.textSecondary),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const Divider(color: AppTheme.borderSubtle, thickness: 1.2),
                  const SizedBox(height: 6),
                  if (currentPeripherals.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.circleInfo,
                              color: Color(0xFF64748B),
                              size: 32,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No hay periféricos registrados para eliminar.',
                              style: AppTheme.bodyStyle(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Toque el botón de basura para eliminar el periférico deseado:',
                      style: AppTheme.bodyStyle(
                        fontSize: 12.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: currentPeripherals.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = currentPeripherals[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF162238),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppTheme.getCategoryColor(item.category)
                                        .withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.getCategoryColor(item.category)
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      item.iconData,
                                      size: 15,
                                      color: AppTheme.getCategoryColor(item.category),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: AppTheme.headingStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.formattedPrice,
                                        style: AppTheme.bodyStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.priceGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    color: Color(0xFFFB7185),
                                    size: 15,
                                  ),
                                  tooltip: 'Eliminar este periférico',
                                  onPressed: () {
                                    _executeDelete(item);
                                    setModalState(() {});
                                    setState(() {});
                                    if (currentPeripherals.length <= 1) {
                                      Navigator.of(ctx).pop();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmLogout() {
    showDialog<bool>(
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
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentIndigo.withValues(alpha: 0.4)),
              ),
              child: const FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: AppTheme.accentIndigo,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cerrar Sesión',
                style: AppTheme.headingStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          '¿Desea cerrar la sesión de usuario y regresar a la pantalla de acceso?',
          style: AppTheme.bodyStyle(
            fontSize: 13.5,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: AppTheme.bodyStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentIndigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Cerrar sesión',
              style: AppTheme.bodyStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  void _navigateToDetails(ComponentItem component) async {
    final result = await Navigator.pushNamed(
      context,
      '/details',
      arguments: component,
    );

    if (result == 'delete') {
      _executeDelete(component);
    }
  }

  // ===========================================================================
  // CONSTRUCCIÓN VISUAL DEL WIDGET (BUILD METHOD)
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredComponents;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      // -----------------------------------------------------------------------
      // APPBAR: Barra superior Obsidian con buscador interactivo
      // -----------------------------------------------------------------------
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
        title: _isSearching
            ? Container(
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF162238),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentIndigo.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: AppTheme.bodyStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: AppTheme.accentCyan,
                  decoration: InputDecoration(
                    hintText: 'Buscar en catálogo TI...',
                    hintStyle: AppTheme.bodyStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentIndigo.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.cubes,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      'Catálogo SENATI',
                      style: AppTheme.headingStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search_rounded,
              size: 22,
              color: AppTheme.textPrimary,
            ),
            tooltip: _isSearching ? 'Cerrar búsqueda' : 'Buscar componente',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            tooltip: 'Cerrar sesión',
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 6),
        ],
      ),
      // -----------------------------------------------------------------------
      // BODY: Contenedor responsive con filtros y ListView dinámica
      // -----------------------------------------------------------------------
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texto pedagógico moderno
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: isMobile ? 12 : 16,
                  right: isMobile ? 12 : 16,
                  top: isMobile ? 10 : 14,
                  bottom: 2,
                ),
                child: Text(
                  'Seleccione una categoría o toque un componente para ver su ficha técnica:',
                  style: AppTheme.bodyStyle(
                    fontSize: isMobile ? 12 : 12.5,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Barra horizontal de categorías (FilterChips) con conteo dinámico
              FilterChipBar(
                selectedCategory: _selectedCategory,
                categoryCounts: _categoryCounts,
                onSelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              // Barra de Opciones y Estado: Limpiar filtros + Eliminar periférico
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: 4,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111A2D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderSubtle, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      // Indicador de cantidad de resultados actuales con punto verde
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.accentCyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${filteredList.length} producto(s)',
                        style: AppTheme.bodyStyle(
                          fontSize: isMobile ? 11.5 : 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),

                      // Botón funcional: Eliminar Periférico (Aesthetic Danger Pill)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _showDeletePeripheralDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF450A0A).withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFF43F5E).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 11,
                                color: Color(0xFFFB7185),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isMobile ? 'Eliminar' : 'Eliminar periférico',
                                style: AppTheme.bodyStyle(
                                  fontSize: 11,
                                  color: const Color(0xFFFB7185),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Opción: Limpiar filtros (solo visible si hay filtros activos)
                      if (_searchQuery.isNotEmpty || _selectedCategory != 'Todos') ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'Todos';
                              _searchQuery = '';
                              _searchController.clear();
                              _isSearching = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Text(
                              'Limpiar filtros',
                              style: AppTheme.bodyStyle(
                                fontSize: 11,
                                color: AppTheme.accentCyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Lista Dinámica de Componentes
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 20 : 28),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111A2D),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppTheme.borderMedium, width: 1.2),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF182238),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.borderMedium, width: 1.4),
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: 24,
                                      color: AppTheme.accentIndigo,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No se encontraron componentes',
                                  style: AppTheme.headingStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No hay componentes que coincidan con "$_searchQuery"'
                                      : 'No hay elementos registrados en la categoría "$_selectedCategory"',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedCategory = 'Todos';
                                        _searchQuery = '';
                                        _searchController.clear();
                                        _isSearching = false;
                                      });
                                    },
                                    child: Text(
                                      'Ver todos los componentes',
                                      style: AppTheme.bodyStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 90),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return ComponentCard(
                            component: item,
                            onTap: () => _navigateToDetails(item),
                            onDelete: () => _deleteComponent(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // FLOATING ACTION BUTTON: Botón flotante con Degradado Electric Indigo
      // -----------------------------------------------------------------------
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentIndigo.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          icon: const FaIcon(
            FontAwesomeIcons.plus,
            size: 13,
            color: Colors.white,
          ),
          label: Text(
            isMobile ? 'Nuevo' : 'Nuevo Componente',
            style: AppTheme.bodyStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          onPressed: () {
            AddComponentModal.show(
              context,
              onComponentAdded: _addNewComponent,
            );
          },
        ),
      ),
    );
  }
}
