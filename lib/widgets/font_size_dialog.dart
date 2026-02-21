import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../providers/app_provider.dart';

class FontSizeDialog extends StatelessWidget {
  final AppProvider appProvider;

  const FontSizeDialog({
    super.key,
    required this.appProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                    width: 1,
                  ),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.format_size,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    '文字大小',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFontSizeOption(
                    context,
                    size: FontSize.small,
                    label: '小',
                    previewSize: 14,
                    isSelected: appProvider.fontSize == FontSize.small,
                    onTap: () {
                      appProvider.setFontSize(FontSize.small);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFontSizeOption(
                    context,
                    size: FontSize.medium,
                    label: '中',
                    previewSize: 16,
                    isSelected: appProvider.fontSize == FontSize.medium,
                    onTap: () {
                      appProvider.setFontSize(FontSize.medium);
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFontSizeOption(
                    context,
                    size: FontSize.large,
                    label: '大',
                    previewSize: 18,
                    isSelected: appProvider.fontSize == FontSize.large,
                    onTap: () {
                      appProvider.setFontSize(FontSize.large);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF0F0F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '取消',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(
    BuildContext context, {
    required FontSize size,
    required String label,
    required double previewSize,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: previewSize,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '示例文字',
                style: TextStyle(
                  fontSize: previewSize,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
