import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MarginControls extends StatefulWidget {
  final double marginLeft;
  final ValueChanged<double> onMarginLeftChanged;
  final double marginRight;
  final ValueChanged<double> onMarginRightChanged;
  final double marginTop;
  final ValueChanged<double> onMarginTopChanged;
  final double marginBottom;
  final ValueChanged<double> onMarginBottomChanged;
  final VoidCallback onReset;

  const MarginControls({
    super.key,
    required this.marginLeft,
    required this.onMarginLeftChanged,
    required this.marginRight,
    required this.onMarginRightChanged,
    required this.marginTop,
    required this.onMarginTopChanged,
    required this.marginBottom,
    required this.onMarginBottomChanged,
    required this.onReset,
  });

  @override
  State<MarginControls> createState() => _MarginControlsState();
}

class _MarginControlsState extends State<MarginControls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildMarginSlider('左边距', widget.marginLeft, widget.onMarginLeftChanged),
        const SizedBox(height: 16),
        _buildMarginSlider('右边距', widget.marginRight, widget.onMarginRightChanged),
        const SizedBox(height: 16),
        _buildMarginSlider('上边距', widget.marginTop, widget.onMarginTopChanged),
        const SizedBox(height: 16),
        _buildMarginSlider('下边距', widget.marginBottom, widget.onMarginBottomChanged),
        const SizedBox(height: 16),
        _buildResetButton(),
      ],
    );
  }

  Widget _buildMarginSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              value.round().toString(),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.sliderActive,
            inactiveTrackColor: AppColors.sliderInactive,
            thumbColor: AppColors.sliderThumb,
            overlayColor: AppColors.primary.withAlpha(51),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return Center(
      child: ElevatedButton(
        onPressed: widget.onReset,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '重置留白',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
