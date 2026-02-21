import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/storage_manager.dart';
import '../utils/app_colors.dart';
import '../models/postcard.dart';
import '../models/template.dart';
import '../templates/template_data.dart';
import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Postcard> _postcards = [];
  List<Template> _favoriteTemplates = [];
  bool _isLoading = false;
  bool _isLoadingFavorites = false;
  int _currentTab = 0; // 0: 作品历史, 1: 收藏模板

  /// 获取当前日期
  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final String weekday = weekdays[now.weekday - 1]; // now.weekday 范围是1-7，所以减1得到0-6的索引
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} $weekday';
  }

  /// 获取随机句子
  String _getRandomSentence() {
    final List<String> sentences = [
      '风很温柔',
      '阳光正好',
      '岁月静好',
      '人间值得',
      '未来可期',
      '万物可爱',
      '平安喜乐',
      '温暖如初',
      '一切顺利',
      '心想事成',
      '时光荏苒',
      '岁月如歌',
      '花开四季',
      '云卷云舒',
      '潮起潮落',
    ];
    return sentences[DateTime.now().millisecondsSinceEpoch % sentences.length];
  }

  @override
  void initState() {
    super.initState();
    _loadPostcards();
    _loadFavoriteTemplates();
  }

  Future<void> _loadFavoriteTemplates() async {
    setState(() {
      _isLoadingFavorites = true;
    });

    try {
      await StorageManager.initialize();
      final List<String> favoriteTemplateIds = await StorageManager.getFavoriteTemplates();
      final List<Template> allTemplates = TemplateData.getTemplates();
      final List<Template> favorites = allTemplates.where((template) => favoriteTemplateIds.contains(template.id)).toList();
      setState(() {
        _favoriteTemplates = favorites;
      });
    } catch (e) {
      print('加载收藏模板失败: $e');
    } finally {
      setState(() {
        _isLoadingFavorites = false;
      });
    }
  }

  Future<void> _removeFavoriteTemplate(String templateId) async {
    try {
      await StorageManager.removeFavoriteTemplate(templateId);
      await _loadFavoriteTemplates();
      // 显示删除成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 12),
              Text('模板已取消收藏'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('移除收藏模板失败: $e');
    }
  }

  Future<void> _loadPostcards() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await StorageManager.initialize();
      final List<Postcard> postcards = StorageManager.getAllPostcards();
      setState(() {
        _postcards = postcards.reversed.toList(); // 按时间倒序排列
      });
    } catch (e) {
      print('加载作品失败: $e');
      // 这里可以添加错误提示，但由于是在初始化时，可能不需要显示给用户
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePostcard(String id) async {
    try {
      await StorageManager.deletePostcard(id);
      await _loadPostcards();
    } catch (e) {
      print('删除作品失败: $e');
    }
  }

  Future<void> _clearCache() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('清除缓存'),
          content: const Text('确定要清除所有缓存和作品历史吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await StorageManager.clearCache();
                await _loadPostcards();
                _showClearCacheSuccess();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('缓存已清除'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAboutUs() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('关于我们'),
          content: const Text(
            '笺佳至\n\n让记录与美好更简单\n\n让每一张照片都成为一张好看的明信片\n\n版本 1.0.0',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5F0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Color(0xFF333333),
          ),
        ),
        title: const Text(
          '个人中心',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 用户头像和标题
              _buildHeader(),
              
              // 标签页切换
              _buildTabBar(),
              
              // 内容区域
              Expanded(
                child: _currentTab == 0 ? _buildPostcardHistory() : _buildFavoriteTemplates(),
              ),
              
              // 底部操作按钮
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentTab = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentTab == 0 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    '作品历史',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _currentTab == 0 ? FontWeight.bold : FontWeight.normal,
                      color: _currentTab == 0 ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentTab = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _currentTab == 1 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    '收藏模板',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _currentTab == 1 ? FontWeight.bold : FontWeight.normal,
                      color: _currentTab == 1 ? Colors.white : const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteTemplates() {
    if (_isLoadingFavorites) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3,
        ),
      );
    }

    if (_favoriteTemplates.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 20),
            Text(
              '暂无收藏模板',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '在模板选择页面收藏你喜欢的模板',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFCCCCCC),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: _favoriteTemplates.length,
      itemBuilder: (context, index) {
        final template = _favoriteTemplates[index];
        
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          opacity: 1.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // 点击收藏模板进入编辑页面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      imageBytes: null,
                      imageFile: null,
                      dateText: _getCurrentDate(),
                      sentenceText: _getRandomSentence(),
                      templateId: template.id,
                    ),
                  ),
                );
              },
              onLongPress: () {
                _removeFavoriteTemplate(template.id);
              },
              borderRadius: BorderRadius.circular(8),
              splashColor: AppColors.primary.withOpacity(0.3),
              highlightColor: AppColors.primary.withOpacity(0.1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: template.backgroundColor.isNotEmpty ? Color(int.parse(template.backgroundColor.replaceAll('#', '0xFF'))) : Colors.white,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 模拟模板预览
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: template.borderColor.isNotEmpty ? Color(int.parse(template.borderColor.replaceAll('#', '0xFF'))) : Colors.black,
                                    width: template.borderWidth,
                                  ),
                                  borderRadius: BorderRadius.circular(template.borderRadius),
                                  color: Colors.grey[200],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                template.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 收藏图标
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // 点击提示
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              '点击进入编辑',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            opacity: 1.0,
            child: const Text(
              '作品历史',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostcardHistory() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (_postcards.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 60,
                color: Color(0xFFCCCCCC),
              ),
              SizedBox(height: 20),
              Text(
                '暂无作品',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF999999),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '开始创建你的第一张明信片吧',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCCCCCC),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemCount: _postcards.length,
        itemBuilder: (context, index) {
          final postcard = _postcards[index];
          
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            opacity: 1.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onLongPress: () {
                  _deletePostcard(postcard.id);
                  // 显示删除成功提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 12),
                          Text('作品已删除'),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                splashColor: AppColors.primary.withOpacity(0.3),
                highlightColor: AppColors.primary.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(postcard.imagePath),
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF0F0F0),
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 40,
                              color: Color(0xFFCCCCCC),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _clearCache,
              borderRadius: BorderRadius.circular(8),
              splashColor: AppColors.primary.withOpacity(0.3),
              highlightColor: AppColors.primary.withOpacity(0.1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '清除缓存',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showAboutUs,
              borderRadius: BorderRadius.circular(8),
              splashColor: AppColors.primary.withOpacity(0.3),
              highlightColor: AppColors.primary.withOpacity(0.1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '关于我们',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
