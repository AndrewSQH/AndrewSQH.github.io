import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class TextControls extends StatefulWidget {
  final String textFont;
  final ValueChanged<String> onTextFontChanged;
  final String textFont2;
  final ValueChanged<String> onTextFont2Changed;
  final List<String> fonts;
  final Map<String, String> fontNames;
  final String textPosition;
  final ValueChanged<String> onTextPositionChanged;
  final String textPosition2;
  final ValueChanged<String> onTextPosition2Changed;
  final double textSize;
  final ValueChanged<double> onTextSizeChanged;
  final double textSize2;
  final ValueChanged<double> onTextSize2Changed;
  final Color textColor;
  final ValueChanged<Color> onTextColorChanged;
  final Color textColor2;
  final ValueChanged<Color> onTextColor2Changed;
  final String dateText;
  final ValueChanged<String> onDateTextChanged;
  final String dateText2;
  final ValueChanged<String> onDateText2Changed;
  final String sentenceText;
  final ValueChanged<String> onSentenceTextChanged;
  final String sentenceText2;
  final ValueChanged<String> onSentenceText2Changed;
  final String textDirection;
  final ValueChanged<String> onTextDirectionChanged;
  final String textDirection2;
  final ValueChanged<String> onTextDirection2Changed;

  const TextControls({
    super.key,
    required this.textFont,
    required this.onTextFontChanged,
    required this.textFont2,
    required this.onTextFont2Changed,
    required this.fonts,
    required this.fontNames,
    required this.textPosition,
    required this.onTextPositionChanged,
    required this.textPosition2,
    required this.onTextPosition2Changed,
    required this.textSize,
    required this.onTextSizeChanged,
    required this.textSize2,
    required this.onTextSize2Changed,
    required this.textColor,
    required this.onTextColorChanged,
    required this.textColor2,
    required this.onTextColor2Changed,
    required this.dateText,
    required this.onDateTextChanged,
    required this.dateText2,
    required this.onDateText2Changed,
    required this.sentenceText,
    required this.onSentenceTextChanged,
    required this.sentenceText2,
    required this.onSentenceText2Changed,
    required this.textDirection,
    required this.onTextDirectionChanged,
    required this.textDirection2,
    required this.onTextDirection2Changed,
  });

  @override
  State<TextControls> createState() => _TextControlsState();
}

class _TextControlsState extends State<TextControls> {
  late TextEditingController _rController;
  late TextEditingController _gController;
  late TextEditingController _bController;
  late TextEditingController _hexController;
  late TextEditingController _dateTextController;
  late TextEditingController _sentenceTextController;
  
  int _currentTextIndex = 1;

  @override
  void initState() {
    super.initState();
    _updateColorControllers();
    _updateTextControllers();
  }

  @override
  void didUpdateWidget(covariant TextControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentTextIndex == 1 && widget.textColor != oldWidget.textColor) {
      _updateColorControllers();
    } else if (_currentTextIndex == 2 && widget.textColor2 != oldWidget.textColor2) {
      _updateColorControllers();
    }
    if ((_currentTextIndex == 1 && widget.dateText != oldWidget.dateText) ||
        (_currentTextIndex == 2 && widget.dateText2 != oldWidget.dateText2) ||
        (_currentTextIndex == 1 && widget.sentenceText != oldWidget.sentenceText) ||
        (_currentTextIndex == 2 && widget.sentenceText2 != oldWidget.sentenceText2)) {
      _updateTextControllers();
    }
  }

  Color get _currentTextColor => _currentTextIndex == 1 ? widget.textColor : widget.textColor2;
  String get _currentTextFont => _currentTextIndex == 1 ? widget.textFont : widget.textFont2;
  String get _currentTextPosition => _currentTextIndex == 1 ? widget.textPosition : widget.textPosition2;
  double get _currentTextSize => _currentTextIndex == 1 ? widget.textSize : widget.textSize2;
  String get _currentDateText => _currentTextIndex == 1 ? widget.dateText : widget.dateText2;
  String get _currentSentenceText => _currentTextIndex == 1 ? widget.sentenceText : widget.sentenceText2;
  String get _currentTextDirection => _currentTextIndex == 1 ? widget.textDirection : widget.textDirection2;

  void _updateColorControllers() {
    final color = _currentTextColor;
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    _rController = TextEditingController(text: r.toString());
    _gController = TextEditingController(text: g.toString());
    _bController = TextEditingController(text: b.toString());
    _hexController = TextEditingController(
      text: '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase()
    );
  }

  void _switchTextIndex(int index) {
    setState(() {
      _currentTextIndex = index;
      _updateColorControllers();
      _updateTextControllers();
    });
  }

  @override
  void dispose() {
    _rController.dispose();
    _gController.dispose();
    _bController.dispose();
    _hexController.dispose();
    _dateTextController.dispose();
    _sentenceTextController.dispose();
    super.dispose();
  }

  void _updateColorFromHex() {
    var hex = _hexController.text.trim();
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.length == 6) {
      try {
        final color = Color(int.parse(hex, radix: 16) | 0xFF000000);
        if (_currentTextIndex == 1) {
          widget.onTextColorChanged(color);
        } else {
          widget.onTextColor2Changed(color);
        }
      } catch (e) {
        debugPrint('解析颜色失败: $e');
      }
    }
  }

  void _updateTextControllers() {
    _dateTextController = TextEditingController(text: _currentDateText);
    _sentenceTextController = TextEditingController(text: _currentSentenceText);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _switchTextIndex(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _currentTextIndex == 1 ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _currentTextIndex == 1 ? AppColors.primary : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    '文字 1',
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentTextIndex == 1 ? Colors.white : AppColors.textSecondary,
                      fontWeight: _currentTextIndex == 1 ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _switchTextIndex(2),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _currentTextIndex == 2 ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _currentTextIndex == 2 ? AppColors.primary : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    '文字 2',
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentTextIndex == 2 ? Colors.white : AppColors.textSecondary,
                      fontWeight: _currentTextIndex == 2 ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextEditors(),
          const SizedBox(height: 12),
          _buildFontSelector(),
          const SizedBox(height: 12),
          _buildPositionSelector(),
          const SizedBox(height: 12),
          _buildSizeSlider(),
          const SizedBox(height: 12),
          _buildDirectionSelector(),
          const SizedBox(height: 12),
          _buildColorSelector(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTextEditors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '文字内容',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dateTextController,
          onChanged: (text) {
            if (_currentTextIndex == 1) {
              widget.onDateTextChanged(text);
            } else {
              widget.onDateText2Changed(text);
            }
          },
          decoration: InputDecoration(
            hintText: '请输入日期文字',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _sentenceTextController,
          onChanged: (text) {
            if (_currentTextIndex == 1) {
              widget.onSentenceTextChanged(text);
            } else {
              widget.onSentenceText2Changed(text);
            }
          },
          decoration: InputDecoration(
            hintText: '请输入短句文字',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '字体',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.fonts.map((font) {
            return _buildFontOption(font, widget.fontNames[font] ?? font);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFontOption(String value, String label) {
    final isSelected = _currentTextFont == value;
    return GestureDetector(
      onTap: () {
        if (_currentTextIndex == 1) {
          widget.onTextFontChanged(value);
        } else {
          widget.onTextFont2Changed(value);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '位置',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPositionOption('left', '左侧', Icons.format_align_left),
            const SizedBox(width: 8),
            _buildPositionOption('center', '中间', Icons.format_align_center),
            const SizedBox(width: 8),
            _buildPositionOption('right', '右侧', Icons.format_align_right),
          ],
        ),
      ],
    );
  }

  Widget _buildPositionOption(String value, String label, IconData icon) {
    final isSelected = _currentTextPosition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentTextIndex == 1) {
            widget.onTextPositionChanged(value);
          } else {
            widget.onTextPosition2Changed(value);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '文字大小',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _currentTextSize.round().toString(),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.sliderActive,
            inactiveTrackColor: AppColors.sliderInactive,
            thumbColor: AppColors.sliderThumb,
            overlayColor: AppColors.primary.withAlpha(51),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _currentTextSize,
            min: 12,
            max: 48,
            divisions: 36,
            onChanged: (value) {
              if (_currentTextIndex == 1) {
                widget.onTextSizeChanged(value);
              } else {
                widget.onTextSize2Changed(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDirectionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '文字方向',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildDirectionOption('horizontal', '横排', Icons.format_align_left),
            const SizedBox(width: 8),
            _buildDirectionOption('vertical', '竖排', Icons.format_align_center),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionOption(String value, String label, IconData icon) {
    final isSelected = _currentTextDirection == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentTextIndex == 1) {
            widget.onTextDirectionChanged(value);
          } else {
            widget.onTextDirection2Changed(value);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    final List<Color> presetColors = [
      Colors.black,
      const Color(0xFF1E1E1E),
      const Color(0xFF1A2332),
      const Color(0xFF264653),
      const Color(0xFF36454F),
      const Color(0xFF2B1E3E),
      const Color(0xFF5D2E46),
      const Color(0xFF4A4E8F),
      const Color(0xFF708090),
      
      Colors.white,
      const Color(0xFFFAFAFA),
      const Color(0xFFF5F3ED),
      const Color(0xFFE6E6FA),
      const Color(0xFFF1FAEE),
      const Color(0xFFE8D5C4),
      const Color(0xFFD4E4F7),
      const Color(0xFFD4A5A5),
      const Color(0xFFA8DADC),
      const Color(0xFFD3D3D3),
      const Color(0xFFC0C0C0),
      
      const Color(0xFFE74C3C),
      const Color(0xFFE76F51),
      const Color(0xFFB7472A),
      const Color(0xFFF4A261),
      const Color(0xFFF9A620),
      const Color(0xFFF4A900),
      const Color(0xFFE9C46A),
      const Color(0xFFFFB6C1),
      const Color(0xFFFF6347),
      
      const Color(0xFF2ECC71),
      const Color(0xFF4A7C59),
      const Color(0xFF3CB371),
      const Color(0xFF90EE90),
      const Color(0xFFA4AC86),
      const Color(0xFF7D8471),
      const Color(0xFF2D4A2B),
      const Color(0xFF808000),
      
      const Color(0xFF3498DB),
      const Color(0xFF4A6FA5),
      const Color(0xFF4682B4),
      const Color(0xFF008080),
      const Color(0xFF2D8B8B),
      const Color(0xFF0066FF),
      const Color(0xFF00FFFF),
      
      const Color(0xFF9B59B6),
      const Color(0xFFA490C2),
      const Color(0xFF8A2BE2),
      const Color(0xFF9370DB),
      const Color(0xFFD8BFD8),
      
      const Color(0xFFFFD700),
      const Color(0xFFFF8C00),
      const Color(0xFFDAA520),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '文字颜色',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: _currentTextColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        // 直接显示所有预设颜色，使用 Wrap 组件自适应布局
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: presetColors.map((color) {
            return GestureDetector(
              onTap: () {
                if (_currentTextIndex == 1) {
                  widget.onTextColorChanged(color);
                } else {
                  widget.onTextColor2Changed(color);
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: _currentTextColor == color ? AppColors.primary : AppColors.borderLight,
                    width: _currentTextColor == color ? 2 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        
        Text(
          '自定义颜色',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hexController,
                onChanged: (value) {
                  _updateColorFromHex();
                },
                decoration: InputDecoration(
                  hintText: '#RRGGBB',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
