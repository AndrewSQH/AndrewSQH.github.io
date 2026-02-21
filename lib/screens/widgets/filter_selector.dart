import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FilterSelector extends StatefulWidget {
  final List<String> filters;
  final Map<String, String> filterNames;
  final String currentFilter;
  final double filterStrength;
  final ValueChanged<String> onFilterSelected;
  final ValueChanged<double> onFilterStrengthChanged;

  const FilterSelector({
    super.key,
    required this.filters,
    required this.filterNames,
    required this.currentFilter,
    required this.filterStrength,
    required this.onFilterSelected,
    required this.onFilterStrengthChanged,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  int _currentFilterGroup = 0;

  String _getFilterIconText(String filter) {
    if (widget.filterNames.containsKey(filter)) {
      final chineseName = widget.filterNames[filter]!;
      for (int i = 0; i < chineseName.length; i++) {
        final char = chineseName[i];
        if (char.trim().isNotEmpty) {
          return char;
        }
      }
    }
    return filter.isNotEmpty ? filter[0] : '?';
  }

  void _nextFilterGroup() {
    setState(() {
      // 由于现在是自适应布局，不再需要分组，只需要一个简单的循环
      _currentFilterGroup = (_currentFilterGroup + 1) % 2; // 简单的左右切换
    });
  }

  void _previousFilterGroup() {
    setState(() {
      // 由于现在是自适应布局，不再需要分组，只需要一个简单的循环
      _currentFilterGroup = (_currentFilterGroup - 1 + 2) % 2; // 简单的左右切换
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: Row(
            children: [
              GestureDetector(
                onTap: _previousFilterGroup,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.arrow_left,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 根据屏幕宽度计算每行可以显示的滤镜数量
                    // 每个滤镜的宽度约为 50（包含间距）
                    final screenWidth = constraints.maxWidth;
                    final filtersPerRow = (screenWidth / 50).floor();
                    
                    // 根据计算出的数量和当前分组选择要显示的滤镜
                    final startIndex = _currentFilterGroup * filtersPerRow;
                    final endIndex = startIndex + filtersPerRow;
                    final displayFilters = widget.filters.sublist(
                      startIndex,
                      endIndex > widget.filters.length ? widget.filters.length : endIndex
                    );
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: displayFilters.map((filter) {
                        final isSelected = widget.currentFilter == filter;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.onFilterSelected(filter);
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? AppColors.success : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFFF0F0F0),
                                ),
                                child: Center(
                                  child: Text(
                                    _getFilterIconText(filter),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? AppColors.success : AppColors.textHint,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.filterNames[filter] ?? filter,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected ? AppColors.success : AppColors.textHint,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _nextFilterGroup,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.arrow_right,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '强度',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${(widget.filterStrength * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Slider(
              value: widget.filterStrength,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              activeColor: AppColors.sliderActive,
              inactiveColor: AppColors.sliderInactive,
              onChanged: (value) {
                widget.onFilterStrengthChanged(value);
              },
            ),
          ],
        ),
      ],
    );
  }
}
