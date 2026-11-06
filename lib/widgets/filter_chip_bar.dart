import 'package:flutter/material.dart';
import '../data/initial_components.dart';
import '../theme/app_theme.dart';

/// Barra horizontal de FilterChips interactivos con estética Obsidian y Cyber Glow
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
            backgroundColor: const Color(0xFF111A2D),
            selectedColor: AppTheme.accentIndigo,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? AppTheme.accentIndigo : AppTheme.borderMedium,
                width: isSelected ? 1.5 : 1.2,
              ),
            ),
            avatar: category != 'Todos'
                ? Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : catColor,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.6),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                  )
                : null,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category,
                  style: AppTheme.bodyStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
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
                          : const Color(0xFF1E293B),
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
