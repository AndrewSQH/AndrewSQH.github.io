import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_provider.dart';
import '../providers/edit_provider.dart';
import '../utils/photo_picker.dart';
import '../utils/canvas_text_renderer.dart';
import '../utils/export_utils.dart';
import '../utils/storage_manager.dart';
import '../utils/error_handler.dart';
import '../utils/app_colors.dart';
import '../models/postcard.dart';
import '../models/template.dart';
import '../templates/template_data.dart';
import '../utils/image_utils.dart';
import '../utils/config_manager.dart';
import '../widgets/font_size_dialog.dart';

import 'profile_screen.dart';
import 'edit_screen.dart';
import 'message_screen.dart';
import 'privacy_policy_screen.dart';
import 'support_screen.dart';
import 'widgets/image_preview.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/inspiration_card_swiper.dart';
import 'widgets/app_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _processedImage;
  Uint8List? _imageBytes;
  String _dateText = '';
  String _sentenceText = '';
  bool _isImageZoomed = false;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    await StorageManager.initialize();
  }

  Future<void> _pickImage() async {
    // 直接跳转到编辑页面，不先选择图片
    // 用户可以在编辑界面中选择图片
    _openEditScreen();
  }

  Future<void> _exportImage() async {
    if (kIsWeb && _imageBytes == null) return;
    if (!kIsWeb && _processedImage == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final editProvider = Provider.of<EditProvider>(context, listen: false);
    appProvider.setLoading(true);

    try {
      // 显示导出提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('正在导出图片...'),
            ],
          ),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 5),
        ),
      );

      if (kIsWeb) {
        // Web平台导出
        // 使用CanvasTextRenderer处理图片，添加文字
        final Uint8List? processedBytes = await CanvasTextRenderer.addTextToImageWeb(
          _imageBytes!,
          _dateText,
          _sentenceText,
          dateText2: '',
          sentenceText2: '',
          brightness: editProvider.brightness,
          contrast: editProvider.contrast,
          saturation: editProvider.saturation,
          temperature: editProvider.temperature,
          fade: editProvider.fade,
          vignette: editProvider.vignette,
          blur: editProvider.blur,
          grain: editProvider.grain,
          sharpness: editProvider.sharpness,
          filterName: editProvider.currentFilter != 'original' ? editProvider.currentFilter : null,
          filterStrength: editProvider.filterStrength,
          templateId: appProvider.currentTemplate.id,
          croppedImagePosition: editProvider.croppedImagePosition,
          croppedImageScale: editProvider.croppedImageScale,
          textFont: editProvider.textFont,
          textFont2: editProvider.textFont2,
          textPosition: editProvider.textAlignment,
          textPosition2: editProvider.textAlignment2,
          textSize: editProvider.textSize,
          textSize2: editProvider.textSize2,
          backgroundColor: editProvider.backgroundColor,
        );
        if (processedBytes == null) {
          // 显示导出失败提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('处理图片失败，请重试'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
        
        // 由于Web平台的限制，我们使用ExportUtils的web导出方法
        final bool success = await ExportUtils.exportImageWeb(processedBytes);
        if (success) {
          // 保存到作品历史
          await _saveToHistory();
          // 显示导出成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('导出成功！图片已下载'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // 显示导出失败提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('导出失败，请重试'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // 移动平台导出
        // 首先使用CanvasTextRenderer处理图片，添加文字
        final File? processedImage = await CanvasTextRenderer.renderCanvas(
          _processedImage!,
          _dateText,
          _sentenceText,
          dateText2: '',
          sentenceText2: '',
          brightness: editProvider.brightness,
          contrast: editProvider.contrast,
          saturation: editProvider.saturation,
          temperature: editProvider.temperature,
          fade: editProvider.fade,
          vignette: editProvider.vignette,
          blur: editProvider.blur,
          grain: editProvider.grain,
          sharpness: editProvider.sharpness,
          filterName: editProvider.currentFilter != 'original' ? editProvider.currentFilter : null,
          filterStrength: editProvider.filterStrength,
          templateId: appProvider.currentTemplate.id,
          rotation: editProvider.rotation,
          croppedImagePosition: editProvider.croppedImagePosition,
          croppedImageScale: editProvider.croppedImageScale,
          textFont: editProvider.textFont,
          textFont2: editProvider.textFont2,
          textPosition: editProvider.textAlignment,
          textPosition2: editProvider.textAlignment2,
          textSize: editProvider.textSize,
          textSize2: editProvider.textSize2,
          flipHorizontal: editProvider.flipHorizontal,
          flipVertical: editProvider.flipVertical,
          borderColor: appProvider.currentTemplate.borderColor,
          backgroundColor: appProvider.currentTemplate.backgroundColor,
          borderWidth: appProvider.currentTemplate.borderWidth,
        );
        if (processedImage == null) {
          // 显示导出失败提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('处理图片失败，请重试'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
        
        // 导出图片
        final bool success = await ExportUtils.exportImage(processedImage);
        if (success) {
          // 保存到作品历史
          await _saveToHistory();
          // 显示导出成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('导出成功！图片已保存到相册'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // 显示导出失败提示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('导出失败，请重试'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      final errorHandler = ErrorHandler();
      errorHandler.handleError(
        context,
        e,
        ErrorType.imageProcessing,
        customMessage: '导出失败，请重试',
      );
    } finally {
      appProvider.setLoading(false);
    }
  }

  Future<void> _saveToHistory() async {
    if (kIsWeb && _imageBytes == null) return;
    if (!kIsWeb && _processedImage == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    final Postcard postcard = Postcard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: kIsWeb ? 'web_image_${DateTime.now().millisecondsSinceEpoch}' : _processedImage!.path,
      templateId: appProvider.currentTemplate.id,
      createdAt: DateTime.now(),
      dateText: _dateText,
      sentenceText: _sentenceText,
    );

    await StorageManager.savePostcard(postcard);
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final String weekday = weekdays[now.weekday - 1]; // now.weekday 范围是1-7，所以减1得到0-6的索引
    return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} $weekday';
  }

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

  void _openEditScreen() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // 先生成日期和短句
    _dateText = _getCurrentDate();
    _sentenceText = _getRandomSentence();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          imageBytes: null,
          imageFile: null,
          dateText: _dateText,
          sentenceText: _sentenceText,
          templateId: appProvider.currentTemplate.id,
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => FontSizeDialog(appProvider: appProvider),
    );
  }

  void _showSnackBar(String message, {Color backgroundColor = AppColors.primary}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: AppDrawer(
            onStoreTap: () {
              _showSnackBar('商店功能即将上线，敬请期待！');
            },
            onContactDeveloperTap: () {
              _showSnackBar('您可以通过邮箱联系我们：${AppConstants.contactEmail}');
            },
            onPrivacyPolicyTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            onTechnicalSupportTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(),
                ),
              );
            },
            onRateTap: () {
              _showSnackBar('感谢您的支持！您的好评是我们前进的动力 💖', backgroundColor: Colors.green);
            },
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3, // 设置透明度
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 顶部导航栏
                  _buildHeader(appProvider),
                  
                  // 中间模板预览区
                  Expanded(
                    child: _buildTemplatePreview(appProvider),
                  ),
                  
                  // 底部导航栏
                  BottomNavigation(
                    onPickImage: appProvider.isLoading ? null : _pickImage,
                    isImageSelected: _imageBytes != null || _processedImage != null,
                    onProfileTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                          settings: const RouteSettings(name: 'profile'),
                          fullscreenDialog: false,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppProvider appProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth > 800 ? 28 : screenWidth > 400 ? 24 : 20;
    final double fontSize = screenWidth > 800 ? 24 : screenWidth > 400 ? 20 : 18;
    final double paddingHorizontal = screenWidth > 800 ? 24 : screenWidth > 400 ? 16 : 12;
    final double paddingVertical = screenWidth > 800 ? 16 : screenWidth > 400 ? 12 : 10;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, size: iconSize),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          Text(
            '笺佳至',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.message_outlined, size: iconSize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatePreview(AppProvider appProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth > 800 ? 40 : screenWidth > 600 ? 30 : screenWidth > 400 ? 20 : 12;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: (kIsWeb && _imageBytes != null) || (!kIsWeb && _processedImage != null)
            ? _buildProcessedImage(appProvider)
            : InspirationCardSwiper(
                templates: TemplateData.getTemplates(),
                onCardTap: (template) {
                  appProvider.setCurrentTemplate(template);
                  setState(() {
                    _dateText = _getCurrentDate();
                    _sentenceText = _getRandomSentence();
                  });
                },
              ),
      ),
    );
  }

  Widget _buildProcessedImage(AppProvider appProvider) {
    return ImagePreview(
      processedImage: _processedImage,
      imageBytes: _imageBytes,
      isImageZoomed: _isImageZoomed,
      onDoubleTap: () {
        setState(() {
          _isImageZoomed = !_isImageZoomed;
        });
      },
    );
  }

}
