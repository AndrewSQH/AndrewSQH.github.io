import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/edit_provider.dart';
import '../models/template.dart';
import '../utils/canvas_text_renderer.dart';
import '../utils/export_utils.dart';
import '../utils/storage_manager.dart';
import '../utils/error_handler.dart';
import '../utils/image_utils.dart';
import '../utils/image_cache.dart';
import '../utils/photo_picker.dart';
import '../utils/app_colors.dart';
import '../widgets/text_draggable.dart';
import '../widgets/image_draggable.dart';
import '../widgets/adjustment_slider.dart';
import '../widgets/free_crop_dialog.dart';
import './widgets/edit_tools.dart';

/// 画布尺寸辅助类
/// 
/// 用于封装画布的宽度和高度，提高代码可读性
class CanvasSize {
  /// 画布宽度
  final double width;
  
  /// 画布高度
  final double height;
  
  const CanvasSize({
    required this.width,
    required this.height,
  });
}

/// 编辑屏幕常量
class EditScreenConstants {
  /// 主背景色
  static const Color backgroundColor = AppColors.background;
  
  /// 文本颜色
  static const Color textColor = AppColors.textPrimary;
  
  /// 次要文本颜色
  static const Color secondaryTextColor = AppColors.textSecondary;
  
  /// 主色调
  static const Color primaryColor = AppColors.primary;
  
  /// 成功颜色
  static const Color successColor = AppColors.success;
  
  /// 错误颜色
  static const Color errorColor = AppColors.error;
  
  /// 警告颜色
  static const Color warningColor = AppColors.warning;
  
  /// 加载动画持续时间
  static const Duration loadingDuration = Duration(seconds: 5);
  
  /// 保存动画持续时间
  static const Duration saveDuration = Duration(seconds: 3);
  
  /// 动画持续时间
  static const Duration animationDuration = Duration(milliseconds: 400);
  
  /// 性能优化建议：
  /// 
  /// 1. 状态管理优化：
  ///    - 使用 Selector 替代 Provider.of，精确订阅需要的状态
  ///    - 只在值真正改变时才调用 notifyListeners
  ///    - 使用防抖/节流机制优化频繁操作
  /// 
  /// 2. 渲染优化：
  ///    - 使用 RepaintBoundary 隔离重绘区域
  ///    - 使用 const 构造函数减少不必要的 Widget 重建
  ///    - 缓存计算结果，避免重复计算
  /// 
  /// 3. 内存优化：
  ///    - 及时清理不再使用的资源
  ///    - 限制历史记录数量
  ///    - 使用缓存机制时注意缓存大小
  /// 
  /// 4. 画布优化：
  ///    - 避免在 build 方法中进行复杂计算
  ///    - 使用 CustomPainter 时实现 shouldRepaint
  ///    - 合理使用 Picture 缓存
  /// 
  /// 5. 拖动优化：
  ///    - 使用 GestureDetector 的 behavior 参数优化事件处理
  ///    - 避免在拖动过程中频繁保存历史记录
  ///    - 使用节流机制限制状态更新频率
}


class EditScreen extends StatefulWidget {
  final Uint8List? imageBytes; // Web平台使用
  final File? imageFile; // 移动平台使用
  final String dateText;
  final String sentenceText;
  final String templateId; // 模板ID
  final Offset? croppedPosition; // 裁剪后的位置
  final double? croppedScale; // 裁剪后的缩放

  const EditScreen({
    super.key,
    this.imageBytes,
    this.imageFile,
    required this.dateText,
    required this.sentenceText,
    required this.templateId,
    this.croppedPosition,
    this.croppedScale,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // 用于捕获Widget渲染结果的GlobalKey
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  
  // 图片数据状态变量
  Uint8List? _currentImageBytes;
  File? _currentImageFile;
  
  // 编辑参数
  double _brightness = 0.0;
  double _contrast = 0.0;
  double _saturation = 0.0;
  double _temperature = 0.0; // 色温
  double _fade = 0.0; // 褪色
  double _vignette = 0.0; // 暗角
  double _blur = 0.0; // 模糊
  double _grain = 0.0; // 颗粒
  double _sharpness = 0.0;
  String _currentFilter = 'original';
  
  // 留白参数
  double _marginLeft = 0.0;
  double _marginRight = 0.0;
  double _marginTop = 0.0;
  double _marginBottom = 0.0;
  double _filterStrength = 0.5; // 滤镜强度 (0.0-1.0)
  double _rotation = 0.0; // 旋转角度
  bool _flipHorizontal = false; // 水平翻转
  bool _flipVertical = false; // 垂直翻转
  bool _isImageZoomed = false; // 是否缩放图片
  String? _selectedAdjustment; // 当前选中的调整参数
  late Offset _croppedImagePosition; // 裁剪后的图片位置
  late double _croppedImageScale; // 裁剪后的图片缩放

  String _currentTool = 'canvas'; // 当前选中的工具
  String _templateId = ''; // 当前模板ID
  
  // 文字调节参数
  String _textFont = 'default'; // 文字字体
  String _textPosition = 'center'; // 文字位置：left, center, right
  double _textSize = 16.0; // 文字大小
  
  // 性能优化：滤镜颜色缓存
  // 缓存滤镜颜色结果，避免重复计算
  static final Map<String, Color> _filterColorCache = {};
  static String? _lastFilterName;
  static double? _lastFilterStrength;
  
  // 可选字体列表
  final List<Map<String, String>> _fontOptions = [
    {'value': 'default', 'label': '默认'},
    {'value': 'QingChaKaiTi', 'label': '清茶楷体'},
    {'value': 'XingKaiTi', 'label': '行楷体'},
    {'value': 'LongCang', 'label': '龙藏体'},
    {'value': 'MaShanZheng', 'label': '马善政'},
    {'value': 'ZhiMangXing', 'label': '织芒星'},
    {'value': 'SourceHanSansCN', 'label': '思源黑体'},
    {'value': 'SourceHanSerifCN', 'label': '思源宋体'},
    {'value': 'FangZhengSong', 'label': '方正书宋'},
    {'value': 'FangZhengKai', 'label': '方正楷体'},
    {'value': 'FangZhengHei', 'label': '方正黑体'},
    {'value': 'ZhanKuGaoDuanHei', 'label': '站酷高端黑'},
    {'value': 'ZhanKuKuaiLeTi', 'label': '站酷快乐体'},
    {'value': 'ZhanKuWenYiTi', 'label': '站酷文艺体'},
    {'value': 'WangHanZongKai', 'label': '王汉宗楷体'},
    {'value': 'YanShiFoXiTi', 'label': '演示佛系体'},
    {'value': 'YanShiXiaXingKai', 'label': '演示夏行楷'},
    {'value': 'PangMenZhengDaoBiaoTi', 'label': '庞门正道标题'},
    {'value': 'AlibabaPuHuiTi', 'label': '阿里巴巴普惠体'},
    {'value': 'MuYaoRuanBi', 'label': '沐瑶软笔'},
    {'value': 'MuYaoSuiXin', 'label': '沐瑶随心'},
    {'value': 'HuXiaoBoNanShen', 'label': '胡晓波男神体'},
  ];
  
  // 画布元素位置
  Offset _imagePosition = Offset.zero; // 图片位置
  Offset _textOffset = Offset(0, 100); // 文字位置
  bool _isDraggingImage = false; // 是否正在拖动图片
  bool _isDraggingText = false; // 是否正在拖动文字
  Offset _lastDragOffset = Offset.zero; // 上次拖动的偏移量
  
  // 滤镜列表
  final List<String> _filters = [
    'original', 'amaro', 'antique', 'beauty', 'blackcat', 'brannan', 'brooklyn',
    'calm', 'cool', 'crayon', 'earlybird', 'emerald', 'evergreen', 'freud',
    'healthy', 'hefe', 'hudson', 'inkwell', 'kevin_new', 'latte', 'lomo',
    'n1977', 'nashville', 'nostalgia', 'pixar', 'rise', 'romance', 'sakura',
    'sierra', 'sketch', 'skinwhiten', 'sugar_tablets', 'sunrise', 'sunset', 'sutro',
    'sweets', 'tender', 'toaster2_filter_shader', 'valencia', 'walden', 'warm',
    'whitecat', 'xproii_filter_shader', 'abao', 'charm', 'elegant', 'fandel',
    'floral', 'iris', 'juicy', 'lord_kelvin', 'mystical', 'peach', 'pomelo',
    'rococo', 'snowy', 'summer', 'sweet', 'toaster'
  ];

  // 滤镜名称映射使用 EditProvider 中的映射
  // 避免重复定义

  @override
  void initState() {
    super.initState();
    
    // 在 initState 中使用强制重置方法初始化状态
    // 确保每次创建新明信片时都使用默认参数，不受之前模板状态影响
    final editProvider = Provider.of<EditProvider>(context, listen: false);
    
    editProvider.initializeStateReset(
      templateId: widget.templateId,
      croppedImagePosition: widget.croppedPosition ?? Offset.zero,
      croppedImageScale: widget.croppedScale ?? 1.0,
      currentImageBytes: widget.imageBytes,
      currentImageFile: widget.imageFile,
      dateText: widget.dateText,
      sentenceText: widget.sentenceText,
      dateText2: '',
      sentenceText2: '',
    );
  }

  @override
  void dispose() {
    // 页面销毁时清理资源
    // 清理图片缓存，释放内存
    final cacheManager = ImageCacheManager();
    cacheManager.clearMemoryCache();
    super.dispose();
  }

  // 保存编辑后的图片
  Future<void> _saveImage(BuildContext context, AppProvider appProvider, EditProvider editProvider) async {
    appProvider.setLoading(true);

    try {
      // 显示保存提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
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
              Text('正在保存图片...'),
            ],
          ),
          backgroundColor: EditScreenConstants.primaryColor,
          duration: EditScreenConstants.loadingDuration,
        ),
      );

      // 使用RepaintBoundary捕获Widget渲染结果
      if (_repaintBoundaryKey.currentContext == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('捕获图片失败，请重试'),
            backgroundColor: EditScreenConstants.errorColor,
            duration: EditScreenConstants.saveDuration,
          ),
        );
        return;
      }
      
      final boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      // 使用高分辨率捕获
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('捕获图片失败，请重试'),
            backgroundColor: EditScreenConstants.errorColor,
            duration: EditScreenConstants.saveDuration,
          ),
        );
        return;
      }
      
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // 导出图片
      if (kIsWeb) {
        // Web平台处理
        final bool success = await ExportUtils.exportImageWeb(pngBytes);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存成功！图片已下载'),
              backgroundColor: EditScreenConstants.successColor,
              duration: EditScreenConstants.saveDuration,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请重试'),
              backgroundColor: EditScreenConstants.errorColor,
              duration: EditScreenConstants.saveDuration,
            ),
          );
        }
      } else {
        // 移动平台处理
        final File outputFile = File('${widget.imageFile?.path ?? 'temp'}_exported.png');
        await outputFile.writeAsBytes(pngBytes);
        
        final bool success = await ExportUtils.exportImage(outputFile);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存成功！图片已保存到相册'),
              backgroundColor: EditScreenConstants.successColor,
              duration: EditScreenConstants.saveDuration,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请重试'),
              backgroundColor: EditScreenConstants.errorColor,
              duration: EditScreenConstants.saveDuration,
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
        customMessage: '保存失败，请重试',
      );
    } finally {
      appProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 性能优化：使用 Selector 精确订阅需要的状态，避免不必要的重建
    // 只有当 isLoading 状态改变时才重建 AppBar
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    return Scaffold(
      backgroundColor: EditScreenConstants.backgroundColor,
      appBar: _buildAppBar(context, appProvider),
      body: SafeArea(
        child: Column(
          children: [
            // 图片预览区
            Expanded(
              child: _buildImagePreviewSelector(),
            ),
            
            // 编辑工具区 - 使用 Selector 优化
            Selector<EditProvider, Map<String, dynamic>>(
              selector: (_, provider) => {
                'currentTool': provider.currentTool,
                'currentFilter': provider.currentFilter,
                'filterStrength': provider.filterStrength,
                'selectedAdjustment': provider.selectedAdjustment,
                'canUndo': provider.canUndo,
                'canRedo': provider.canRedo,
                'textFont': provider.textFont,
                'textFont2': provider.textFont2,
                'textAlignment': provider.textAlignment,
                'textAlignment2': provider.textAlignment2,
                'textSize': provider.textSize,
                'textSize2': provider.textSize2,
                'dateText': provider.dateText,
                'dateText2': provider.dateText2,
                'sentenceText': provider.sentenceText,
                'sentenceText2': provider.sentenceText2,
                'textColor': provider.textColor,
                'textColor2': provider.textColor2,
                'textDirection': provider.textDirection,
                'textDirection2': provider.textDirection2,
              },
              builder: (context, state, child) {
                final editProvider = Provider.of<EditProvider>(context, listen: false);
                return _buildEditTools(editProvider, state);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建 AppBar
  /// 
  /// 性能优化：使用 Selector 精确订阅 canUndo 和 canRedo 状态
  PreferredSizeWidget _buildAppBar(BuildContext context, AppProvider appProvider) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Selector<EditProvider, ({bool canUndo, bool canRedo})>(
        selector: (_, provider) => (canUndo: provider.canUndo, canRedo: provider.canRedo),
        builder: (context, state, _) {
          final editProvider = Provider.of<EditProvider>(context, listen: false);
          return AppBar(
          backgroundColor: EditScreenConstants.backgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 28,
              color: EditScreenConstants.textColor,
            ),
          ),
          title: const Text(''),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: appProvider.isLoading || !state.canUndo ? null : () {
                editProvider.undo();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.undo,
                  size: 20,
                  color: state.canUndo ? EditScreenConstants.textColor : EditScreenConstants.secondaryTextColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: appProvider.isLoading || !state.canRedo ? null : () {
                editProvider.redo();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.redo,
                  size: 20,
                  color: state.canRedo ? EditScreenConstants.textColor : EditScreenConstants.secondaryTextColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: appProvider.isLoading ? null : () => _saveImage(context, appProvider, editProvider),
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.save,
                  size: 24,
                  color: EditScreenConstants.textColor,
                ),
              ),
            ),
          ],
        );
      },
    ),
    );
  }

  /// 构建图片预览区域（使用 Selector 优化）
  /// 
  /// 性能优化：只订阅影响画布渲染的关键状态
  Widget _buildImagePreviewSelector() {
    return Selector<EditProvider, Map<String, dynamic>>(
      selector: (_, provider) => {
        'currentImageBytes': provider.currentImageBytes,
        'currentImageFile': provider.currentImageFile,
        'backgroundColor': provider.backgroundColor,
        'canvasAspectRatio': provider.canvasAspectRatio,
        'croppedImagePosition': provider.croppedImagePosition,
        'croppedImageScale': provider.croppedImageScale,
        'currentFilter': provider.currentFilter,
        'filterStrength': provider.filterStrength,
        'brightness': provider.brightness,
        'contrast': provider.contrast,
        'saturation': provider.saturation,
        'temperature': provider.temperature,
        'fade': provider.fade,
        'vignette': provider.vignette,
        'blur': provider.blur,
        'grain': provider.grain,
        'sharpness': provider.sharpness,
        'flipHorizontal': provider.flipHorizontal,
        'flipVertical': provider.flipVertical,
        'rotation': provider.rotation,
        'dateText': provider.dateText,
        'sentenceText': provider.sentenceText,
        'dateText2': provider.dateText2,
        'sentenceText2': provider.sentenceText2,
        'textFont': provider.textFont,
        'textFont2': provider.textFont2,
        'textAlignment': provider.textAlignment,
        'textAlignment2': provider.textAlignment2,
        'textSize': provider.textSize,
        'textSize2': provider.textSize2,
        'textColor': provider.textColor,
        'textColor2': provider.textColor2,
        'textDirection': provider.textDirection,
        'textDirection2': provider.textDirection2,
        'textPosition': provider.textPosition,
        'textPosition2': provider.textPosition2,
      },
      builder: (context, state, child) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        final editProvider = Provider.of<EditProvider>(context, listen: false);
        return _buildImagePreview(appProvider, editProvider);
      },
    );
  }

  /// 构建编辑工具区域
  /// 
  /// 性能优化：将工具栏构建逻辑独立出来，减少重建范围
  Widget _buildEditTools(EditProvider editProvider, Map<String, dynamic> state) {
    final adjustments = _buildAdjustmentsList(editProvider);
    
    return EditTools(
      currentTool: state['currentTool'] as String,
      onToolChanged: (tool) {
        editProvider.setCurrentTool(tool);
      },
      filters: editProvider.filters,
      filterNames: editProvider.filterNames,
      currentFilter: state['currentFilter'] as String,
      filterStrength: state['filterStrength'] as double,
      onFilterSelected: (filter) {
        editProvider.saveStateToHistory();
        editProvider.setCurrentFilter(filter);
      },
      onFilterStrengthChanged: (strength) {
        editProvider.saveStateToHistory();
        editProvider.setFilterStrength(strength);
      },
      adjustments: adjustments,
      selectedAdjustment: state['selectedAdjustment'] as String?,
      onAdjustmentSelected: (adjustment) {
        editProvider.setSelectedAdjustment(adjustment);
      },
      onAdjustmentChanged: (value) {
        editProvider.saveStateToHistory();
        final selectedAdjustment = adjustments.firstWhere((adj) => adj['label'] == editProvider.selectedAdjustment);
        selectedAdjustment['setter'](value);
      },
      onReset: () {
        editProvider.saveStateToHistory();
        editProvider.resetAdjustments();
      },
      onCrop: () => _showCropDialog(context, editProvider),
      onFlipHorizontal: () {
        editProvider.saveStateToHistory();
        editProvider.setFlipHorizontal(!editProvider.flipHorizontal);
      },
      onFlipVertical: () {
        editProvider.saveStateToHistory();
        editProvider.setFlipVertical(!editProvider.flipVertical);
      },
      onZoomIn: () {
        editProvider.saveStateToHistory();
        editProvider.setCroppedImageScale(editProvider.croppedImageScale * 1.04);
      },
      onZoomOut: () {
        editProvider.saveStateToHistory();
        editProvider.setCroppedImageScale(editProvider.croppedImageScale / 1.04);
      },
      onCenterHorizontal: () {
        editProvider.saveStateToHistory();
        editProvider.setCroppedImagePosition(Offset(0, editProvider.croppedImagePosition.dy));
      },
      onRatio34: () {
        editProvider.saveStateToHistory();
        editProvider.setCanvasAspectRatio(3 / 4);
      },
      onRatio43: () {
        editProvider.saveStateToHistory();
        editProvider.setCanvasAspectRatio(4 / 3);
      },
      currentBackgroundColor: editProvider.backgroundColor,
      onBackgroundColorChanged: (color) {
        editProvider.saveStateToHistory();
        editProvider.setBackgroundColor(color);
      },
      textFont: state['textFont'] as String,
      onTextFontChanged: (font) {
        editProvider.saveStateToHistory();
        editProvider.setTextFont(font);
      },
      textFont2: state['textFont2'] as String,
      onTextFont2Changed: (font) {
        editProvider.saveStateToHistory();
        editProvider.setTextFont2(font);
      },
      fonts: editProvider.fonts,
      fontNames: editProvider.fontNames,
      textPosition: state['textAlignment'] as String,
      onTextPositionChanged: (position) {
        editProvider.saveStateToHistory();
        editProvider.setTextAlignment(position);
      },
      textPosition2: state['textAlignment2'] as String,
      onTextPosition2Changed: (position) {
        editProvider.saveStateToHistory();
        editProvider.setTextAlignment2(position);
      },
      textSize: state['textSize'] as double,
      onTextSizeChanged: (size) {
        editProvider.saveStateToHistory();
        editProvider.setTextSize(size);
      },
      textSize2: state['textSize2'] as double,
      onTextSize2Changed: (size) {
        editProvider.saveStateToHistory();
        editProvider.setTextSize2(size);
      },
      dateText: state['dateText'] as String,
      onDateTextChanged: (text) {
        editProvider.setDateText(text);
      },
      dateText2: state['dateText2'] as String,
      onDateText2Changed: (text) {
        editProvider.setDateText2(text);
      },
      sentenceText: state['sentenceText'] as String,
      onSentenceTextChanged: (text) {
        editProvider.setSentenceText(text);
      },
      sentenceText2: state['sentenceText2'] as String,
      onSentenceText2Changed: (text) {
        editProvider.setSentenceText2(text);
      },
      textColor: state['textColor'] as Color,
      onTextColorChanged: (color) {
        editProvider.saveStateToHistory();
        editProvider.setTextColor(color);
      },
      textColor2: state['textColor2'] as Color,
      onTextColor2Changed: (color) {
        editProvider.saveStateToHistory();
        editProvider.setTextColor2(color);
      },
      textDirection: state['textDirection'] as String,
      onTextDirectionChanged: (direction) {
        editProvider.saveStateToHistory();
        editProvider.setTextDirection(direction);
      },
      textDirection2: state['textDirection2'] as String,
      onTextDirection2Changed: (direction) {
        editProvider.saveStateToHistory();
        editProvider.setTextDirection2(direction);
      },
      marginLeft: _marginLeft,
      onMarginLeftChanged: (value) {
        editProvider.saveStateToHistory();
        setState(() {
          _marginLeft = value;
        });
      },
      marginRight: _marginRight,
      onMarginRightChanged: (value) {
        editProvider.saveStateToHistory();
        setState(() {
          _marginRight = value;
        });
      },
      marginTop: _marginTop,
      onMarginTopChanged: (value) {
        editProvider.saveStateToHistory();
        setState(() {
          _marginTop = value;
        });
      },
      marginBottom: _marginBottom,
      onMarginBottomChanged: (value) {
        editProvider.saveStateToHistory();
        setState(() {
          _marginBottom = value;
        });
      },
      onResetMargin: () {
        editProvider.saveStateToHistory();
        setState(() {
          _marginLeft = 0.0;
          _marginRight = 0.0;
          _marginTop = 0.0;
          _marginBottom = 0.0;
        });
      },
    );
  }

  /// 构建调整参数列表
  /// 
  /// 性能优化：将列表构建独立出来，避免重复创建
  List<Map<String, dynamic>> _buildAdjustmentsList(EditProvider editProvider) {
    return [
      {'label': '亮度', 'value': editProvider.brightness, 'min': -1.0, 'max': 1.0, 'setter': (value) => editProvider.setBrightness(value)},
      {'label': '对比度', 'value': editProvider.contrast, 'min': -1.0, 'max': 1.0, 'setter': (value) => editProvider.setContrast(value)},
      {'label': '饱和度', 'value': editProvider.saturation, 'min': -1.0, 'max': 1.0, 'setter': (value) => editProvider.setSaturation(value)},
      {'label': '色温', 'value': editProvider.temperature, 'min': -1.0, 'max': 1.0, 'setter': (value) => editProvider.setTemperature(value)},
      {'label': '褪色', 'value': editProvider.fade, 'min': 0.0, 'max': 1.0, 'setter': (value) => editProvider.setFade(value)},
      {'label': '暗角', 'value': editProvider.vignette, 'min': 0.0, 'max': 1.0, 'setter': (value) => editProvider.setVignette(value)},
      {'label': '模糊', 'value': editProvider.blur, 'min': 0.0, 'max': 10.0, 'setter': (value) => editProvider.setBlur(value)},
      {'label': '颗粒', 'value': editProvider.grain, 'min': 0.0, 'max': 1.0, 'setter': (value) => editProvider.setGrain(value)},
    ];
  }

  /// 构建图片预览区域
  /// 
  /// 重构后的方法确保：
  /// 1. 画布在任何情况下都能正常显示
  /// 2. 画布尺寸计算逻辑更加健壮
  /// 3. 添加了更好的视觉效果（背景、边框、阴影）
  /// 4. 无图片状态下显示添加图片提示
  /// 
  /// 性能优化：使用 RepaintBoundary 隔离重绘区域
  Widget _buildImagePreview(AppProvider appProvider, EditProvider editProvider) {
    return Container(
      // 外层容器：提供整体背景和内边距
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: RepaintBoundary(
          key: _repaintBoundaryKey,
          child: _buildCanvasWithShadow(editProvider),
        ),
      ),
    );
  }

  /// 构建带阴影效果的画布
  /// 
  /// 为画布添加立体感的阴影效果，提升视觉体验
  Widget _buildCanvasWithShadow(EditProvider editProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            // 画布外层阴影效果
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildCanvasContent(editProvider, constraints),
        );
      },
    );
  }

  /// 构建画布内容
  /// 
  /// 优化后的画布尺寸计算逻辑：
  /// 1. 使用 LayoutBuilder 获取可用空间
  /// 2. 根据宽高比计算最佳尺寸
  /// 3. 确保画布不会超出可用空间
  /// 4. 添加圆角边框效果
  Widget _buildCanvasContent(EditProvider editProvider, BoxConstraints constraints) {
    // 获取当前画布宽高比
    final double aspectRatio = editProvider.canvasAspectRatio;
    
    // 计算画布尺寸
    final CanvasSize canvasSize = _calculateCanvasSize(
      constraints: constraints,
      aspectRatio: aspectRatio,
    );
    
    return Center(
      child: Container(
        width: canvasSize.width,
        height: canvasSize.height,
        decoration: BoxDecoration(
          // 画布背景颜色
          color: editProvider.backgroundColor,

          // 细微的边框效果
          border: Border.all(
            color: Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        // 移除圆角裁剪，使用矩形
        child: ClipRect(
          child: Padding(
            padding: EdgeInsets.only(
              left: _marginLeft,
              right: _marginRight,
              top: _marginTop,
              bottom: _marginBottom,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 图片区域（占据整个空间）
                _buildImageArea(editProvider),
                // 文字区域（覆盖在图片之上）
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildTextArea(editProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 计算画布尺寸
  /// 
  /// 根据约束条件和宽高比计算最佳画布尺寸
  /// 确保画布在任何情况下都能正确显示
  CanvasSize _calculateCanvasSize({
    required BoxConstraints constraints,
    required double aspectRatio,
  }) {
    // 获取可用空间
    double maxWidth = constraints.maxWidth;
    double maxHeight = constraints.maxHeight;
    
    // 处理无限约束的情况
    if (maxWidth.isInfinite || maxHeight.isInfinite) {
      // 如果约束是无限的，使用合理的默认值
      // 竖版模板：300x400，横版模板：400x300
      if (aspectRatio > 1) {
        // 横版
        return CanvasSize(
          width: 360,
          height: 270,
        );
      } else {
        // 竖版
        return CanvasSize(
          width: 270,
          height: 360,
        );
      }
    }
    
    // 确保最大宽高为正值
    if (maxWidth <= 0 || maxHeight <= 0) {
      // 返回默认尺寸，避免渲染错误
      return CanvasSize(
        width: 270,
        height: 360,
      );
    }
    
    // 计算基于宽度的画布尺寸
    double canvasWidth = maxWidth;
    double canvasHeight = canvasWidth / aspectRatio;
    
    // 如果高度超出可用空间，则基于高度重新计算
    if (canvasHeight > maxHeight) {
      canvasHeight = maxHeight;
      canvasWidth = canvasHeight * aspectRatio;
    }
    
    // 确保画布尺寸不会太小
    canvasWidth = canvasWidth.clamp(100.0, maxWidth);
    canvasHeight = canvasHeight.clamp(100.0, maxHeight);
    
    return CanvasSize(
      width: canvasWidth,
      height: canvasHeight,
    );
  }

  /// 构建图片区域
  /// 
  /// 根据是否有图片显示不同内容：
  /// - 有图片：显示可拖动、可缩放的图片
  /// - 无图片：显示添加图片提示
  Widget _buildImageArea(EditProvider editProvider) {
    // 检查是否有图片数据
    final hasImage = editProvider.currentImageBytes != null || editProvider.currentImageFile != null;
    
    return ColoredBox(
      color: hasImage ? Colors.transparent : Colors.grey[50]!,
      child: hasImage
          ? _buildImageWithEffects(editProvider)
          : _buildAddImagePrompt(editProvider),
    );
  }

  /// 构建带效果的图片组件
  /// 
  /// 显示图片并支持：
  /// - 拖动、缩放、旋转
  /// - 滤镜效果
  /// - 各种调整参数
  Widget _buildImageWithEffects(EditProvider editProvider) {
    return ImageDraggable(
      imageBytes: editProvider.currentImageBytes,
      imageFile: editProvider.currentImageFile,
      filterColor: _getFilterColor(editProvider),
      brightness: editProvider.brightness,
      contrast: editProvider.contrast,
      saturation: editProvider.saturation,
      temperature: editProvider.temperature,
      fade: editProvider.fade,
      vignette: editProvider.vignette,
      blur: editProvider.blur,
      grain: editProvider.grain,
      sharpness: editProvider.sharpness,
      flipHorizontal: editProvider.flipHorizontal,
      flipVertical: editProvider.flipVertical,
      imagePosition: editProvider.croppedImagePosition,
      imageScale: editProvider.croppedImageScale,
      imageRotation: editProvider.rotation,
      onTransformChanged: (position, scale, rotation) {
        editProvider.setCroppedImagePosition(position);
        editProvider.setCroppedImageScale(scale);
        editProvider.setRotation(rotation);
      },
    );
  }

  /// 构建添加图片提示
  /// 
  /// 当没有图片时显示，引导用户添加图片
  Widget _buildAddImagePrompt(EditProvider editProvider) {
    return GestureDetector(
      onTap: () => _pickImage(editProvider),
      behavior: HitTestBehavior.opaque, // 确保整个区域都可点击
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标容器：添加背景效果
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 56,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            // 提示文字
            Text(
              '点击添加图片',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            // 副标题
            Text(
              '支持 JPG、PNG 格式',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建文字区域
  /// 
  /// 显示日期和短句文字，支持：
  /// - 多组文字（主要文字和次要文字）
  /// - 自定义字体、大小、颜色
  /// - 文字对齐方式
  Widget _buildTextArea(EditProvider editProvider) {
    // 强制重新构建文字组件，确保文字方向变化时立即刷新
    return Row(
      key: ValueKey('${editProvider.textDirection}-${editProvider.textDirection2}'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        // 主要文字
        Expanded(
          child: _buildTextDraggable(editProvider, isText2: false),
        ),
        // 次要文字（仅在内容不为空时显示）
        if (editProvider.sentenceText2.isNotEmpty || editProvider.dateText2.isNotEmpty)
          Expanded(
            child: _buildTextDraggable(editProvider, isText2: true),
          ),
      ],
    );
  }

  /// 构建文字拖拽组件
  /// 
  /// 创建可拖拽的文字组件，支持：
  /// - 自定义字体和样式
  /// - 拖拽定位
  /// - 多种对齐方式
  /// - 竖排文字
  /// 
  /// 参数说明：
  /// - [showDate] 是否显示日期
  /// - [isText2] 是否为第二组文字
  Widget _buildTextDraggable(EditProvider editProvider, {
    bool showDate = true,
    bool isText2 = false,
  }) {
    // 根据是否为第二组文字获取对应的对齐方式
    final String textAlignment = isText2 ? editProvider.textAlignment2 : editProvider.textAlignment;
    // 获取文字方向
    final String textDirection = isText2 ? editProvider.textDirection2 : editProvider.textDirection;
    
    // 根据对齐方式设置对应的 TextAlign 和 CrossAxisAlignment
    TextAlign textAlign;
    CrossAxisAlignment crossAxisAlignment;
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    
    switch (textAlignment) {
      case 'left':
        textAlign = TextAlign.left;
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case 'center':
        textAlign = TextAlign.center;
        crossAxisAlignment = CrossAxisAlignment.center;
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case 'right':
        textAlign = TextAlign.right;
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        textAlign = isText2 ? TextAlign.right : TextAlign.left;
        crossAxisAlignment = isText2 ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    }
    
    // 创建文字样式，支持竖排文字
    TextStyle dateTextStyle = TextStyle();
    TextStyle sentenceTextStyle = TextStyle();
    
    // 如果是竖排文字，创建自定义垂直排列组件
    if (textDirection == 'vertical') {
      // 获取文字内容
      final dateText = isText2 ? editProvider.dateText2 : editProvider.dateText;
      final sentenceText = isText2 ? editProvider.sentenceText2 : editProvider.sentenceText;
      
      // 将文字拆分为字符列表
      final List<String> dateChars = dateText.split('');
      final List<String> sentenceChars = sentenceText.split('');
      
      // 创建垂直排列的文字内容
      Widget buildVerticalTextContent() {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 第一列：日期文字
            if (showDate && dateText.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildVerticalTextChars(
                  dateChars,
                  isText2 ? editProvider.textSize2 : editProvider.textSize,
                  isText2 ? editProvider.textColor2 : editProvider.textColor,
                  isText2 ? editProvider.textFont2 : editProvider.textFont,
                  true
                ),
              ),
            
            // 两列之间的间距
            if (showDate && dateText.isNotEmpty && sentenceText.isNotEmpty)
              const SizedBox(width: 20),
            
            // 第二列：句子文字
            if (sentenceText.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildVerticalTextChars(
                  sentenceChars,
                  isText2 ? editProvider.textSize2 : editProvider.textSize,
                  isText2 ? editProvider.textColor2 : editProvider.textColor,
                  isText2 ? editProvider.textFont2 : editProvider.textFont,
                  false
                ),
              ),
          ],
        );
      }
      
      // 使用与横排文字相同的 TextDraggable 组件结构
      return Transform.translate(
        offset: isText2 ? editProvider.textPosition2 : editProvider.textPosition,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                _isDraggingText = true;
              },
              onPanUpdate: (details) {
                if (!_isDraggingText) return;
                
                // 计算新的位置
                final position = isText2 ? editProvider.textPosition2 : editProvider.textPosition;
                final newPosition = position + details.delta;
                
                if (isText2) {
                  editProvider.setTextPosition2(newPosition);
                } else {
                  editProvider.setTextPosition(newPosition);
                }
              },
              onPanEnd: (details) {
                _isDraggingText = false;
              },
              child: Container(
                padding: const EdgeInsets.all(8), // 添加一些 padding 使点击更容易
                child: buildVerticalTextContent(),
              ),
            ),
          ),
        ),
      );
    }
    
    return TextDraggable(
      dateText: isText2 ? editProvider.dateText2 : editProvider.dateText,
      sentenceText: isText2 ? editProvider.sentenceText2 : editProvider.sentenceText,
      showDate: showDate,
      textAlign: textAlign,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      textFont: isText2 ? editProvider.textFont2 : editProvider.textFont,
      textPosition: textAlignment,
      textSize: isText2 ? editProvider.textSize2 : editProvider.textSize,
      textColor: isText2 ? editProvider.textColor2 : editProvider.textColor,
      initialPosition: isText2 ? editProvider.textPosition2 : editProvider.textPosition,
      onPositionChanged: (position) {
        if (isText2) {
          editProvider.setTextPosition2(position);
        } else {
          editProvider.setTextPosition(position);
        }
      },
    );
  }
  
  /// 构建竖排文字字符列表
  /// 
  /// 参数：
  /// - [chars] 字符列表
  /// - [textSize] 文字大小
  /// - [textColor] 文字颜色
  /// - [textFont] 文字字体
  /// - [isDate] 是否为日期文字
  List<Widget> _buildVerticalTextChars(
    List<String> chars,
    double textSize,
    Color textColor,
    String textFont,
    [bool isDate = false]
  ) {
    final List<Widget> widgets = [];
    final double fontSize = isDate ? textSize * 0.75 : textSize;
    final double spacing = fontSize * 0.1; // 文字间距为字体大小的10%
    
    for (int i = 0; i < chars.length; i++) {
      widgets.add(
        Text(
          chars[i],
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: textFont,
          ),
          textAlign: TextAlign.center,
        ),
      );
      
      // 添加间距（最后一个字符后不需要间距）
      if (i < chars.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    
    return widgets;
  }
  

  
  /// 选择图片的方法
  /// 
  /// 打开图片选择器，支持：
  /// - Web平台：直接选择图片
  /// - 移动平台：选择图片并应用滤镜
  Future<void> _pickImage(EditProvider editProvider) async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.setLoading(true);

    try {
      if (kIsWeb) {
        // Web平台处理
        final Uint8List? imageBytes = await PhotoPicker.pickImageFromGalleryWeb();
        if (imageBytes == null) {
          // 检查是否是因为选择了HEIC格式
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('不支持HEIC格式，请选择JPG、PNG等其他格式的图片'),
              backgroundColor: EditScreenConstants.warningColor,
              duration: EditScreenConstants.saveDuration,
            ),
          );
          return;
        }

        // 显示自由裁剪界面
        showDialog(
          context: context,
          builder: (context) {
            return FreeCropDialog(
              imageBytes: imageBytes,
              onCropComplete: (croppedBytes) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('图片裁剪成功！'),
                      ],
                    ),
                    backgroundColor: EditScreenConstants.successColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // 处理裁剪结果
                editProvider.saveStateToHistory();
                if (croppedBytes.containsKey('bytes')) {
                  editProvider.setCurrentImageBytes(croppedBytes['bytes']);
                }
                editProvider.setCroppedImagePosition(croppedBytes['offset'] ?? Offset.zero);
                editProvider.setCroppedImageScale(croppedBytes['scale'] ?? 1.0);
              },
            );
          },
        );
      } else {
        // 移动平台处理
        // 从相册选择照片
        final File? pickedImage = await PhotoPicker.pickImageFromGallery();
        if (pickedImage == null) return;

        // 应用滤镜
        final File? filteredImage = await PhotoPicker.processImage(
          pickedImage,
          appProvider.currentTemplate.filterName,
        );
        if (filteredImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('应用滤镜失败，请重试'),
              backgroundColor: EditScreenConstants.errorColor,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // 显示自由裁剪界面
        showDialog(
            context: context,
            builder: (context) {
              return FreeCropDialog(
                imageFile: filteredImage,
                onCropComplete: (croppedBytes) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('图片裁剪成功！'),
                        ],
                      ),
                      backgroundColor: EditScreenConstants.successColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  // 处理裁剪结果
                  editProvider.saveStateToHistory();
                  if (croppedBytes.containsKey('bytes')) {
                    editProvider.setCurrentImageBytes(croppedBytes['bytes']);
                  }
                  editProvider.setCroppedImagePosition(croppedBytes['offset'] ?? Offset.zero);
                  editProvider.setCroppedImageScale(croppedBytes['scale'] ?? 1.0);
                },
              );
            },
          );
      }
    } catch (e) {
      final errorHandler = ErrorHandler();
      errorHandler.handleError(
        context,
        e,
        ErrorType.imageProcessing,
        customMessage: '处理图片失败，请重试',
      );
    } finally {
      appProvider.setLoading(false);
    }
  }

  // 根据当前滤镜获取颜色效果
  // 
  // 性能优化：使用缓存机制，避免重复计算相同的滤镜颜色
  // 只有当滤镜名称或强度改变时才重新计算
  Color _getFilterColor(EditProvider editProvider) {
    final filterName = editProvider.currentFilter;
    final filterStrength = editProvider.filterStrength;
    
    // 性能优化：检查是否与上次相同，避免重复计算
    if (_lastFilterName == filterName && _lastFilterStrength == filterStrength) {
      // 使用缓存的结果
      final cacheKey = '${filterName}_${filterStrength.toStringAsFixed(2)}';
      if (_filterColorCache.containsKey(cacheKey)) {
        return _filterColorCache[cacheKey]!;
      }
    }
    
    // 更新缓存键
    _lastFilterName = filterName;
    _lastFilterStrength = filterStrength;
    
    Color baseColor;
    switch (filterName) {
      case 'amaro':
        baseColor = Color.fromARGB(30, 255, 200, 100);
        break;
      case 'antique':
        baseColor = Color.fromARGB(40, 180, 160, 140);
        break;
      case 'beauty':
        baseColor = Color.fromARGB(25, 255, 220, 200);
        break;
      case 'blackcat':
        baseColor = Color.fromARGB(50, 80, 90, 100);
        break;
      case 'brannan':
        baseColor = Color.fromARGB(40, 100, 150, 200);
        break;
      case 'brooklyn':
        baseColor = Color.fromARGB(30, 180, 200, 220);
        break;
      case 'calm':
        baseColor = Color.fromARGB(20, 200, 220, 210);
        break;
      case 'cool':
        baseColor = Color.fromARGB(30, 150, 200, 255);
        break;
      case 'crayon':
        baseColor = Color.fromARGB(40, 220, 200, 180);
        break;
      case 'earlybird':
        baseColor = Color.fromARGB(35, 255, 180, 120);
        break;
      case 'emerald':
        baseColor = Color.fromARGB(30, 150, 220, 180);
        break;
      case 'evergreen':
        baseColor = Color.fromARGB(35, 120, 180, 150);
        break;
      case 'freud':
        baseColor = Color.fromARGB(45, 180, 120, 180);
        break;
      case 'healthy':
        baseColor = Color.fromARGB(25, 220, 200, 180);
        break;
      case 'hefe':
        baseColor = Color.fromARGB(30, 240, 180, 120);
        break;
      case 'hudson':
        baseColor = Color.fromARGB(25, 180, 220, 255);
        break;
      case 'inkwell':
        baseColor = Color.fromARGB(60, 128, 128, 128);
        break;
      case 'kevin_new':
        baseColor = Color.fromARGB(25, 255, 200, 150);
        break;
      case 'latte':
        baseColor = Color.fromARGB(30, 220, 180, 140);
        break;
      case 'lomo':
        baseColor = Color.fromARGB(40, 255, 150, 100);
        break;
      case 'n1977':
        baseColor = Color.fromARGB(45, 255, 180, 120);
        break;
      case 'nashville':
        baseColor = Color.fromARGB(35, 255, 200, 150);
        break;
      case 'nostalgia':
        baseColor = Color.fromARGB(40, 180, 160, 140);
        break;
      case 'pixar':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'rise':
        baseColor = Color.fromARGB(30, 240, 200, 160);
        break;
      case 'romance':
        baseColor = Color.fromARGB(25, 255, 200, 220);
        break;
      case 'sakura':
        baseColor = Color.fromARGB(30, 255, 200, 220);
        break;
      case 'sierra':
        baseColor = Color.fromARGB(25, 200, 220, 200);
        break;
      case 'sketch':
        baseColor = Color.fromARGB(50, 180, 180, 180);
        break;
      case 'skinwhiten':
        baseColor = Color.fromARGB(20, 255, 255, 255);
        break;
      case 'sugar_tablets':
        baseColor = Color.fromARGB(25, 255, 220, 180);
        break;
      case 'sunrise':
        baseColor = Color.fromARGB(40, 255, 180, 120);
        break;
      case 'sunset':
        baseColor = Color.fromARGB(40, 255, 150, 100);
        break;
      case 'sutro':
        baseColor = Color.fromARGB(50, 150, 100, 100);
        break;
      case 'sweets':
        baseColor = Color.fromARGB(25, 255, 200, 180);
        break;
      case 'tender':
        baseColor = Color.fromARGB(20, 220, 200, 180);
        break;
      case 'toaster2_filter_shader':
        baseColor = Color.fromARGB(45, 255, 180, 100);
        break;
      case 'valencia':
        baseColor = Color.fromARGB(35, 255, 200, 150);
        break;
      case 'walden':
        baseColor = Color.fromARGB(30, 180, 220, 180);
        break;
      case 'warm':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'whitecat':
        baseColor = Color.fromARGB(30, 255, 255, 255);
        break;
      case 'xproii_filter_shader':
        baseColor = Color.fromARGB(40, 255, 150, 200);
        break;
      case 'abao':
        baseColor = Color.fromARGB(25, 255, 200, 150);
        break;
      case 'charm':
        baseColor = Color.fromARGB(25, 255, 180, 200);
        break;
      case 'elegant':
        baseColor = Color.fromARGB(20, 200, 180, 160);
        break;
      case 'fandel':
        baseColor = Color.fromARGB(30, 255, 180, 120);
        break;
      case 'floral':
        baseColor = Color.fromARGB(25, 220, 200, 220);
        break;
      case 'iris':
        baseColor = Color.fromARGB(30, 200, 180, 220);
        break;
      case 'juicy':
        baseColor = Color.fromARGB(25, 200, 255, 200);
        break;
      case 'lord_kelvin':
        baseColor = Color.fromARGB(35, 255, 180, 120);
        break;
      case 'mystical':
        baseColor = Color.fromARGB(30, 150, 180, 220);
        break;
      case 'peach':
        baseColor = Color.fromARGB(30, 255, 200, 180);
        break;
      case 'pomelo':
        baseColor = Color.fromARGB(25, 200, 255, 200);
        break;
      case 'rococo':
        baseColor = Color.fromARGB(25, 220, 180, 160);
        break;
      case 'snowy':
        baseColor = Color.fromARGB(30, 220, 240, 255);
        break;
      case 'summer':
        baseColor = Color.fromARGB(30, 255, 200, 150);
        break;
      case 'sweet':
        baseColor = Color.fromARGB(25, 255, 200, 220);
        break;
      case 'toaster':
        baseColor = Color.fromARGB(40, 255, 180, 120);
        break;
      default:
        return Colors.transparent;
    }
    
    // 根据滤镜强度调整透明度
    int adjustedAlpha = (baseColor.alpha * filterStrength * 2).toInt(); // 实质上加强两倍
    final result = Color.fromARGB(adjustedAlpha, baseColor.red, baseColor.green, baseColor.blue);
    
    // 性能优化：缓存结果
    final cacheKey = '${filterName}_${filterStrength.toStringAsFixed(2)}';
    _filterColorCache[cacheKey] = result;
    
    // 性能优化：限制缓存大小，避免内存泄漏
    if (_filterColorCache.length > 100) {
      _filterColorCache.clear();
    }
    
    return result;
  }

  // 根据调整参数获取颜色效果
  Color _getAdjustmentColor() {
    int alpha = 0;
    int red = 255;
    int green = 255;
    int blue = 255;

    // 应用亮度调整
    if (_brightness > 0) {
      alpha = (alpha + (180 * _brightness).toInt()).clamp(0, 255);
      red = 255;
      green = 255;
      blue = 255;
    } else if (_brightness < 0) {
      alpha = (alpha + (180 * _brightness.abs()).toInt()).clamp(0, 255);
      red = 0;
      green = 0;
      blue = 0;
    }

    // 应用对比度调整
    if (_contrast != 0) {
      alpha = (alpha + (40 * _contrast.abs()).toInt()).clamp(0, 255);
      if (_contrast > 0) {
        // 增加对比度
        red = 200 + (55 * _contrast).toInt();
        green = 200 + (55 * _contrast).toInt();
        blue = 200 + (55 * _contrast).toInt();
      } else {
        // 减少对比度
        red = 128 + (127 * _contrast).toInt();
        green = 128 + (127 * _contrast).toInt();
        blue = 128 + (127 * _contrast).toInt();
      }
    }

    // 应用饱和度调整
    if (_saturation != 0) {
      alpha = (alpha + (40 * _saturation.abs()).toInt()).clamp(0, 255);
      if (_saturation > 0) {
        // 增加饱和度
        red = 200 + (55 * _saturation).toInt();
        green = 180 + (75 * _saturation).toInt();
        blue = 180 + (75 * _saturation).toInt();
      } else {
        // 减少饱和度
        red = 128 + (127 * _saturation).toInt();
        green = 128 + (127 * _saturation).toInt();
        blue = 128 + (127 * _saturation).toInt();
      }
    }

    // 应用色温调整
    if (_temperature != 0) {
      alpha = (alpha + (40 * _temperature.abs()).toInt()).clamp(0, 255);
      if (_temperature > 0) {
        // 冷色调
        red = 180 + (75 * -_temperature).toInt();
        green = 190 + (65 * -_temperature).toInt();
        blue = 200 + (55 * _temperature).toInt();
      } else {
        // 暖色调
        red = 200 + (55 * -_temperature).toInt();
        green = 190 + (45 * -_temperature).toInt();
        blue = 180 + (35 * -_temperature).toInt();
      }
    }

    // 应用褪色调整
    if (_fade > 0) {
      alpha = (alpha + (60 * _fade).toInt()).clamp(0, 255);
      red = 200 + (55 * _fade).toInt();
      green = 190 + (45 * _fade).toInt();
      blue = 180 + (35 * _fade).toInt();
    }

    // 应用暗角调整
    if (_vignette > 0) {
      alpha = (alpha + (80 * _vignette).toInt()).clamp(0, 255);
      red = 0;
      green = 0;
      blue = 0;
    }

    return Color.fromARGB(alpha, red, green, blue);
  }

  // 显示裁剪对话框
  void _showCropDialog(BuildContext context, EditProvider editProvider) {
    // 直接显示自由裁剪界面，不显示比例选择
    showDialog(
      context: context,
      builder: (context) {
        return FreeCropDialog(
          imageBytes: editProvider.currentImageBytes,
          imageFile: editProvider.currentImageFile,
          onCropComplete: (croppedBytes) {
              // 保存当前状态
              editProvider.saveStateToHistory();
              // 处理裁剪结果
              if (croppedBytes.containsKey('bytes')) {
                editProvider.setCurrentImageBytes(croppedBytes['bytes']);
              }
              editProvider.setCroppedImagePosition(croppedBytes['offset'] ?? Offset.zero);
              editProvider.setCroppedImageScale(croppedBytes['scale'] ?? 1.0);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('裁剪完成'),
                  backgroundColor: const Color(0xFF4CAF50),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
        );
      },
    );
  }
}

// 颗粒效果绘制器
/// 
/// 性能优化：
/// 1. 使用 shouldRepaint 减少不必要的重绘
/// 2. 缓存绘制结果，避免重复计算
/// 3. 使用更高效的绘制算法
class GrainPainter extends CustomPainter {
  final double intensity;
  
  // 性能优化：缓存上次的绘制参数
  static double? _lastIntensity;
  static ui.Picture? _cachedPicture;
  static Size? _cachedSize;

  GrainPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    // 性能优化：如果强度为0，不绘制
    if (intensity <= 0) {
      return;
    }
    
    // 性能优化：检查是否可以使用缓存
    if (_lastIntensity == intensity && 
        _cachedSize != null && 
        _cachedSize!.width == size.width && 
        _cachedSize!.height == size.height &&
        _cachedPicture != null) {
      // 使用缓存的绘制结果
      canvas.drawPicture(_cachedPicture!);
      return;
    }
    
    // 创建新的 PictureRecorder 用于缓存
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas cacheCanvas = Canvas(recorder);
    
    final paint = Paint()
      ..blendMode = BlendMode.overlay
      ..color = Color.fromARGB((intensity * 50).toInt(), 0, 0, 0);

    // 创建简单的颗粒效果
    final width = size.width.toInt();
    final height = size.height.toInt();
    
    // 性能优化：降低颗粒密度，减少绘制次数
    final step = 12; // 从10增加到12，减少绘制点数
    
    // 绘制网格状颗粒
    for (int x = 0; x < width; x += step) {
      for (int y = 0; y < height; y += step) {
        // 使用x和y的和作为简单的随机因子
        final opacity = ((x + y) % 10) / 10.0 * intensity;
        paint.color = Color.fromARGB((opacity * 255).toInt(), 0, 0, 0);
        cacheCanvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 1, paint);
      }
    }
    
    // 结束录制并缓存
    _cachedPicture = recorder.endRecording();
    _lastIntensity = intensity;
    _cachedSize = size;
    
    // 绘制到主画布
    canvas.drawPicture(_cachedPicture!);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 性能优化：只有当强度改变时才重绘
    return oldDelegate is! GrainPainter || oldDelegate.intensity != intensity;
  }
}

// 辅助类：将十六进制颜色字符串转换为 Color
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
