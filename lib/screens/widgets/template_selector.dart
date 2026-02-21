import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/template.dart';
import '../../utils/storage_manager.dart';
import '../../utils/app_colors.dart';
import '../edit_screen.dart';

/// 模板选择器组件
class TemplateSelector extends StatefulWidget {
  final Function(String, String) onTemplateSelected;

  const TemplateSelector({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<TemplateSelector> createState() => _TemplateSelectorState();
}

class _TemplateSelectorState extends State<TemplateSelector> {
  /// 获取当前日期
  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final List<String> weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
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
  Widget build(BuildContext context) {
    // 缓存过滤后的模板列表，避免在构建过程中重复计算导致索引越界错误
    final allTemplates = Provider.of<AppProvider>(context).templates;
    final currentTemplateId = Provider.of<AppProvider>(context).currentTemplate.id;
    
    // 过滤竖向模板和横向模板
    final verticalTemplates = allTemplates.where((t) => !t.id.startsWith('pattern_horizontal')).toList();
    final horizontalTemplates = allTemplates.where((t) => t.id.startsWith('pattern_horizontal')).toList();
    
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        // 标题区域
        Column(
          children: [
            Text(
              '笺佳至',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '选择模板',
              style: TextStyle(
                fontSize: 24,
                color: const Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击选择喜欢的模板风格',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        
        // 竖向模板标题
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '竖向模板',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 竖向模板网格
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 每行3个模板
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2 / 3, // 竖向模板比例
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: verticalTemplates.length,
          itemBuilder: (context, index) {
            final template = verticalTemplates[index];
            final isSelected = template.id == currentTemplateId;

            return TemplateItem(
              template: template,
              isSelected: isSelected,
              onTap: () {
                // 点击模板时选中并直接进入编辑界面
                Provider.of<AppProvider>(context, listen: false).setCurrentTemplate(template);
                
                // 调用回调函数
                widget.onTemplateSelected(
                  _getCurrentDate(),
                  _getRandomSentence(),
                );
                
                // 直接跳转到编辑界面
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
            );
          },
        ),
        
        const SizedBox(height: 40),
        
        // 横向模板标题
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '横向模板',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 横向模板网格
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行2个模板
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 2, // 横向模板比例
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: horizontalTemplates.length,
          itemBuilder: (context, index) {
            final template = horizontalTemplates[index];
            final isSelected = template.id == currentTemplateId;

            return TemplateItem(
              template: template,
              isSelected: isSelected,
              onTap: () {
                // 点击模板时选中并直接进入编辑界面
                Provider.of<AppProvider>(context, listen: false).setCurrentTemplate(template);
                
                // 调用回调函数
                widget.onTemplateSelected(
                  _getCurrentDate(),
                  _getRandomSentence(),
                );
                
                // 直接跳转到编辑界面
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
            );
          },
        ),
        
        const SizedBox(height: 40), // 底部间距
      ],
    );
  }
}

/// 单个模板项组件
class TemplateItem extends StatefulWidget {
  final Template template;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateItem({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<TemplateItem> createState() => _TemplateItemState();
}

class _TemplateItemState extends State<TemplateItem> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      await StorageManager.initialize();
      final isFavorited = await StorageManager.isTemplateFavorited(widget.template.id);
      setState(() {
        _isFavorited = isFavorited;
      });
    } catch (e) {
      debugPrint('加载收藏状态失败: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await StorageManager.initialize();
      if (_isFavorited) {
        await StorageManager.removeFavoriteTemplate(widget.template.id);
      } else {
        await StorageManager.saveFavoriteTemplate(widget.template.id);
      }
      final bool newFavoritedState = !_isFavorited;
      setState(() {
        _isFavorited = newFavoritedState;
      });
      // 显示操作成功提示
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(newFavoritedState ? Icons.favorite : Icons.favorite_border, color: Colors.white),
              SizedBox(width: 12),
              Text(newFavoritedState ? '模板已添加到收藏' : '模板已取消收藏'),
            ],
          ),
          backgroundColor: newFavoritedState ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('切换收藏状态失败: $e');
    }
  }

  String _getTemplateName(String templateId) {
    switch (templateId) {
      // 竖向模板
      case 'pattern_1':
        return '清风笺';
      case 'pattern_2':
        return '明月笺';
      case 'pattern_3':
        return '岁月笺';
      case 'pattern_4':
        return '云舒笺';
      case 'pattern_5':
        return '花开笺';
      case 'pattern_6':
        return '流年笺';
      case 'pattern_7':
        return '安然笺';
      case 'pattern_8':
        return '田园笺';
      case 'pattern_9':
        return '云海笺';
      case 'pattern_10':
        return '古城笺';
      case 'pattern_11':
        return '晨雾笺';
      
      // 横向模板
      case 'pattern_horizontal_1':
        return '横向经典';
      case 'pattern_horizontal_2':
        return '横向风景';
      case 'pattern_horizontal_3':
        return '横向简约';
      case 'pattern_horizontal_4':
        return '横向文艺';
      case 'pattern_horizontal_5':
        return '横向现代';
      case 'pattern_horizontal_6':
        return '横向自然';
      case 'pattern_horizontal_7':
        return '横向城市';
      case 'pattern_horizontal_8':
        return '横向人物';
      case 'pattern_horizontal_9':
        return '横向建筑';
      case 'pattern_horizontal_10':
        return '横向花卉';
      
      default:
        return '星笺';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(widget.template.borderRadius),
        splashColor: const Color(0xFF4CAF50).withOpacity(0.3),
        highlightColor: const Color(0xFF4CAF50).withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(widget.template.backgroundColor),
            border: Border.all(
              color: widget.isSelected ? const Color(0xFF4CAF50) : HexColor(widget.template.borderColor),
              width: widget.isSelected ? 3 : widget.template.borderWidth,
            ),
            borderRadius: BorderRadius.circular(widget.template.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildTemplateItemPreview(widget.template),
                    if (widget.isSelected)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isFavorited ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: _isFavorited ? Colors.red : const Color(0xFF999999),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _getTemplateName(widget.template.id),
                  style: TextStyle(
                    fontFamily: 'XingKaiTi',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected ? const Color(0xFF4CAF50) : const Color(0xFF333333),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateItemPreview(Template template) {
    // 如果有图片路径，显示图片
    if (template.imagePath != null) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox.expand(
          child: Image.asset(
            template.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      );
    }
    
    // 默认布局
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.template.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: HexColor('#333333'),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// 辅助类：将十六进制颜色字符串转换为 Color
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
