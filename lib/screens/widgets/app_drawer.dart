import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onStoreTap;
  final VoidCallback? onContactDeveloperTap;
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTechnicalSupportTap;
  final VoidCallback? onRateTap;

  const AppDrawer({
    super.key,
    this.onStoreTap,
    this.onContactDeveloperTap,
    this.onPrivacyPolicyTap,
    this.onTechnicalSupportTap,
    this.onRateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMenuItem(
                icon: Icons.storefront,
                title: '商店',
                onTap: onStoreTap,
              ),
              _buildMenuItem(
                icon: Icons.mail_outline,
                title: '联系开发者',
                onTap: onContactDeveloperTap,
              ),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: '隐私协议',
                onTap: onPrivacyPolicyTap,
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: '技术支持',
                onTap: onTechnicalSupportTap,
              ),
              _buildMenuItem(
                icon: Icons.favorite_border,
                title: '给个好评',
                onTap: onRateTap,
                isHighlighted: true,
              ),
              const Spacer(),
              _buildFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: AppColors.warmGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.edit,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '笺佳至',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '让每一张照片都成为一张好看的明信片',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: isHighlighted 
              ? AppColors.primary.withOpacity(0.3) 
              : AppColors.primary.withOpacity(0.2),
          highlightColor: isHighlighted 
              ? AppColors.primary.withOpacity(0.15) 
              : AppColors.primary.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isHighlighted 
                  ? AppColors.primary.withOpacity(0.08) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isHighlighted ? FontWeight.w500 : FontWeight.normal,
                      color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isHighlighted)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text(
              '❤️',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '喜欢这个应用？',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '给个好评支持一下吧～',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
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
}
