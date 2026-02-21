import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ColorControls extends StatefulWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorControls({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<ColorControls> createState() => _ColorControlsState();
}

class _ColorControlsState extends State<ColorControls> {
  late Color _selectedColor;
  late int _red;
  late int _green;
  late int _blue;
  late String _hexColor;
  int _currentColorGroup = 0;

  final List<Color> _presetColors = [
    const Color(0xFFFFFFFF),
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
    
    const Color(0xFFE9C46A),
    const Color(0xFFF4A261),
    const Color(0xFFF9A620),
    const Color(0xFFF4A900),
    const Color(0xFFE76F51),
    const Color(0xFFB7472A),
    const Color(0xFFE74C3C),
    
    const Color(0xFF2ECC71),
    const Color(0xFF4A7C59),
    const Color(0xFF3CB371),
    const Color(0xFF90EE90),
    const Color(0xFFA4AC86),
    const Color(0xFF7D8471),
    const Color(0xFF2D4A2B),
    
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
    const Color(0xFF2B1E3E),
    const Color(0xFF5D2E46),
    
    const Color(0xFF264653),
    const Color(0xFF36454F),
    const Color(0xFF1A2332),
    const Color(0xFF1E1E1E),
    const Color(0xFF708090),
    const Color(0xFF2B1E3E),
    const Color(0xFF4A4E8F),
  ];

  void _nextColorGroup() {
    setState(() {
      // 由于现在是自适应布局，不再需要分组，只需要一个简单的循环
      _currentColorGroup = (_currentColorGroup + 1) % 2; // 简单的左右切换
    });
  }

  void _previousColorGroup() {
    setState(() {
      // 由于现在是自适应布局，不再需要分组，只需要一个简单的循环
      _currentColorGroup = (_currentColorGroup - 1 + 2) % 2; // 简单的左右切换
    });
  }

  // 根据屏幕宽度和当前分组获取要显示的颜色
  List<Color> _getDisplayColors(double screenWidth) {
    // 每个颜色的宽度约为 32（包含间距）
    final colorsPerRow = (screenWidth / 32).floor();
    
    // 根据计算出的数量和当前分组选择要显示的颜色
    final startIndex = _currentColorGroup * colorsPerRow;
    final endIndex = startIndex + colorsPerRow;
    return _presetColors.sublist(
      startIndex,
      endIndex > _presetColors.length ? _presetColors.length : endIndex
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
    _red = widget.currentColor.red;
    _green = widget.currentColor.green;
    _blue = widget.currentColor.blue;
    _hexColor = _colorToHex(widget.currentColor);
  }

  @override
  void didUpdateWidget(covariant ColorControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentColor != oldWidget.currentColor) {
      setState(() {
        _selectedColor = widget.currentColor;
        _red = widget.currentColor.red;
        _green = widget.currentColor.green;
        _blue = widget.currentColor.blue;
        _hexColor = _colorToHex(widget.currentColor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '背景颜色',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              height: 50,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _hexColor,
                  style: TextStyle(
                    color: _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              '预设颜色',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                GestureDetector(
                  onTap: _previousColorGroup,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_left,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // 根据屏幕宽度获取要显示的颜色
                      final screenWidth = constraints.maxWidth;
                      final displayColors = _getDisplayColors(screenWidth);
                      
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: displayColors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                                _red = color.red;
                                _green = color.green;
                                _blue = color.blue;
                                _hexColor = _colorToHex(color);
                                widget.onColorChanged(color);
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                  color: _selectedColor == color ? Colors.black : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _nextColorGroup,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_right,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              '自定义颜色',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                _buildRGBInput('R', _red, (value) {
                  setState(() {
                    _red = value;
                    _selectedColor = Color.fromRGBO(_red, _green, _blue, 1.0);
                    _hexColor = _colorToHex(_selectedColor);
                    widget.onColorChanged(_selectedColor);
                  });
                }),
                const SizedBox(width: 6),
                _buildRGBInput('G', _green, (value) {
                  setState(() {
                    _green = value;
                    _selectedColor = Color.fromRGBO(_red, _green, _blue, 1.0);
                    _hexColor = _colorToHex(_selectedColor);
                    widget.onColorChanged(_selectedColor);
                  });
                }),
                const SizedBox(width: 6),
                _buildRGBInput('B', _blue, (value) {
                  setState(() {
                    _blue = value;
                    _selectedColor = Color.fromRGBO(_red, _green, _blue, 1.0);
                    _hexColor = _colorToHex(_selectedColor);
                    widget.onColorChanged(_selectedColor);
                  });
                }),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Text(
                  'HEX:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _hexColor),
                    onChanged: (text) {
                      setState(() {
                        _hexColor = text;
                        final color = _hexToColor(text);
                        if (color != null) {
                          _selectedColor = color;
                          _red = color.red;
                          _green = color.green;
                          _blue = color.blue;
                          widget.onColorChanged(color);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
        ),
      ),
    );
  }

  Widget _buildRGBInput(String label, int value, ValueChanged<int> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          TextField(
            controller: TextEditingController(text: value.toString()),
            onChanged: (text) {
              final int? newValue = int.tryParse(text);
              if (newValue != null && newValue >= 0 && newValue <= 255) {
                onChanged(newValue);
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }

  Color? _hexToColor(String hex) {
    try {
      final cleanedHex = hex.replaceAll('#', '');
      if (cleanedHex.length == 6) {
        return Color(int.parse(cleanedHex, radix: 16) + 0xFF000000);
      }
    } catch (e) {
    }
    return null;
  }
}
