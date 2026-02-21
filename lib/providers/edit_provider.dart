import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// 编辑状态管理常量
class EditProviderConstants {
  /// 默认滤镜
  static const String defaultFilter = 'original';
  
  /// 默认滤镜强度
  static const double defaultFilterStrength = 0.5;
  
  /// 默认旋转角度
  static const double defaultRotation = 0.0;
  
  /// 默认文字大小
  static const double defaultTextSize = 25.0;
  
  /// 默认文字对齐方式
  static const String defaultTextAlignment = 'center';
  
  /// 默认文字字体
  static const String defaultTextFont = 'YanShiYouRanXiaoKai';
  
  /// 最小缩放比例
  static const double minScale = 0.5;
  
  /// 最大缩放比例
  static const double maxScale = 3.0;
  
  /// 调整值范围最小值
  static const double minAdjustmentValue = -1.0;
  
  /// 调整值范围最大值
  static const double maxAdjustmentValue = 1.0;
  
  /// 模糊调整最大值
  static const double maxBlurValue = 10.0;
}

/// 模板完整状态类
/// 
/// 用于保存每个模板的完整状态，包括所有编辑参数和设置
/// 当用户切换模板时，会保存当前模板的状态，以便下次切换回来时恢复
/// 
/// 状态包括：
/// - 图片调整参数（亮度、对比度、饱和度等）
/// - 滤镜设置（滤镜类型和强度）
/// - 图片变换参数（旋转、翻转、位置、缩放）
/// - 文字设置（字体、大小、位置、颜色）
/// - 画布设置（背景颜色、比例、边距）
/// - 文字内容（日期、短句）
/// - 历史记录（用于撤销/重做）
class TemplateState {
  /// 亮度调整值
  final double brightness;
  
  /// 对比度调整值
  final double contrast;
  
  /// 饱和度调整值
  final double saturation;
  
  /// 色温调整值
  final double temperature;
  
  /// 褪色调整值
  final double fade;
  
  /// 暗角调整值
  final double vignette;
  
  /// 模糊调整值
  final double blur;
  
  /// 颗粒调整值
  final double grain;
  
  /// 锐度调整值
  final double sharpness;
  
  /// 当前选中的滤镜
  final String currentFilter;
  
  /// 滤镜强度
  final double filterStrength;
  
  /// 旋转角度
  final double rotation;
  
  /// 是否水平翻转
  final bool flipHorizontal;
  
  /// 是否垂直翻转
  final bool flipVertical;
  
  /// 裁剪后的图片位置
  final Offset croppedImagePosition;
  
  /// 裁剪后的图片缩放
  final double croppedImageScale;
  
  /// 文字字体
  final String textFont;
  
  /// 第二处文字字体
  final String textFont2;
  
  /// 文字位置
  final String textAlignment;
  
  /// 第二处文字位置
  final String textAlignment2;
  
  /// 文字大小
  final double textSize;
  
  /// 第二处文字大小
  final double textSize2;
  
  /// 文字位置
  final Offset textPosition;
  
  /// 第二处文字位置
  final Offset textPosition2;
  
  /// 背景颜色
  final Color backgroundColor;
  
  /// 文字颜色
  final Color textColor;
  
  /// 第二处文字颜色
  final Color textColor2;
  
  /// 文字方向
  final String textDirection;
  
  /// 第二处文字方向
  final String textDirection2;
  
  /// 画布宽高比
  final double canvasAspectRatio;
  
  /// 边距
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;
  
  /// 日期文字
  final String dateText;
  
  /// 短句文字
  final String sentenceText;
  
  /// 第二处日期文字
  final String dateText2;
  
  /// 第二处短句文字
  final String sentenceText2;
  
  /// 历史记录
  final List<EditStateSnapshot> history;
  
  /// 当前历史记录索引
  final int historyIndex;

  TemplateState({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.temperature,
    required this.fade,
    required this.vignette,
    required this.blur,
    required this.grain,
    required this.sharpness,
    required this.currentFilter,
    required this.filterStrength,
    required this.rotation,
    required this.flipHorizontal,
    required this.flipVertical,
    required this.croppedImagePosition,
    required this.croppedImageScale,
    required this.textFont,
    required this.textFont2,
    required this.textAlignment,
    required this.textAlignment2,
    required this.textSize,
    required this.textSize2,
    required this.textPosition,
    required this.textPosition2,
    required this.backgroundColor,
    required this.textColor,
    required this.textColor2,
    required this.textDirection,
    required this.textDirection2,
    required this.canvasAspectRatio,
    required this.marginLeft,
    required this.marginRight,
    required this.marginTop,
    required this.marginBottom,
    required this.dateText,
    required this.sentenceText,
    required this.dateText2,
    required this.sentenceText2,
    required this.history,
    required this.historyIndex,
  });
  
  /// 创建默认模板状态
  factory TemplateState.defaultState() {
    return TemplateState(
      brightness: 0.0,
      contrast: 0.0,
      saturation: 0.0,
      temperature: 0.0,
      fade: 0.0,
      vignette: 0.0,
      blur: 0.0,
      grain: 0.0,
      sharpness: 0.0,
      currentFilter: EditProviderConstants.defaultFilter,
      filterStrength: EditProviderConstants.defaultFilterStrength,
      rotation: EditProviderConstants.defaultRotation,
      flipHorizontal: false,
      flipVertical: false,
      croppedImagePosition: Offset.zero,
      croppedImageScale: 1.0,
      textFont: EditProviderConstants.defaultTextFont,
      textFont2: EditProviderConstants.defaultTextFont,
      textAlignment: EditProviderConstants.defaultTextAlignment,
      textAlignment2: 'right',
      textSize: EditProviderConstants.defaultTextSize,
      textSize2: EditProviderConstants.defaultTextSize,
      textPosition: const Offset(0, -15),
      textPosition2: const Offset(0, -15),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      textColor2: const Color(0xFF666666),
      textDirection: 'horizontal',
      textDirection2: 'horizontal',
      canvasAspectRatio: 3 / 4,
      marginLeft: 0.0,
      marginRight: 0.0,
      marginTop: 0.0,
      marginBottom: 0.0,
      dateText: '',
      sentenceText: '',
      dateText2: '',
      sentenceText2: '',
      history: [],
      historyIndex: -1,
    );
  }
}

/// 编辑状态快照类
/// 
/// 用于保存编辑状态的快照，实现撤销/重做功能
/// 每次用户进行编辑操作时，会创建一个快照保存当前状态
/// 
/// 快照包括：
/// - 图片调整参数（亮度、对比度、饱和度等）
/// - 滤镜设置（滤镜类型和强度）
/// - 图片变换参数（旋转、翻转、位置、缩放）
/// - 文字设置（字体、大小、位置、颜色）
/// - 画布设置（背景颜色、比例、边距）
/// 
/// 注意：快照不包含文字内容和历史记录，这些数据单独管理
class EditStateSnapshot {
  /// 亮度调整值
  final double brightness;
  
  /// 对比度调整值
  final double contrast;
  
  /// 饱和度调整值
  final double saturation;
  
  /// 色温调整值
  final double temperature;
  
  /// 褪色调整值
  final double fade;
  
  /// 暗角调整值
  final double vignette;
  
  /// 模糊调整值
  final double blur;
  
  /// 颗粒调整值
  final double grain;
  
  /// 锐度调整值
  final double sharpness;
  
  /// 当前选中的滤镜
  final String currentFilter;
  
  /// 滤镜强度
  final double filterStrength;
  
  /// 旋转角度
  final double rotation;
  
  /// 是否水平翻转
  final bool flipHorizontal;
  
  /// 是否垂直翻转
  final bool flipVertical;
  
  /// 裁剪后的图片位置
  final Offset croppedImagePosition;
  
  /// 裁剪后的图片缩放
  final double croppedImageScale;
  
  /// 文字字体
  final String textFont;
  
  /// 第二处文字字体
  final String textFont2;
  
  /// 文字位置
  final String textAlignment;
  
  /// 第二处文字位置
  final String textAlignment2;
  
  /// 文字大小
  final double textSize;
  
  /// 第二处文字大小
  final double textSize2;
  
  /// 文字位置
  final Offset textPosition;
  
  /// 第二处文字位置
  final Offset textPosition2;
  
  /// 背景颜色
  final Color backgroundColor;
  
  /// 文字颜色
  final Color textColor;
  
  /// 第二处文字颜色
  final Color textColor2;
  
  /// 文字方向
  final String textDirection;
  
  /// 第二处文字方向
  final String textDirection2;
  
  /// 画布宽高比
  final double canvasAspectRatio;
  
  /// 边距
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  EditStateSnapshot({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.temperature,
    required this.fade,
    required this.vignette,
    required this.blur,
    required this.grain,
    required this.sharpness,
    required this.currentFilter,
    required this.filterStrength,
    required this.rotation,
    required this.flipHorizontal,
    required this.flipVertical,
    required this.croppedImagePosition,
    required this.croppedImageScale,
    required this.textFont,
    required this.textFont2,
    required this.textAlignment,
    required this.textAlignment2,
    required this.textSize,
    required this.textSize2,
    required this.textPosition,
    required this.textPosition2,
    required this.backgroundColor,
    required this.textColor,
    required this.textColor2,
    required this.textDirection,
    required this.textDirection2,
    required this.canvasAspectRatio,
    required this.marginLeft,
    required this.marginRight,
    required this.marginTop,
    required this.marginBottom,
  });
}

/// 编辑状态管理类
/// 
/// 负责管理图片编辑相关的状态，包括图片数据、编辑参数、滤镜设置等
/// 
/// 核心功能：
/// 1. 状态管理：管理图片编辑的所有状态参数
/// 2. 模板切换：支持多模板状态保存和恢复，确保切换模板时数据不丢失
/// 3. 历史记录：支持撤销/重做功能，最多保存30条历史记录
/// 4. 数据验证：对所有输入参数进行范围验证，确保数据有效性
/// 
/// 性能优化：
/// - 使用防抖机制优化频繁的状态更新
/// - 只在值真正改变时才调用 notifyListeners
/// - 使用节流机制优化历史记录保存
/// 
/// 使用说明：
/// - 使用 [initializeState] 或 [initializeStateSilent] 初始化状态
/// - 使用各种 set 方法修改状态参数
/// - 使用 [saveStateToHistory] 保存当前状态到历史记录
/// - 使用 [undo] 和 [redo] 进行撤销/重做操作
/// - 使用 [resetAdjustments] 重置所有编辑参数
/// 
/// 注意事项：
/// - 切换模板时会自动保存当前模板状态
/// - 图片数据（currentImageBytes/currentImageFile）不从模板状态恢复
/// - 所有数值参数都有范围限制，超出范围会自动修正
class EditProvider extends ChangeNotifier {
  /// 图片数据（Web平台）
  Uint8List? _currentImageBytes;
  
  /// 图片文件（移动平台）
  File? _currentImageFile;
  
  /// 存储每个模板的状态
  final Map<String, TemplateState> _templateStates = {};
  
  // 性能优化：防抖和节流相关变量
  /// 防抖定时器，用于延迟通知
  Timer? _debounceTimer;
  
  /// 节流定时器，用于限制历史记录保存频率
  Timer? _throttleTimer;
  
  /// 是否可以保存历史记录（节流控制）
  bool _canSaveHistory = true;
  
  /// 防抖延迟时间（毫秒）
  static const int debounceDelay = 16; // 约一帧的时间，60fps
  
  /// 节流延迟时间（毫秒）
  static const int throttleDelay = 100; // 限制历史记录保存频率为每100ms一次
  
  /// 亮度调整值
  double _brightness = 0.0;
  
  /// 对比度调整值
  double _contrast = 0.0;
  
  /// 饱和度调整值
  double _saturation = 0.0;
  
  /// 色温调整值
  double _temperature = 0.0;
  
  /// 褪色调整值
  double _fade = 0.0;
  
  /// 暗角调整值
  double _vignette = 0.0;
  
  /// 模糊调整值
  double _blur = 0.0;
  
  /// 颗粒调整值
  double _grain = 0.0;
  
  /// 锐度调整值
  double _sharpness = 0.0;
  
  /// 当前选中的滤镜
  String _currentFilter = EditProviderConstants.defaultFilter;
  
  /// 滤镜强度 (0.0-1.0)
  double _filterStrength = EditProviderConstants.defaultFilterStrength;
  
  /// 旋转角度
  double _rotation = EditProviderConstants.defaultRotation;
  
  /// 是否水平翻转
  bool _flipHorizontal = false;
  
  /// 是否垂直翻转
  bool _flipVertical = false;
  
  /// 是否缩放图片
  bool _isImageZoomed = false;
  
  /// 当前选中的调整参数
  String? _selectedAdjustment;
  
  /// 裁剪后的图片位置
  Offset _croppedImagePosition = Offset.zero;
  
  /// 裁剪后的图片缩放
  double _croppedImageScale = 1.0;
  
  /// 历史记录列表，用于撤销/重做功能
  final List<EditStateSnapshot> _history = [];
  
  /// 当前历史记录索引
  int _historyIndex = -1;
  
  /// 最大历史记录数量
  static const int maxHistoryLength = 30;
  
  /// 性能优化：历史记录内存管理
  /// 当历史记录数量超过阈值时，自动清理旧记录
  static const int historyCleanupThreshold = 25;

  /// 当前选中的工具
  String _currentTool = 'canvas';
  
  /// 当前模板ID
  String _templateId = '';
  
  /// 图片位置
  Offset _imagePosition = Offset.zero;
  
  /// 文字位置
  Offset _textPosition = const Offset(0, -15);
  
  /// 第二处文字位置
  Offset _textPosition2 = const Offset(0, -15);
  
  /// 是否正在拖动图片
  bool _isDraggingImage = false;
  
  /// 是否正在拖动文字
  bool _isDraggingText = false;
  
  /// 是否正在拖动第二处文字
  bool _isDraggingText2 = false;
  
  /// 上次拖动的偏移量
  Offset _lastDragOffset = Offset.zero;
  
  /// 文字字体
  String _textFont = EditProviderConstants.defaultTextFont;
  
  /// 第二处文字字体
  String _textFont2 = EditProviderConstants.defaultTextFont;
  
  /// 文字位置（left, center, right）
  String _textAlignment = EditProviderConstants.defaultTextAlignment;
  
  /// 第二处文字位置（left, center, right）
  String _textAlignment2 = 'right'; // 文字2默认右对齐，与文字1的居中对齐形成对比
  
  /// 文字大小
  double _textSize = EditProviderConstants.defaultTextSize;
  
  /// 第二处文字大小
  double _textSize2 = EditProviderConstants.defaultTextSize;
  
  /// 日期文字
  String _dateText = '';
  
  /// 短句文字
  String _sentenceText = '';
  
  /// 第二处日期文字
  String _dateText2 = '';
  
  /// 第二处短句文字
  String _sentenceText2 = '';
  
  /// 背景颜色
  Color _backgroundColor = Colors.white;
  
  /// 文字颜色
  Color _textColor = Colors.black;
  
  /// 第二处文字颜色
  Color _textColor2 = const Color(0xFF666666); // 文字2默认使用深灰色，与文字1的黑色形成对比
  
  /// 文字方向（horizontal 或 vertical）
  String _textDirection = 'horizontal';
  
  /// 第二处文字方向
  String _textDirection2 = 'horizontal';

  /// 画布比例
  double _canvasAspectRatio = 3 / 4; // 默认3:4竖版

  /// 边距
  double _marginLeft = 0.0;
  double _marginRight = 0.0;
  double _marginTop = 0.0;
  double _marginBottom = 0.0;

  /// 字体列表
  final List<String> _fonts = [
    'default', 'QingChaKaiTi', 'XingKaiTi', 'LongCang', 'MaShanZheng', 'ZhiMangXing',
    'SourceHanSansCN', 'SourceHanSerifCN', 'GenShinGothic', 'GenJyuuGothic',
    'FangZhengSong', 'FangZhengFangSong', 'FangZhengKai', 'FangZhengHei',
    'ZhanKuGaoDuanHei', 'ZhanKuKuHeiTi', 'ZhanKuKuaiLeTi', 'ZhanKuWenYiTi',
    'WangHanZongKai', 'WangHanZongXing', 'WangHanZongLi',
    'YanShiFoXiTi', 'YanShiXiaXingKai', 'YanShiYouRanXiaoKai',
    'PangMenZhengDaoBiaoTi', 'PangMenZhengDaoCuShu',
    'AlibabaPuHuiTi',
    'MuYaoRuanBi', 'MuYaoSuiXin',
    'HuXiaoBoNanShen', 'HuXiaoBoZhenShuai'
  ];

  /// 字体名称映射
  final Map<String, String> _fontNames = {
    'default': '默认字体',
    'QingChaKaiTi': '清茶楷体',
    'XingKaiTi': '行楷体',
    'LongCang': '龙藏体',
    'MaShanZheng': '马善政体',
    'ZhiMangXing': '知芒星体',
    'SourceHanSansCN': '思源黑体',
    'SourceHanSerifCN': '思源宋体',
    'GenShinGothic': '思源真黑',
    'GenJyuuGothic': '思源柔黑',
    'FangZhengSong': '方正书宋',
    'FangZhengFangSong': '方正仿宋',
    'FangZhengKai': '方正楷体',
    'FangZhengHei': '方正黑体',
    'ZhanKuGaoDuanHei': '站酷高端黑',
    'ZhanKuKuHeiTi': '站酷酷黑体',
    'ZhanKuKuaiLeTi': '站酷快乐体',
    'ZhanKuWenYiTi': '站酷文艺体',
    'WangHanZongKai': '王汉宗楷体',
    'WangHanZongXing': '王汉宗行书',
    'WangHanZongLi': '王汉宗隶书',
    'YanShiFoXiTi': '演示佛系体',
    'YanShiXiaXingKai': '演示夏行楷',
    'YanShiYouRanXiaoKai': '演示悠然小楷',
    'PangMenZhengDaoBiaoTi': '庞门正道标题体',
    'PangMenZhengDaoCuShu': '庞门正道粗书体',
    'AlibabaPuHuiTi': '阿里巴巴普惠体',
    'MuYaoRuanBi': '沐瑶软笔手写体',
    'MuYaoSuiXin': '沐瑶随心手写体',
    'HuXiaoBoNanShen': '胡晓波男神体',
    'HuXiaoBoZhenShuai': '胡晓波真帅体'
  };

  /// 滤镜列表
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

  /// 滤镜名称映射
  final Map<String, String> _filterNames = {
    'original': '原图',
    'amaro': '阿玛罗',
    'antique': '复古',
    'beauty': '美颜',
    'blackcat': '黑猫',
    'brannan': '布兰南',
    'brooklyn': '布鲁克林',
    'calm': '平静',
    'cool': '冷色调',
    'crayon': '蜡笔',
    'earlybird': '早鸟',
    'emerald': '翡翠',
    'evergreen': '常青',
    'freud': '弗洛伊德',
    'healthy': '健康',
    'hefe': '赫菲',
    'hudson': '哈德逊',
    'inkwell': '墨水瓶',
    'kevin_new': '凯文新',
    'latte': '拿铁',
    'lomo': ' Lomography',
    'n1977': '1977',
    'nashville': '纳什维尔',
    'nostalgia': '怀旧',
    'pixar': '皮克斯',
    'rise': '升起',
    'romance': '浪漫',
    'sakura': '樱花',
    'sierra': '塞拉',
    'sketch': '素描',
    'skinwhiten': '美白',
    'sugar_tablets': '糖片',
    'sunrise': '日出',
    'sunset': '日落',
    'sutro': '苏特罗',
    'sweets': '甜蜜',
    'tender': '温柔',
    'toaster2_filter_shader': '烤面包机2',
    'valencia': '瓦伦西亚',
    'walden': '瓦尔登',
    'warm': '暖色调',
    'whitecat': '白猫',
    'xproii_filter_shader': 'X-Pro II',
    'abao': '阿宝',
    'charm': '魅力',
    'elegant': '优雅',
    'fandel': '范德尔',
    'floral': '花卉',
    'iris': '鸢尾花',
    'juicy': '多汁',
    'lord_kelvin': '开尔文勋爵',
    'mystical': '神秘',
    'peach': '桃子',
    'pomelo': '柚子',
    'rococo': '洛可可',
    'snowy': '雪白',
    'summer': '夏日',
    'sweet': '甜美',
    'toaster': '烤面包机'
  };

  /// 获取图片数据（Web平台）
  Uint8List? get currentImageBytes => _currentImageBytes;
  
  /// 获取图片文件（移动平台）
  File? get currentImageFile => _currentImageFile;
  
  /// 获取亮度调整值
  double get brightness => _brightness;
  
  /// 获取对比度调整值
  double get contrast => _contrast;
  
  /// 获取饱和度调整值
  double get saturation => _saturation;
  
  /// 获取色温调整值
  double get temperature => _temperature;
  
  /// 获取褪色调整值
  double get fade => _fade;
  
  /// 获取暗角调整值
  double get vignette => _vignette;
  
  /// 获取模糊调整值
  double get blur => _blur;
  
  /// 获取颗粒调整值
  double get grain => _grain;
  
  /// 获取锐度调整值
  double get sharpness => _sharpness;
  
  /// 获取当前选中的滤镜
  String get currentFilter => _currentFilter;
  
  /// 获取滤镜强度
  double get filterStrength => _filterStrength * 2; // 实质上加强两倍
  
  /// 获取旋转角度
  double get rotation => _rotation;
  
  /// 获取是否水平翻转
  bool get flipHorizontal => _flipHorizontal;
  
  /// 获取是否垂直翻转
  bool get flipVertical => _flipVertical;
  
  /// 获取是否缩放图片
  bool get isImageZoomed => _isImageZoomed;
  
  /// 获取当前选中的调整参数
  String? get selectedAdjustment => _selectedAdjustment;
  
  /// 获取裁剪后的图片位置
  Offset get croppedImagePosition => _croppedImagePosition;
  
  /// 获取裁剪后的图片缩放
  double get croppedImageScale => _croppedImageScale;
  
  /// 获取当前选中的工具
  String get currentTool => _currentTool;
  
  /// 获取当前模板ID
  String get templateId => _templateId;
  
  /// 获取图片位置
  Offset get imagePosition => _imagePosition;
  
  /// 获取文字位置
  Offset get textPosition => _textPosition;
  
  /// 获取第二处文字位置
  Offset get textPosition2 => _textPosition2;
  
  /// 获取是否正在拖动图片
  bool get isDraggingImage => _isDraggingImage;
  
  /// 获取是否正在拖动文字
  bool get isDraggingText => _isDraggingText;
  
  /// 获取是否正在拖动第二处文字
  bool get isDraggingText2 => _isDraggingText2;
  
  /// 获取上次拖动的偏移量
  Offset get lastDragOffset => _lastDragOffset;
  
  /// 获取滤镜列表
  List<String> get filters => _filters;
  
  /// 获取滤镜名称映射
  Map<String, String> get filterNames => _filterNames;
  
  /// 获取字体列表
  List<String> get fonts => _fonts;
  
  /// 获取字体名称映射
  Map<String, String> get fontNames => _fontNames;
  
  /// 获取文字字体
  String get textFont => _textFont;
  
  /// 获取第二处文字字体
  String get textFont2 => _textFont2;
  
  /// 获取文字位置
  String get textAlignment => _textAlignment;
  
  /// 获取第二处文字位置
  String get textAlignment2 => _textAlignment2;
  
  /// 获取文字大小
  double get textSize => _textSize;
  
  /// 获取第二处文字大小
  double get textSize2 => _textSize2;

  /// 设置图片数据（Web平台）
  /// 
  /// [bytes] - 图片字节数据
  void setCurrentImageBytes(Uint8List? bytes) {
    _currentImageBytes = bytes;
    notifyListeners();
  }

  /// 设置图片文件（移动平台）
  /// 
  /// [file] - 图片文件
  void setCurrentImageFile(File? file) {
    _currentImageFile = file;
    notifyListeners();
  }

  /// 设置亮度调整值
  /// 
  /// [value] - 亮度值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setBrightness(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    // 性能优化：只有当值真正改变时才更新并通知
    if (_brightness != clampedValue) {
      _brightness = clampedValue;
      notifyListeners();
    }
  }

  /// 设置对比度调整值
  /// 
  /// [value] - 对比度值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setContrast(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_contrast != clampedValue) {
      _contrast = clampedValue;
      notifyListeners();
    }
  }

  /// 设置饱和度调整值
  /// 
  /// [value] - 饱和度值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setSaturation(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_saturation != clampedValue) {
      _saturation = clampedValue;
      notifyListeners();
    }
  }

  /// 设置色温调整值
  /// 
  /// [value] - 色温度值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTemperature(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_temperature != clampedValue) {
      _temperature = clampedValue;
      notifyListeners();
    }
  }

  /// 设置褪色调整值
  /// 
  /// [value] - 褪色值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setFade(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_fade != clampedValue) {
      _fade = clampedValue;
      notifyListeners();
    }
  }

  /// 设置暗角调整值
  /// 
  /// [value] - 暗角值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setVignette(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_vignette != clampedValue) {
      _vignette = clampedValue;
      notifyListeners();
    }
  }

  /// 设置模糊调整值
  /// 
  /// [value] - 模糊值，范围：0.0 到 10.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setBlur(double value) {
    final clampedValue = value.clamp(0.0, EditProviderConstants.maxBlurValue);
    
    if (_blur != clampedValue) {
      _blur = clampedValue;
      notifyListeners();
    }
  }

  /// 设置颗粒调整值
  /// 
  /// [value] - 颗粒值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setGrain(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_grain != clampedValue) {
      _grain = clampedValue;
      notifyListeners();
    }
  }

  /// 设置锐度调整值
  /// 
  /// [value] - 锐度值，范围：-1.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setSharpness(double value) {
    final clampedValue = value.clamp(
      EditProviderConstants.minAdjustmentValue,
      EditProviderConstants.maxAdjustmentValue,
    );
    
    if (_sharpness != clampedValue) {
      _sharpness = clampedValue;
      notifyListeners();
    }
  }

  /// 设置当前选中的滤镜
  /// 
  /// [filter] - 滤镜名称
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setCurrentFilter(String filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      notifyListeners();
    }
  }

  /// 设置滤镜强度
  /// 
  /// [strength] - 滤镜强度，范围：0.0 到 1.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setFilterStrength(double strength) {
    final clampedStrength = strength.clamp(0.0, 1.0);
    
    if (_filterStrength != clampedStrength) {
      _filterStrength = clampedStrength;
      notifyListeners();
    }
  }

  /// 设置旋转角度
  /// 
  /// [angle] - 旋转角度，范围：0 到 360 度
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setRotation(double angle) {
    // 规范化角度到 0-360 范围
    double normalizedAngle = angle % 360;
    if (normalizedAngle < 0) normalizedAngle += 360;
    
    if (_rotation != normalizedAngle) {
      _rotation = normalizedAngle;
      notifyListeners();
    }
  }

  /// 设置是否水平翻转
  /// 
  /// [value] - 是否水平翻转
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setFlipHorizontal(bool value) {
    if (_flipHorizontal != value) {
      _flipHorizontal = value;
      notifyListeners();
    }
  }

  /// 设置是否垂直翻转
  /// 
  /// [value] - 是否垂直翻转
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setFlipVertical(bool value) {
    if (_flipVertical != value) {
      _flipVertical = value;
      notifyListeners();
    }
  }

  /// 设置是否缩放图片
  /// 
  /// [value] - 是否缩放图片
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setIsImageZoomed(bool value) {
    if (_isImageZoomed != value) {
      _isImageZoomed = value;
      notifyListeners();
    }
  }

  /// 设置当前选中的调整参数
  /// 
  /// [adjustment] - 调整参数名称
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setSelectedAdjustment(String? adjustment) {
    if (_selectedAdjustment != adjustment) {
      _selectedAdjustment = adjustment;
      notifyListeners();
    }
  }

  /// 设置裁剪后的图片位置
  /// 
  /// [position] - 图片位置
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setCroppedImagePosition(Offset position) {
    if (_croppedImagePosition != position) {
      _croppedImagePosition = position;
      notifyListeners();
    }
  }

  /// 设置裁剪后的图片缩放
  /// 
  /// [scale] - 缩放比例，范围：0.5 到 3.0
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setCroppedImageScale(double scale) {
    final validatedScale = _validateScale(scale);
    
    if (_croppedImageScale != validatedScale) {
      _croppedImageScale = validatedScale;
      notifyListeners();
    }
  }

  /// 设置当前选中的工具
  /// 
  /// [tool] - 工具名称
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setCurrentTool(String tool) {
    if (_currentTool != tool) {
      // 如果切换到"调整"工具，自动重置所有调整参数到默认值
      if (tool == 'adjust') {
        _brightness = 0.0;
        _contrast = 0.0;
        _saturation = 0.0;
        _temperature = 0.0;
        _fade = 0.0;
        _vignette = 0.0;
        _blur = 0.0;
        _grain = 0.0;
        _sharpness = 0.0;
        // 重置选中的调整参数为无选中状态
        _selectedAdjustment = null;
      }
      _currentTool = tool;
      notifyListeners();
    }
  }

  /// 初始化状态（强制重置）
  /// 
  /// 无论模板是否存在，都强制重置为默认状态
  /// 用于创建新明信片时确保所有参数都使用默认值
  void initializeStateReset({
    required String templateId,
    required Offset croppedImagePosition,
    required double croppedImageScale,
    Uint8List? currentImageBytes,
    File? currentImageFile,
    required String dateText,
    required String sentenceText,
    String dateText2 = '',
    String sentenceText2 = '',
  }) {
    // 保存当前模板状态
    _saveCurrentTemplateState();
    
    // 更新模板ID
    _templateId = templateId;
    
    // 强制重置为默认状态
    _resetToDefaultState();
    
    // 设置图片位置和缩放
    _croppedImagePosition = croppedImagePosition;
    _croppedImageScale = _validateScale(croppedImageScale);
    
    // 确保关键状态使用默认值
    _canvasAspectRatio = 3 / 4; // 默认3:4竖版
    _backgroundColor = Colors.white; // 默认白色背景
    
    // 更新图片数据
    _currentImageBytes = currentImageBytes;
    _currentImageFile = currentImageFile;
    
    // 更新文字数据
    _dateText = dateText;
    _sentenceText = sentenceText;
    _dateText2 = dateText2;
    _sentenceText2 = sentenceText2;
    
    // 通知监听器
    notifyListeners();
  }

  /// 批量初始化编辑状态（用于页面初始化，避免多次 notifyListeners）
  /// 
  /// 所有参数一次性设置，只调用一次 notifyListeners
  /// 
  /// 参数说明：
  /// - [templateId]: 模板ID，用于标识和恢复模板状态
  /// - [croppedImagePosition]: 裁剪后的图片位置（仅新模板使用）
  /// - [croppedImageScale]: 裁剪后的图片缩放比例（仅新模板使用）
  /// - [currentImageBytes]: 图片字节数据（Web平台）
  /// - [currentImageFile]: 图片文件（移动平台）
  /// - [dateText]: 日期文字
  /// - [sentenceText]: 短句文字
  /// - [dateText2]: 第二处日期文字（可选）
  /// - [sentenceText2]: 第二处短句文字（可选）
  void initializeState({
    required String templateId,
    required Offset croppedImagePosition,
    required double croppedImageScale,
    Uint8List? currentImageBytes,
    File? currentImageFile,
    required String dateText,
    required String sentenceText,
    String dateText2 = '',
    String sentenceText2 = '',
  }) {
    _initializeStateInternal(
      templateId: templateId,
      croppedImagePosition: croppedImagePosition,
      croppedImageScale: croppedImageScale,
      currentImageBytes: currentImageBytes,
      currentImageFile: currentImageFile,
      dateText: dateText,
      sentenceText: sentenceText,
      dateText2: dateText2,
      sentenceText2: sentenceText2,
      shouldNotify: true,
    );
  }

  /// 批量初始化编辑状态（不触发 notifyListeners，用于 initState）
  /// 
  /// 在 initState 中调用，第一帧会使用这些值
  /// 此方法不会触发UI重建，适合在Widget初始化时使用
  /// 
  /// 参数说明：
  /// - [templateId]: 模板ID，用于标识和恢复模板状态
  /// - [croppedImagePosition]: 裁剪后的图片位置（仅新模板使用）
  /// - [croppedImageScale]: 裁剪后的图片缩放比例（仅新模板使用）
  /// - [currentImageBytes]: 图片字节数据（Web平台）
  /// - [currentImageFile]: 图片文件（移动平台）
  /// - [dateText]: 日期文字
  /// - [sentenceText]: 短句文字
  /// - [dateText2]: 第二处日期文字（可选）
  /// - [sentenceText2]: 第二处短句文字（可选）
  void initializeStateSilent({
    required String templateId,
    required Offset croppedImagePosition,
    required double croppedImageScale,
    Uint8List? currentImageBytes,
    File? currentImageFile,
    required String dateText,
    required String sentenceText,
    String dateText2 = '',
    String sentenceText2 = '',
  }) {
    _initializeStateInternal(
      templateId: templateId,
      croppedImagePosition: croppedImagePosition,
      croppedImageScale: croppedImageScale,
      currentImageBytes: currentImageBytes,
      currentImageFile: currentImageFile,
      dateText: dateText,
      sentenceText: sentenceText,
      dateText2: dateText2,
      sentenceText2: sentenceText2,
      shouldNotify: false,
    );
  }

  /// 内部初始化状态方法
  /// 
  /// 统一处理状态初始化逻辑，避免代码重复，确保数据一致性
  /// 
  /// 核心流程：
  /// 1. 保存当前模板状态（如果有）
  /// 2. 判断是否为新模板
  /// 3. 如果是已存在的模板，恢复其状态
  /// 4. 如果是新模板，使用默认值并设置传入的参数
  /// 5. 更新图片和文字数据
  /// 6. 根据参数决定是否通知监听器
  void _initializeStateInternal({
    required String templateId,
    required Offset croppedImagePosition,
    required double croppedImageScale,
    Uint8List? currentImageBytes,
    File? currentImageFile,
    required String dateText,
    required String sentenceText,
    String dateText2 = '',
    String sentenceText2 = '',
    required bool shouldNotify,
  }) {
    // 步骤1: 保存当前模板状态（在切换模板前）
    _saveCurrentTemplateState();
    
    // 步骤2: 检查是否为新模板
    final bool isNewTemplate = !_templateStates.containsKey(templateId);
    
    // 步骤3: 更新模板ID
    _templateId = templateId;
    
    // 步骤4: 根据模板是否存在，恢复或初始化状态
    if (isNewTemplate) {
      // 新模板：初始化为默认状态，然后设置传入的参数
      _resetToDefaultState();
      
      // 设置图片位置和缩放（新模板特有参数）
      _croppedImagePosition = croppedImagePosition;
      _croppedImageScale = _validateScale(croppedImageScale);
      
      // 确保关键状态使用默认值
      _canvasAspectRatio = 3 / 4; // 默认3:4竖版
      _backgroundColor = Colors.white; // 默认白色背景
    } else {
      // 已存在的模板：恢复之前保存的状态
      _restoreTemplateState(templateId);
    }
    
    // 步骤5: 更新图片数据（无论新旧模板，都使用传入的图片数据）
    // 注意：图片数据是运行时数据，不从模板状态恢复
    _currentImageBytes = currentImageBytes;
    _currentImageFile = currentImageFile;
    
    // 步骤6: 更新文字数据
    // 注意：对于新模板，使用传入的文字；对于已存在的模板，恢复状态中的文字
    if (isNewTemplate) {
      _dateText = dateText;
      _sentenceText = sentenceText;
      _dateText2 = dateText2;
      _sentenceText2 = sentenceText2;
    }
    // 对于已存在的模板，文字数据已在 _restoreTemplateState 中恢复
    
    // 步骤7: 根据参数决定是否通知监听器
    if (shouldNotify) {
      notifyListeners();
    }
  }

  /// 验证缩放比例的有效性
  /// 
  /// 确保缩放比例在合理范围内，防止异常值导致显示问题
  double _validateScale(double scale) {
    if (scale <= 0) return 1.0;
    if (scale < EditProviderConstants.minScale) return EditProviderConstants.minScale;
    if (scale > EditProviderConstants.maxScale) return EditProviderConstants.maxScale;
    return scale;
  }

  /// 验证画布比例的有效性
  /// 
  /// 确保画布比例为正数，防止除零错误
  double _validateAspectRatio(double ratio) {
    if (ratio <= 0) return 3 / 4; // 默认3:4竖版
    return ratio;
  }

  /// 保存当前模板状态
  /// 
  /// 将当前所有编辑状态保存到模板状态映射中
  /// 只有当模板ID不为空时才执行保存操作
  /// 
  /// 保存的状态包括：
  /// - 图片调整参数（亮度、对比度、饱和度等）
  /// - 滤镜设置
  /// - 图片变换参数（旋转、翻转、位置、缩放）
  /// - 文字设置（字体、大小、位置、颜色）
  /// - 画布设置（背景颜色、比例、边距）
  /// - 文字内容（日期、短句）
  /// - 历史记录
  void _saveCurrentTemplateState() {
    // 只有当模板ID不为空时才保存状态
    if (_templateId.isEmpty) {
      return;
    }
    
    // 创建模板状态对象并保存到映射中
    _templateStates[_templateId] = TemplateState(
      // 图片调整参数
      brightness: _brightness,
      contrast: _contrast,
      saturation: _saturation,
      temperature: _temperature,
      fade: _fade,
      vignette: _vignette,
      blur: _blur,
      grain: _grain,
      sharpness: _sharpness,
      
      // 滤镜设置
      currentFilter: _currentFilter,
      filterStrength: _filterStrength,
      
      // 图片变换参数
      rotation: _rotation,
      flipHorizontal: _flipHorizontal,
      flipVertical: _flipVertical,
      croppedImagePosition: _croppedImagePosition,
      croppedImageScale: _croppedImageScale,
      
      // 文字设置
      textFont: _textFont,
      textFont2: _textFont2,
      textAlignment: _textAlignment,
      textAlignment2: _textAlignment2,
      textSize: _textSize,
      textSize2: _textSize2,
      textPosition: _textPosition,
      textPosition2: _textPosition2,
      textColor: _textColor,
      textColor2: _textColor2,
      textDirection: _textDirection,
      textDirection2: _textDirection2,
      
      // 画布设置
      backgroundColor: _backgroundColor,
      canvasAspectRatio: _canvasAspectRatio,
      marginLeft: _marginLeft,
      marginRight: _marginRight,
      marginTop: _marginTop,
      marginBottom: _marginBottom,
      
      // 文字内容
      dateText: _dateText,
      sentenceText: _sentenceText,
      dateText2: _dateText2,
      sentenceText2: _sentenceText2,
      
      // 历史记录（创建副本以避免引用问题）
      history: List<EditStateSnapshot>.from(_history),
      historyIndex: _historyIndex,
    );
  }
  
  /// 恢复模板状态
  /// 
  /// 从模板状态映射中恢复指定模板的所有编辑状态
  /// 如果模板不存在，则重置为默认状态
  /// 
  /// 参数：
  /// - [templateId]: 要恢复的模板ID
  /// 
  /// 恢复的状态包括：
  /// - 图片调整参数（亮度、对比度、饱和度等）
  /// - 滤镜设置
  /// - 图片变换参数（旋转、翻转、位置、缩放）
  /// - 文字设置（字体、大小、位置、颜色）
  /// - 画布设置（背景颜色、比例、边距）
  /// - 文字内容（日期、短句）
  /// - 历史记录
  void _restoreTemplateState(String templateId) {
    // 从映射中获取模板状态
    final state = _templateStates[templateId];
    
    // 如果模板不存在，重置为默认状态
    if (state == null) {
      _resetToDefaultState();
      return;
    }
    
    // 恢复图片调整参数
    _brightness = state.brightness;
    _contrast = state.contrast;
    _saturation = state.saturation;
    _temperature = state.temperature;
    _fade = state.fade;
    _vignette = state.vignette;
    _blur = state.blur;
    _grain = state.grain;
    _sharpness = state.sharpness;
    
    // 恢复滤镜设置
    _currentFilter = state.currentFilter;
    _filterStrength = state.filterStrength;
    
    // 恢复图片变换参数
    _rotation = state.rotation;
    _flipHorizontal = state.flipHorizontal;
    _flipVertical = state.flipVertical;
    _croppedImagePosition = state.croppedImagePosition;
    _croppedImageScale = _validateScale(state.croppedImageScale);
    
    // 恢复文字设置
    _textFont = state.textFont;
    _textFont2 = state.textFont2;
    _textAlignment = state.textAlignment;
    _textAlignment2 = state.textAlignment2;
    _textSize = state.textSize;
    _textSize2 = state.textSize2;
    _textPosition = state.textPosition;
    _textPosition2 = state.textPosition2;
    _textColor = state.textColor;
    _textColor2 = state.textColor2;
    _textDirection = state.textDirection;
    _textDirection2 = state.textDirection2;
    
    // 恢复画布设置
    _backgroundColor = state.backgroundColor;
    _canvasAspectRatio = _validateAspectRatio(state.canvasAspectRatio);
    _marginLeft = state.marginLeft;
    _marginRight = state.marginRight;
    _marginTop = state.marginTop;
    _marginBottom = state.marginBottom;
    
    // 恢复文字内容
    _dateText = state.dateText;
    _sentenceText = state.sentenceText;
    _dateText2 = state.dateText2;
    _sentenceText2 = state.sentenceText2;
    
    // 恢复历史记录（创建副本以避免引用问题）
    _history.clear();
    _history.addAll(state.history);
    _historyIndex = state.historyIndex;
  }
  
  /// 重置为默认状态
  /// 
  /// 将所有编辑参数重置为默认值
  /// 通常在创建新模板或模板状态不存在时调用
  void _resetToDefaultState() {
    // 获取默认状态
    final defaultState = TemplateState.defaultState();
    
    // 重置图片调整参数
    _brightness = defaultState.brightness;
    _contrast = defaultState.contrast;
    _saturation = defaultState.saturation;
    _temperature = defaultState.temperature;
    _fade = defaultState.fade;
    _vignette = defaultState.vignette;
    _blur = defaultState.blur;
    _grain = defaultState.grain;
    _sharpness = defaultState.sharpness;
    
    // 重置滤镜设置
    _currentFilter = defaultState.currentFilter;
    _filterStrength = defaultState.filterStrength;
    
    // 重置图片变换参数
    _rotation = defaultState.rotation;
    _flipHorizontal = defaultState.flipHorizontal;
    _flipVertical = defaultState.flipVertical;
    _croppedImagePosition = defaultState.croppedImagePosition;
    _croppedImageScale = defaultState.croppedImageScale;
    
    // 重置文字设置
    _textFont = defaultState.textFont;
    _textFont2 = defaultState.textFont2;
    _textAlignment = defaultState.textAlignment;
    _textAlignment2 = defaultState.textAlignment2;
    _textSize = defaultState.textSize;
    _textSize2 = defaultState.textSize2;
    _textPosition = defaultState.textPosition;
    _textPosition2 = defaultState.textPosition2;
    
    // 重置画布设置
    _backgroundColor = defaultState.backgroundColor;
    _textColor = defaultState.textColor;
    _textColor2 = defaultState.textColor2;
    _textDirection = defaultState.textDirection;
    _textDirection2 = defaultState.textDirection2;
    _canvasAspectRatio = defaultState.canvasAspectRatio;
    _marginLeft = defaultState.marginLeft;
    _marginRight = defaultState.marginRight;
    _marginTop = defaultState.marginTop;
    _marginBottom = defaultState.marginBottom;
    
    // 重置文字内容
    _dateText = defaultState.dateText;
    _sentenceText = defaultState.sentenceText;
    _dateText2 = defaultState.dateText2;
    _sentenceText2 = defaultState.sentenceText2;
    
    // 重置历史记录
    _history.clear();
    _historyIndex = -1;
  }

  /// 设置当前模板ID
  /// 
  /// 切换到指定模板，自动保存当前模板状态并恢复目标模板状态
  /// 如果目标模板不存在，将使用默认状态
  /// 
  /// [id] - 目标模板ID
  /// 
  /// 流程：
  /// 1. 检查是否为同一模板，如果是则不做任何操作
  /// 2. 保存当前模板状态
  /// 3. 切换到新模板ID
  /// 4. 恢复新模板的状态
  /// 5. 通知监听器更新
  void setTemplateId(String id) {
    // 如果是同一模板，不做任何操作
    if (_templateId == id) return;
    
    // 保存当前模板状态
    _saveCurrentTemplateState();
    
    // 切换到新模板
    _templateId = id;
    
    // 恢复新模板的状态
    _restoreTemplateState(id);
    
    // 通知监听器
    notifyListeners();
  }

  /// 设置图片位置
  /// 
  /// [position] - 图片位置
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setImagePosition(Offset position) {
    if (_imagePosition != position) {
      _imagePosition = position;
      notifyListeners();
    }
  }

  /// 设置文字位置
  /// 
  /// [position] - 文字位置
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextPosition(Offset position) {
    if (_textPosition != position) {
      _textPosition = position;
      notifyListeners();
    }
  }

  /// 设置第二处文字位置
  /// 
  /// [position] - 第二处文字位置
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextPosition2(Offset position) {
    if (_textPosition2 != position) {
      _textPosition2 = position;
      notifyListeners();
    }
  }

  /// 设置是否正在拖动图片
  /// 
  /// [value] - 是否正在拖动图片
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setIsDraggingImage(bool value) {
    if (_isDraggingImage != value) {
      _isDraggingImage = value;
      notifyListeners();
    }
  }

  /// 设置是否正在拖动文字
  /// 
  /// [value] - 是否正在拖动文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setIsDraggingText(bool value) {
    if (_isDraggingText != value) {
      _isDraggingText = value;
      notifyListeners();
    }
  }

  /// 设置是否正在拖动第二处文字
  /// 
  /// [value] - 是否正在拖动第二处文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setIsDraggingText2(bool value) {
    if (_isDraggingText2 != value) {
      _isDraggingText2 = value;
      notifyListeners();
    }
  }

  /// 设置上次拖动的偏移量
  /// 
  /// [offset] - 偏移量
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setLastDragOffset(Offset offset) {
    if (_lastDragOffset != offset) {
      _lastDragOffset = offset;
      notifyListeners();
    }
  }

  /// 设置文字字体
  /// 
  /// [font] - 字体名称
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextFont(String font) {
    if (_textFont != font) {
      _textFont = font;
      notifyListeners();
    }
  }

  /// 设置第二处文字字体
  /// 
  /// [font] - 第二处文字字体名称
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextFont2(String font) {
    if (_textFont2 != font) {
      _textFont2 = font;
      notifyListeners();
    }
  }

  /// 设置文字位置
  /// 
  /// [position] - 位置（left, center, right）
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextAlignment(String position) {
    if (_textAlignment != position) {
      _textAlignment = position;
      notifyListeners();
    }
  }

  /// 设置第二处文字位置
  /// 
  /// [position] - 第二处文字位置（left, center, right）
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextAlignment2(String position) {
    if (_textAlignment2 != position) {
      _textAlignment2 = position;
      notifyListeners();
    }
  }

  /// 设置文字大小
  /// 
  /// [size] - 文字大小
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextSize(double size) {
    if (_textSize != size) {
      _textSize = size;
      notifyListeners();
    }
  }

  /// 设置第二处文字大小
  /// 
  /// [size] - 第二处文字大小
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextSize2(double size) {
    if (_textSize2 != size) {
      _textSize2 = size;
      notifyListeners();
    }
  }
  
  /// 获取日期文字
  String get dateText => _dateText;
  
  /// 获取短句文字
  String get sentenceText => _sentenceText;
  
  /// 获取第二处日期文字
  String get dateText2 => _dateText2;
  
  /// 获取第二处短句文字
  String get sentenceText2 => _sentenceText2;
  
  /// 获取背景颜色
  Color get backgroundColor => _backgroundColor;
  
  /// 获取文字颜色
  Color get textColor => _textColor;
  
  /// 获取第二处文字颜色
  Color get textColor2 => _textColor2;
  
  /// 获取文字方向
  String get textDirection => _textDirection;
  
  /// 获取第二处文字方向
  String get textDirection2 => _textDirection2;
  
  /// 设置日期文字
  /// 
  /// [text] - 日期文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setDateText(String text) {
    if (_dateText != text) {
      _dateText = text;
      notifyListeners();
    }
  }
  
  /// 设置短句文字
  /// 
  /// [text] - 短句文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setSentenceText(String text) {
    if (_sentenceText != text) {
      _sentenceText = text;
      notifyListeners();
    }
  }
  
  /// 设置第二处日期文字
  /// 
  /// [text] - 第二处日期文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setDateText2(String text) {
    if (_dateText2 != text) {
      _dateText2 = text;
      notifyListeners();
    }
  }
  
  /// 设置第二处短句文字
  /// 
  /// [text] - 第二处短句文字
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setSentenceText2(String text) {
    if (_sentenceText2 != text) {
      _sentenceText2 = text;
      notifyListeners();
    }
  }
  
  /// 设置背景颜色
  /// 
  /// [color] - 背景颜色
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setBackgroundColor(Color color) {
    if (_backgroundColor != color) {
      _backgroundColor = color;
      notifyListeners();
    }
  }
  
  /// 设置文字颜色
  /// 
  /// [color] - 文字颜色
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextColor(Color color) {
    if (_textColor != color) {
      _textColor = color;
      notifyListeners();
    }
  }
  
  /// 设置第二处文字颜色
  /// 
  /// [color] - 第二处文字颜色
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextColor2(Color color) {
    if (_textColor2 != color) {
      _textColor2 = color;
      notifyListeners();
    }
  }
  
  /// 设置文字方向
  /// 
  /// [direction] - 文字方向 (horizontal 或 vertical)
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextDirection(String direction) {
    if (_textDirection != direction) {
      _textDirection = direction;
      notifyListeners();
    }
  }
  
  /// 设置第二处文字方向
  /// 
  /// [direction] - 文字方向 (horizontal 或 vertical)
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setTextDirection2(String direction) {
    if (_textDirection2 != direction) {
      _textDirection2 = direction;
      notifyListeners();
    }
  }
  
  /// 获取左边距
  double get marginLeft => _marginLeft;
  
  /// 设置左边距
  /// 
  /// [value] - 左边距值
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setMarginLeft(double value) {
    if (_marginLeft != value) {
      _marginLeft = value;
      notifyListeners();
    }
  }
  
  /// 获取右边距
  double get marginRight => _marginRight;
  
  /// 设置右边距
  /// 
  /// [value] - 右边距值
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setMarginRight(double value) {
    if (_marginRight != value) {
      _marginRight = value;
      notifyListeners();
    }
  }
  
  /// 获取上边距
  double get marginTop => _marginTop;
  
  /// 设置上边距
  /// 
  /// [value] - 上边距值
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setMarginTop(double value) {
    if (_marginTop != value) {
      _marginTop = value;
      notifyListeners();
    }
  }
  
  /// 获取下边距
  double get marginBottom => _marginBottom;
  
  /// 设置下边距
  /// 
  /// [value] - 下边距值
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setMarginBottom(double value) {
    if (_marginBottom != value) {
      _marginBottom = value;
      notifyListeners();
    }
  }
  
  /// 获取画布比例
  double get canvasAspectRatio => _canvasAspectRatio;
  
  /// 设置画布比例
  /// 
  /// [ratio] - 画布比例，必须为正数
  /// 
  /// 性能优化：只有当值真正改变时才调用 notifyListeners
  void setCanvasAspectRatio(double ratio) {
    final validatedRatio = _validateAspectRatio(ratio);
    
    if (_canvasAspectRatio != validatedRatio) {
      _canvasAspectRatio = validatedRatio;
      notifyListeners();
    }
  }

  /// 重置所有编辑参数
  void resetAdjustments() {
    _brightness = 0.0;
    _contrast = 0.0;
    _saturation = 0.0;
    _temperature = 0.0;
    _fade = 0.0;
    _vignette = 0.0;
    _blur = 0.0;
    _grain = 0.0;
    _sharpness = 0.0;
    _currentFilter = EditProviderConstants.defaultFilter;
    _filterStrength = EditProviderConstants.defaultFilterStrength;
    _rotation = EditProviderConstants.defaultRotation;
    _flipHorizontal = false;
    _flipVertical = false;
    _croppedImagePosition = Offset.zero;
    _croppedImageScale = 1.0;
    _backgroundColor = Colors.white;
    _textColor = Colors.black;
    _textColor2 = const Color(0xFF666666);
    _textFont = EditProviderConstants.defaultTextFont;
    _textFont2 = EditProviderConstants.defaultTextFont;
    _textAlignment = EditProviderConstants.defaultTextAlignment;
    _textAlignment2 = 'right';
    _textSize = EditProviderConstants.defaultTextSize;
    _textSize2 = EditProviderConstants.defaultTextSize;
    _textPosition = const Offset(0, -15);
    _textPosition2 = const Offset(0, -15);
    _marginLeft = 0.0;
    _marginRight = 0.0;
    _marginTop = 0.0;
    _marginBottom = 0.0;
    notifyListeners();
  }

  /// 重置裁剪参数
  void resetCrop() {
    _croppedImagePosition = Offset.zero;
    _croppedImageScale = 1.0;
    _flipHorizontal = false;
    _flipVertical = false;
    notifyListeners();
  }

  /// 性能优化：带节流的历史记录保存
  /// 
  /// 使用节流机制限制历史记录保存频率，避免频繁操作时产生大量历史记录
  /// 在拖动滑块等频繁操作时特别有用
  void saveStateToHistoryWithThrottle() {
    if (!_canSaveHistory) {
      return; // 节流中，跳过本次保存
    }
    
    saveStateToHistory();
    
    // 启动节流定时器
    _canSaveHistory = false;
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(milliseconds: throttleDelay), () {
      _canSaveHistory = true;
    });
  }

  /// 性能优化：防抖通知
  /// 
  /// 延迟通知，避免在短时间内多次触发 notifyListeners
  /// 适用于频繁更新的场景，如拖动滑块
  void _debounceNotifyListeners() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: debounceDelay), () {
      notifyListeners();
    });
  }

  /// 保存当前状态到历史记录
  /// 
  /// 性能优化：
  /// 1. 限制历史记录数量，避免内存占用过大
  /// 2. 自动清理旧记录，保持内存使用稳定
  void saveStateToHistory() {
    // 如果当前不在历史记录的末尾，删除当前索引之后的所有记录
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }

    // 创建当前状态的快照
    final snapshot = EditStateSnapshot(
      brightness: _brightness,
      contrast: _contrast,
      saturation: _saturation,
      temperature: _temperature,
      fade: _fade,
      vignette: _vignette,
      blur: _blur,
      grain: _grain,
      sharpness: _sharpness,
      currentFilter: _currentFilter,
      filterStrength: _filterStrength,
      rotation: _rotation,
      flipHorizontal: _flipHorizontal,
      flipVertical: _flipVertical,
      croppedImagePosition: _croppedImagePosition,
      croppedImageScale: _croppedImageScale,
      textFont: _textFont,
      textFont2: _textFont2,
      textAlignment: _textAlignment,
      textAlignment2: _textAlignment2,
      textSize: _textSize,
      textSize2: _textSize2,
      textPosition: _textPosition,
      textPosition2: _textPosition2,
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      textColor2: _textColor2,
      textDirection: _textDirection,
      textDirection2: _textDirection2,
      canvasAspectRatio: _canvasAspectRatio,
      marginLeft: _marginLeft,
      marginRight: _marginRight,
      marginTop: _marginTop,
      marginBottom: _marginBottom,
    );

    // 添加快照到历史记录
    _history.add(snapshot);

    // 如果历史记录超过最大长度，删除最早的记录
    if (_history.length > maxHistoryLength) {
      _history.removeAt(0);
      // 如果当前索引大于0，需要减1，因为删除了一个元素
      if (_historyIndex > 0) {
        _historyIndex--;
      }
    } else {
      _historyIndex++;
    }
    
    // 性能优化：定期清理模板状态缓存，释放内存
    if (_history.length > historyCleanupThreshold) {
      _cleanupOldTemplateStates();
    }
  }
  
  /// 性能优化：清理旧的模板状态
  /// 
  /// 当模板状态数量过多时，清理不常用的状态，释放内存
  /// 保留最近使用的模板状态
  void _cleanupOldTemplateStates() {
    // 如果模板状态数量超过10个，清理最旧的5个
    if (_templateStates.length > 10) {
      final keysToRemove = _templateStates.keys.take(5).toList();
      for (final key in keysToRemove) {
        if (key != _templateId) { // 不清理当前模板
          _templateStates.remove(key);
        }
      }
    }
  }
  
  /// 性能优化：手动清理历史记录
  /// 
  /// 清空所有历史记录，释放内存
  /// 通常在完成一次保存操作后调用
  void clearHistory() {
    _history.clear();
    _historyIndex = -1;
  }

  /// 撤销操作
  void undo() {
    if (_historyIndex > 0 && _history.isNotEmpty) {
      _historyIndex--;
      // 确保索引在有效范围内
      _historyIndex = _historyIndex.clamp(0, _history.length - 1);
      _restoreStateFromSnapshot(_history[_historyIndex]);
    }
  }

  /// 重做操作
  void redo() {
    if (_historyIndex < _history.length - 1 && _history.isNotEmpty) {
      _historyIndex++;
      // 确保索引在有效范围内
      _historyIndex = _historyIndex.clamp(0, _history.length - 1);
      _restoreStateFromSnapshot(_history[_historyIndex]);
    }
  }

  /// 从快照恢复状态
  void _restoreStateFromSnapshot(EditStateSnapshot snapshot) {
    _brightness = snapshot.brightness;
    _contrast = snapshot.contrast;
    _saturation = snapshot.saturation;
    _temperature = snapshot.temperature;
    _fade = snapshot.fade;
    _vignette = snapshot.vignette;
    _blur = snapshot.blur;
    _grain = snapshot.grain;
    _sharpness = snapshot.sharpness;
    _currentFilter = snapshot.currentFilter;
    _filterStrength = snapshot.filterStrength;
    _rotation = snapshot.rotation;
    _flipHorizontal = snapshot.flipHorizontal;
    _flipVertical = snapshot.flipVertical;
    _croppedImagePosition = snapshot.croppedImagePosition;
    _croppedImageScale = snapshot.croppedImageScale;
    _textFont = snapshot.textFont;
    _textFont2 = snapshot.textFont2;
    _textAlignment = snapshot.textAlignment;
    _textAlignment2 = snapshot.textAlignment2;
    _textSize = snapshot.textSize;
    _textSize2 = snapshot.textSize2;
    _textPosition = snapshot.textPosition;
    _textPosition2 = snapshot.textPosition2;
    _backgroundColor = snapshot.backgroundColor;
    _textColor = snapshot.textColor;
    _textColor2 = snapshot.textColor2;
    _textDirection = snapshot.textDirection;
    _textDirection2 = snapshot.textDirection2;
    _canvasAspectRatio = snapshot.canvasAspectRatio;
    _marginLeft = snapshot.marginLeft;
    _marginRight = snapshot.marginRight;
    _marginTop = snapshot.marginTop;
    _marginBottom = snapshot.marginBottom;
    
    notifyListeners();
  }

  /// 检查是否可以撤销
  bool get canUndo => _historyIndex > 0 && _history.isNotEmpty;

  /// 检查是否可以重做
  bool get canRedo => _history.isNotEmpty && _historyIndex < _history.length - 1;

  /// 清理指定模板的状态
  /// 
  /// 从内存中移除指定模板的状态数据，释放内存
  /// 注意：清理后无法恢复该模板的状态
  /// 
  /// [templateId] - 要清理的模板ID
  void clearTemplateState(String templateId) {
    _templateStates.remove(templateId);
  }

  /// 清理所有模板状态
  /// 
  /// 从内存中移除所有模板的状态数据，释放内存
  /// 注意：清理后无法恢复任何模板的状态
  void clearAllTemplateStates() {
    _templateStates.clear();
  }

  /// 获取当前保存的模板数量
  /// 
  /// 返回当前内存中保存的模板状态数量
  int get savedTemplateCount => _templateStates.length;

  /// 检查指定模板是否有保存的状态
  /// 
  /// [templateId] - 要检查的模板ID
  /// 返回：true 如果模板有保存的状态，false 否则
  bool hasTemplateState(String templateId) {
    return _templateStates.containsKey(templateId);
  }
  
  /// 性能优化：清理资源
  /// 
  /// 在 Provider 被销毁时调用，清理定时器等资源
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    super.dispose();
  }
}

