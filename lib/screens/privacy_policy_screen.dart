import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/config_manager.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '隐私协议',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('隐私政策'),
            const SizedBox(height: 16),
            _buildSectionContent(
              '感谢您使用笺佳至应用。我们非常重视您的隐私保护，本隐私政策详细说明了我们如何收集、使用、存储和保护您的个人信息。',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('信息收集'),
            const SizedBox(height: 16),
            _buildSectionContent(
              '1. 图片信息：我们仅在您主动选择图片时访问您的相册，这些图片仅在本地处理，不会上传到服务器。\n\n'
              '2. 存储信息：应用会在本地存储您创建的明信片作品历史记录，方便您随时查看和导出。\n\n'
              '3. 设备信息：我们可能会收集一些基本的设备信息，用于优化应用性能和用户体验。',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('信息使用'),
            const SizedBox(height: 16),
            _buildSectionContent(
              '我们收集的信息仅用于以下目的：\n\n'
              '- 提供应用的核心功能服务\n'
              '- 改善和优化用户体验\n'
              '- 解决技术问题和提供技术支持',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('信息保护'),
            const SizedBox(height: 16),
            _buildSectionContent(
              '我们采取严格的技术措施保护您的个人信息安全：\n\n'
              '- 所有数据存储在您的设备本地\n'
              '- 不会将您的个人信息上传到任何第三方服务器\n'
              '- 不会向任何第三方出售或分享您的个人信息',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('联系我们'),
            const SizedBox(height: 16),
            _buildSectionContent(
              '如果您对本隐私政策有任何疑问，请通过以下方式联系我们：\n\n'
              '- 邮箱：${AppConstants.contactEmail}',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 15,
        height: 1.6,
        color: AppColors.textSecondary,
      ),
    );
  }
}
