import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// 底部导航栏组件
class BottomNavigation extends StatelessWidget {
  final Future<void> Function()? onPickImage;
  final bool isImageSelected;
  final VoidCallback? onProfileTap;

  const BottomNavigation({
    super.key,
    required this.onPickImage,
    required this.isImageSelected,
    this.onProfileTap,
  });

  double _getBottomNavHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 120;
    } else if (screenWidth > 600) {
      return 110;
    } else if (screenWidth > 400) {
      return 100;
    } else {
      return 90;
    }
  }

  double _getButtonSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 80;
    } else if (screenWidth > 600) {
      return 75;
    } else if (screenWidth > 400) {
      return 70;
    } else {
      return 60;
    }
  }

  double _getIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return 40;
    } else if (screenWidth > 600) {
      return 38;
    } else if (screenWidth > 400) {
      return 35;
    } else {
      return 30;
    }
  }

  EdgeInsets _getBottomNavPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    } else if (screenWidth > 600) {
      return const EdgeInsets.symmetric(horizontal: 22, vertical: 18);
    } else if (screenWidth > 400) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  List<BoxShadow> _getBottomNavShadows() {
    return [
      BoxShadow(
        color: AppColors.shadow.withOpacity(0.15),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, -4),
      ),
      BoxShadow(
        color: AppColors.shadow.withOpacity(0.08),
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, -2),
      ),
    ];
  }

  List<BoxShadow> _getButtonShadows() {
    return [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.45),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: AppColors.primary.withOpacity(0.15),
        blurRadius: 10,
        spreadRadius: 0,
        offset: const Offset(0, 3),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavHeight = _getBottomNavHeight(context);
    final buttonSize = _getButtonSize(context);
    final iconSize = _getIconSize(context);
    final padding = _getBottomNavPadding(context);

    return Container(
      height: bottomNavHeight,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: _getBottomNavShadows(),
      ),
      child: Center(
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPickImage,
              borderRadius: BorderRadius.circular(buttonSize / 2),
              splashColor: AppColors.primary.withOpacity(0.3),
              highlightColor: AppColors.primary.withOpacity(0.2),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: _getButtonShadows(),
                ),
                child: AnimatedScale(
                  scale: isImageSelected ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.add,
                    size: iconSize,
                    color: Colors.white,
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
