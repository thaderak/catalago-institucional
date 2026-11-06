import 'package:flutter/material.dart';
import '../data/initial_components.dart';
import '../theme/app_theme.dart';

/// Barra horizontal de FilterChips interactivos con bordes estilizados y tipografía moderna
class FilterChipBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final Map<String, int>? categoryCounts;

  const FilterChipBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
    this.categoryCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: catalogCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = catalogCategories[index];
          final isSelected = selectedCategory == category;
          final count = categoryCounts?[category];
          final catColor = AppTheme.getCategoryColor(category);

          return FilterChip(
            selected: isSelected,
            showCheckmark: false,
            backgroundColor: Colors.white,
            selectedColor: AppTheme.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            // Borde nítido acentuado en el FilterChip
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.borderMedium,
                width: 1.5,
              ),
            ),
            avatar: category != 'Todos'
                ? Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : catColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category,
                  style: AppTheme.bodyStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.1,
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.22)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : AppTheme.borderSubtle,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: AppTheme.bodyStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
