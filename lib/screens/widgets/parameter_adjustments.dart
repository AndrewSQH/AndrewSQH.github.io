import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ParameterAdjustments extends StatefulWidget {
  final List<Map<String, dynamic>> adjustments;
  final String? selectedAdjustment;
  final ValueChanged<String> onAdjustmentSelected;
  final ValueChanged<double> onAdjustmentChanged;

  const ParameterAdjustments({
    super.key,
    required this.adjustments,
    required this.selectedAdjustment,
    required this.onAdjustmentSelected,
    required this.onAdjustmentChanged,
  });

  @override
  State<ParameterAdjustments> createState() => _ParameterAdjustmentsState();
}

class _ParameterAdjustmentsState extends State<ParameterAdjustments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.adjustments.length,
            itemBuilder: (context, index) {
              final adjustment = widget.adjustments[index];
              return GestureDetector(
                onTap: () {
                  widget.onAdjustmentSelected(adjustment['label']);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: widget.selectedAdjustment == adjustment['label'] ? AppColors.primary : AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: widget.selectedAdjustment == adjustment['label'] ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ] : [],
                        ),
                        child: Text(
                          adjustment['label'],
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.selectedAdjustment == adjustment['label'] ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        widget.selectedAdjustment != null ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.selectedAdjustment!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(widget.adjustments.firstWhere((adj) => adj['label'] == widget.selectedAdjustment)['value'] * 100).round()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: widget.adjustments.firstWhere((adj) => adj['label'] == widget.selectedAdjustment)['value'],
                  min: widget.adjustments.firstWhere((adj) => adj['label'] == widget.selectedAdjustment)['min'],
                  max: widget.adjustments.firstWhere((adj) => adj['label'] == widget.selectedAdjustment)['max'],
                  onChanged: (value) {
                    widget.onAdjustmentChanged(value);
                  },
                  activeColor: AppColors.sliderActive,
                  inactiveColor: AppColors.sliderInactive,
                  thumbColor: AppColors.sliderThumb,
                  overlayColor: WidgetStateProperty.all(AppColors.primary.withAlpha(76)),
                ),
              ],
            ),
          ) : Container(),
      ],
    );
  }
}
