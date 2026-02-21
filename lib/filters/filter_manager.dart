import 'dart:typed_data';
import 'filter_base.dart';
import 'filters.dart';

/// 滤镜管理器，负责管理所有的滤镜
class FilterManager {
  /// 单例实例
  static final FilterManager _instance = FilterManager._internal();

  /// 工厂构造函数
  factory FilterManager() {
    return _instance;
  }

  /// 内部构造函数
  FilterManager._internal();

  /// 所有可用的滤镜
  final Map<String, FilterBase Function(double)> _filters = {
    'amaro': (strength) => AmaroFilter(strength),
    'antique': (strength) => AntiqueFilter(strength),
    'beauty': (strength) => BeautyFilter(strength),
    'blackcat': (strength) => BlackCatFilter(strength),
    'brannan': (strength) => BrannanFilter(strength),
    'brooklyn': (strength) => BrooklynFilter(strength),
    'calm': (strength) => CalmFilter(strength),
    'cool': (strength) => CoolFilter(strength),
    'crayon': (strength) => CrayonFilter(strength),
    'earlybird': (strength) => EarlybirdFilter(strength),
    'emerald': (strength) => EmeraldFilter(strength),
    'evergreen': (strength) => EvergreenFilter(strength),
    'freud': (strength) => FreudFilter(strength),
    'healthy': (strength) => HealthyFilter(strength),
    'hefe': (strength) => HefeFilter(strength),
    'hudson': (strength) => HudsonFilter(strength),
    'inkwell': (strength) => InkwellFilter(strength),
    'kevin_new': (strength) => KevinNewFilter(strength),
    'latte': (strength) => LatteFilter(strength),
    'lomo': (strength) => LomoFilter(strength),
    'n1977': (strength) => N1977Filter(strength),
    'nashville': (strength) => NashvilleFilter(strength),
    'nostalgia': (strength) => NostalgiaFilter(strength),
    'pixar': (strength) => PixarFilter(strength),
    'rise': (strength) => RiseFilter(strength),
    'romance': (strength) => RomanceFilter(strength),
    'sakura': (strength) => SakuraFilter(strength),
    'sierra': (strength) => SierraFilter(strength),
    'sketch': (strength) => SketchFilter(strength),
    'skinwhiten': (strength) => SkinwhitenFilter(strength),
    'sugar_tablets': (strength) => SugarTabletsFilter(strength),
    'sunrise': (strength) => SunriseFilter(strength),
    'sunset': (strength) => SunsetFilter(strength),
    'sutro': (strength) => SutroFilter(strength),
    'sweets': (strength) => SweetsFilter(strength),
    'tender': (strength) => TenderFilter(strength),
    'toaster2_filter_shader': (strength) => Toaster2Filter(strength),
    'valencia': (strength) => ValenciaFilter(strength),
    'walden': (strength) => WaldenFilter(strength),
    'warm': (strength) => WarmFilter(strength),
    'whitecat': (strength) => WhitecatFilter(strength),
    'xproii_filter_shader': (strength) => XproiiFilter(strength),
    // EnjoyCamera filters
    'abao': (strength) => AbaoFilter(strength),
    'charm': (strength) => CharmFilter(strength),
    'elegant': (strength) => ElegantFilter(strength),
    'fandel': (strength) => FandelFilter(strength),
    'floral': (strength) => FloralFilter(strength),
    'iris': (strength) => IrisFilter(strength),
    'juicy': (strength) => JuicyFilter(strength),
    'lord_kelvin': (strength) => LordKelvinFilter(strength),
    'mystical': (strength) => MysticalFilter(strength),
    'peach': (strength) => PeachFilter(strength),
    'pomelo': (strength) => PomeloFilter(strength),
    'rococo': (strength) => RococoFilter(strength),
    'snowy': (strength) => SnowyFilter(strength),
    'summer': (strength) => SummerFilter(strength),
    'sweet': (strength) => SweetFilter(strength),
    'toaster': (strength) => ToasterFilter(strength),
  };

  /// 滤镜中文名称映射
  final Map<String, String> _filterChineseNames = {
    'amaro': '阿玛罗',          // 保留：音译，行业常用（Instagram经典滤镜）
    'antique': '复古',          // 保留：直观准确，符合滤镜怀旧质感
    'beauty': '美颜',          // 保留：用户认知度高，直白易懂
    'blackcat': '黑猫',          // 保留：直译，简洁好记
    'brannan': '布兰南',        // 保留：音译，经典滤镜固定译法
    'brooklyn': '布鲁克林',      // 保留：地名音译，辨识度高
    'calm': '静谧',            // 优化：替代"平静"，更有氛围感，贴合滤镜柔和质感
    'cool': '冷色调',          // 保留：直观通用，也可备选"清冷"
    'crayon': '蜡笔',          // 保留：准确对应滤镜卡通蜡笔效果
    'earlybird': '早鸟',        // 优化：替代"晨鸟"，固定搭配更简洁，行业常用
    'emerald': '祖母绿',        // 优化：替代"翡翠"，更精准描述滤镜浓郁绿调，审美更高级
    'evergreen': '常青',        // 保留：有自然美感，贴合滤镜清新绿植质感
    'freud': '弗洛伊德',        // 保留：音译，对应人名，滤镜暗调复古风格匹配
    'healthy': '元气',          // 优化：替代"健康"，更符合中文用户对"红润有气色"滤镜的认知，更有感染力
    'hefe': '赫菲',            // 保留：音译，VSCO经典滤镜固定译法
    'hudson': '哈德逊',        // 保留：地名音译，贴合滤镜冷调户外质感
    'inkwell': '墨韵',          // 优化：替代"墨水瓶"，避免具象化，更贴合滤镜暗调水墨感
    'kevin_new': '凯文新版',    // 优化：替代"凯文新"，更清晰易懂，明确是新版本滤镜
    'latte': '拿铁',            // 保留：准确对应滤镜暖棕色调，像拿铁咖啡，用户易联想
    'lomo': '洛莫',            // 保留：音译，也可直接用"LOMO"，行业通用
    'n1977': '1977',            // 保留：数字直接使用，用户辨识度最高
    'nashville': '纳什维尔',    // 保留：地名音译，经典暖调滤镜固定译法
    'nostalgia': '怀旧',        // 保留：直观准确，贴合滤镜复古怀旧质感
    'pixar': '皮克斯',          // 保留：音译，对应皮克斯动画，滤镜明亮卡通风格匹配
    'rise': '晨曦',            // 优化：替代"日出"，避免与sunrise重复，更轻柔，贴合滤镜清晨微光质感
    'romance': '浪漫',          // 保留：直观准确，贴合滤镜柔焦唯美质感
    'sakura': '樱花',          // 保留：准确对应滤镜粉调樱花效果
    'sierra': '山景',           // 优化：替代"塞拉"，Sierra原意是"山脉"，滤镜偏户外清新，更直观
    'sketch': '素描',          // 保留：准确对应滤镜线条素描效果
    'skinwhiten': '美白',       // 保留：用户认知度高，直白易懂
    'sugar_tablets': '清甜',    // 优化：修正拼写为"sugar_tablets"，替代"糖果"，更贴合滤镜甜而不腻的浅色调
    'sunrise': '日出',          // 保留：与"晨曦"区分，更偏向朝阳浓烈感
    'sunset': '晚霞',           // 优化：替代"日落"，更有氛围感，贴合滤镜暖红晚霞质感
    'sutro': '苏特罗',          // 保留：音译，经典暗调滤镜固定译法
    'sweets': '甜蜜',          // 保留：直观准确，贴合滤镜甜美元气质感
    'tender': '温柔',          // 保留：直观准确，贴合滤镜柔焦温柔质感
    'toaster2_filter_shader': '吐司2', // 优化：替代"烤面包机2"，更简洁，符合中文滤镜称呼习惯
    'valencia': '瓦伦西亚',      // 保留：音译，VSCO经典暖调滤镜固定译法
    'walden': '瓦尔登湖',       // 优化：替代"瓦尔登"，增加"湖"字，更有文艺感（对应《瓦尔登湖》），贴合滤镜清新自然质感
    'warm': '暖色调',          // 保留：直观通用，也可备选"暖黄"
    'whitecat': '白猫',          // 保留：直译，简洁好记
    'xproii_filter_shader': 'XPRO II', // 保留：原名称直接使用，用户辨识度最高，简化冗余描述
    // Filters migrated from EnjoyCamera
    'abao': '阿宝',              // 音译，贴合滤镜温暖柔和风格
    'charm': '魅光',             // 直观准确，贴合滤镜优雅魅力风格
    'elegant': '雅韵',            // 直观准确，贴合滤镜精致优雅风格
    'fandel': '范德尔',           // 音译，贴合滤镜温暖金色风格
    'floral': '繁花',          // 直观准确，贴合滤镜花卉柔和风格
    'iris': '鸢尾',               // 直观准确，贴合滤镜鲜艳多彩风格
    'juicy': '鲜润',              // 直观准确，贴合滤镜新鲜多汁风格
    'lord_kelvin': '凯尔文',    // 音译，贴合滤镜温暖复古风格
    'mystical': '秘境',            // 直观准确，贴合滤镜神秘梦幻风格
    'peach': '蜜桃',              // 直观准确，贴合滤镜蜜桃粉色风格
    'pomelo': '青柚',              // 直观准确，贴合滤镜清新柑橘风格
    'rococo': '洛可可',            // 音译，贴合滤镜古典华丽风格
    'snowy': '雪肌',              // 直观准确，贴合滤镜雪白清凉风格
    'summer': '盛夏',              // 直观准确，贴合滤镜明亮夏日风格
    'sweet': '甜糯',              // 直观准确，贴合滤镜甜美柔和风格
    'toaster': '吐司',             // 直观准确，贴合滤镜温暖吐司风格
  };

  /// 中文名称到英文名称的映射
  late final Map<String, String> _chineseToEnglishFilters;

  /// 初始化
  void initialize() {
    _chineseToEnglishFilters = {
      for (var entry in _filterChineseNames.entries)
        entry.value: entry.key,
    };
  }

  /// 根据名称获取滤镜实例
  /// 
  /// [filterName] - 滤镜名称（支持中英文）
  /// [strength] - 滤镜强度 (0.0-1.0)
  /// 
  /// 返回滤镜实例
  FilterBase? getFilter(String filterName, {double strength = 1.0}) {
    // 确保初始化
    if (!_chineseToEnglishFilters.containsKey('阿玛罗')) {
      initialize();
    }

    // 如果是中文名称，转换为英文
    if (_chineseToEnglishFilters.containsKey(filterName)) {
      filterName = _chineseToEnglishFilters[filterName]!;
    }

    // 获取滤镜
    if (_filters.containsKey(filterName)) {
      return _filters[filterName]!(strength);
    }

    return null;
  }

  /// 列出所有可用的滤镜
  /// 
  /// [includeChinese] - 是否包含中文名称
  /// 
  /// 返回滤镜名称列表
  List<Map<String, String>> listFilters({bool includeChinese = true}) {
    // 确保初始化
    if (!_chineseToEnglishFilters.containsKey('阿玛罗')) {
      initialize();
    }

    if (includeChinese) {
      return _filters.keys.map((key) {
        return {
          'english': key,
          'chinese': _filterChineseNames[key] ?? key,
        };
      }).toList();
    } else {
      return _filters.keys.map((key) {
        return {'english': key};
      }).toList();
    }
  }

  /// 获取滤镜的中文名称
  /// 
  /// [filterName] - 滤镜英文名称
  /// 
  /// 返回滤镜中文名称
  String getFilterChineseName(String filterName) {
    // 确保初始化
    if (!_chineseToEnglishFilters.containsKey('阿玛罗')) {
      initialize();
    }

    return _filterChineseNames[filterName] ?? filterName;
  }

  /// 应用滤镜到图片
  /// 
  /// [imageBytes] - 输入图片的字节数据
  /// [filterName] - 滤镜名称（支持中英文）
  /// [strength] - 滤镜强度 (0.0-1.0)
  /// 
  /// 返回处理后的图片字节数据
  Future<Uint8List> applyFilter(Uint8List imageBytes, String filterName, {double strength = 1.0}) async {
    // 获取滤镜实例，实质上加强两倍
    final FilterBase? filter = getFilter(filterName, strength: strength * 2);
    if (filter == null) {
      print('滤镜不存在: $filterName');
      return imageBytes;
    }

    // 应用滤镜
    return await filter.apply(imageBytes);
  }
}
