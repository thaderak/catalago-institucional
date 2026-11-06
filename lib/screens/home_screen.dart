import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/initial_components.dart';
import '../models/component_item.dart';
import '../theme/app_theme.dart';
import '../widgets/add_component_modal.dart';
import '../widgets/component_card.dart';
import '../widgets/filter_chip_bar.dart';

/// ============================================================================
/// PANTALLA PRINCIPAL: Catálogo SENATI (Ruta SPA: /#/home)
/// ============================================================================
/// Esta clase representa la vista principal de la aplicación SPA.
/// Gestiona la persistencia temporal de los componentes en memoria, el filtrado
/// en tiempo real por categorías, la búsqueda dinámica de texto, la adición de
/// nuevos registros mediante modal y la eliminación reactiva de productos.
class HomeScreen extends StatefulWidget {
  /// Nombre de ruta estándar para navegación interna
  static const String routeName = '/home';

  /// Nombre de ruta en formato hash para compatibilidad Single Page Application (SPA Web)
  static const String hashRouteName = '/#/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ===========================================================================
  // VARIABLES DE ESTADO LOCAL (GESTIÓN DE COLECCIONES REACTIVAS)
  // ===========================================================================

  /// Lista maestra en memoria que almacena los componentes tecnológicos registrados.
  /// Mantiene la persistencia temporal durante la sesión del usuario.
  late List<ComponentItem> _allComponents;

  /// Categoría seleccionada actualmente para filtrar la lista ('Todos', 'Hardware', etc.).
  String _selectedCategory = 'Todos';

  /// Término de búsqueda en texto plano ingresado por el usuario.
  String _searchQuery = '';

  /// Bandera booleana que indica si el campo de búsqueda en la AppBar está activo.
  bool _isSearching = false;

  /// Controlador para gestionar y limpiar el texto del campo de búsqueda en tiempo real.
  final TextEditingController _searchController = TextEditingController();

  // ===========================================================================
  // CICLO DE VIDA DEL WIDGET (LIFECYCLE)
  // ===========================================================================

  @override
  void initState() {
    super.initState();
    // Inicialización del estado: clonamos la lista inicial precargada del taller
    _allComponents = List.from(initialComponents);
  }

  @override
  void dispose() {
    // Liberación de recursos del controlador de texto para evitar fugas de memoria
    _searchController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // GETTERS COMPUTADOS (LÓGICA DE NEGOCIO Y FILTRADO)
  // ===========================================================================

  /// Calcula dinámicamente la cantidad de productos por categoría.
  /// Retorna un mapa con clave [nombreCategoría] y valor [conteo].
  Map<String, int> get _categoryCounts {
    final Map<String, int> counts = {'Todos': _allComponents.length};
    for (final item in _allComponents) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Filtra la colección de componentes en tiempo real evaluando:
  /// 1. Coincidencia de categoría seleccionada mediante List.where().
  /// 2. Coincidencia de la consulta de búsqueda en nombre, descripción o categoría.
  List<ComponentItem> get _filteredComponents {
    return _allComponents.where((item) {
      // Regla 1: Si es 'Todos', no filtra por categoría; caso contrario compara sin distinguir mayúsculas
      final matchesCategory = _selectedCategory == 'Todos' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Regla 2: Comprobación de texto ingresado en el buscador
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);

      // El elemento debe cumplir ambos criterios simultáneamente
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ===========================================================================
  // MÉTODOS DE MANIPULACIÓN DEL ESTADO (CRUD Y ACCIONES)
  // ===========================================================================

  /// Inserta un nuevo componente tecnológico al inicio de la colección.
  /// Notifica a la interfaz gráfica mediante setState() para forzar un re-render reactivo.
  void _addNewComponent(ComponentItem newComponent) {
    setState(() {
      _allComponents.insert(0, newComponent);
    });
  }

  /// Muestra un diálogo de confirmación para eliminar un componente.
  /// Si el usuario confirma, invoca la eliminación real [_executeDelete].
  void _deleteComponent(ComponentItem component) {
    showDialog<bool>(
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
          '¿Está seguro de eliminar "${component.name}" del catálogo institucional?',
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
    ).then((confirmed) {
      if (confirmed == true) {
        _executeDelete(component);
      }
    });
  }

  /// Ejecuta la eliminación en la lista maestra y despliega un SnackBar
  /// interactivo con acción de reversión (DESHACER / Undo).
  void _executeDelete(ComponentItem component) {
    final index = _allComponents.indexWhere((c) => c.id == component.id);
    if (index == -1) return;

    // Actualizamos el estado removiendo el elemento de la colección en memoria
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
              color: Colors.white,
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
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF991B1B), width: 1.2),
        ),
        // Opción reactiva de restauración temporal (Patrón Memento / Undo)
        action: SnackBarAction(
          label: 'DESHACER',
          textColor: Colors.yellowAccent,
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

  /// Abre una ventana modal inferior (BottomSheet) para listar y eliminar
  /// periféricos de forma específica, cumpliendo el requerimiento solicitado.
  void _showDeletePeripheralDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          // Filtrado en tiempo real de solo los periféricos disponibles
          final currentPeripherals = _allComponents
              .where((c) =>
                  c.category.toLowerCase() == 'periféricos' ||
                  c.category.toLowerCase() == 'perifericos')
              .toList();

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(color: AppTheme.borderMedium, width: 2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tirador táctil visual superior
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.trashCan,
                          color: Color(0xFFDC2626),
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Eliminar Periférico',
                        style: AppTheme.headingStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
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
                              color: Color(0xFF94A3B8),
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
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.borderMedium),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.getCategoryColor(item.category)
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
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
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.formattedPrice,
                                        style: AppTheme.bodyStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.priceGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    color: Color(0xFFDC2626),
                                    size: 16,
                                  ),
                                  tooltip: 'Eliminar ${item.name}',
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    _deleteComponent(item);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Navegación a la pantalla de detalle pasando el componente como argumento.
  /// Si la pantalla de detalle retorna el valor 'delete', se remueve el componente.
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
      // APPBAR: Barra superior corporativa SENATI con buscador interactivo
      // -----------------------------------------------------------------------
      appBar: AppBar(
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: AppTheme.bodyStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Buscar componente...',
                    hintStyle: AppTheme.bodyStyle(
                      color: Colors.white70,
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
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.cubes,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Catálogo SENATI',
                      style: AppTheme.headingStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, size: 22),
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
          const SizedBox(width: 6),
        ],
      ),
      // -----------------------------------------------------------------------
      // BODY: Contenedor responsive con filtros y ListView dinámica
      // -----------------------------------------------------------------------
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texto institucional de instrucción pedagógica
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
                    fontSize: isMobile ? 12 : 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderSubtle, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      // Indicador de cantidad de resultados actuales
                      Text(
                        '${filteredList.length} producto(s)',
                        style: AppTheme.bodyStyle(
                          fontSize: isMobile ? 11.5 : 12,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),

                      // Botón funcional: Eliminar Periférico
                      InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: _showDeletePeripheralDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFFCA5A5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.trashCan,
                                size: 11,
                                color: Color(0xFFDC2626),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isMobile ? 'Eliminar' : 'Eliminar periférico',
                                style: AppTheme.bodyStyle(
                                  fontSize: 11,
                                  color: const Color(0xFFDC2626),
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
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Text(
                              'Limpiar filtros',
                              style: AppTheme.bodyStyle(
                                fontSize: 11,
                                color: AppTheme.accentBlue,
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

              // Lista Dinámica de Componentes renderizada mediante ListView.builder
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(isMobile ? 18 : 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.borderMedium, width: 1.5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.borderSubtle, width: 1.5),
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: 24,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'No se encontraron componentes',
                                  style: AppTheme.headingStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No hay componentes que coincidan con "$_searchQuery"'
                                      : 'No hay elementos registrados en la categoría "$_selectedCategory"',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.bodyStyle(
                                    fontSize: 12.5,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.2),
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
      // FLOATING ACTION BUTTON: Botón flotante para invocar el formulario modal
      // -----------------------------------------------------------------------
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1E3A8A), width: 1.6),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryBlue,
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
            // Despliegue asíncrono del formulario modal
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
