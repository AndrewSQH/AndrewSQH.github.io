import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

/// 图片预览组件
class ImagePreview extends StatefulWidget {
  final File? processedImage;
  final Uint8List? imageBytes;
  final bool isImageZoomed;
  final Function() onDoubleTap;

  const ImagePreview({
    super.key,
    required this.processedImage,
    required this.imageBytes,
    required this.isImageZoomed,
    required this.onDoubleTap,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final template = appProvider.currentTemplate;

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(template.borderWidth),
        decoration: BoxDecoration(
          color: HexColor(template.backgroundColor),
          borderRadius: BorderRadius.circular(template.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 15),
            ),
          ],
          border: Border.all(
            color: HexColor(template.borderColor),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(template.borderRadius - template.borderWidth),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(template.borderRadius - template.borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onDoubleTap: widget.onDoubleTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    transform: Matrix4.identity()..scale(widget.isImageZoomed ? 1.1 : 1.0),
                    child: (kIsWeb && widget.imageBytes != null)
                        ? Image.memory(
                            widget.imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,

                            errorBuilder: (context, error, stackTrace) {
                              print('图片显示错误: $error');
                              return Container(
                                color: const Color(0xFFF0F0F0),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Color(0xFFCCCCCC),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '图片无法显示',
                                        style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : widget.processedImage != null
                            ? Image.file(
                                widget.processedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,

                                errorBuilder: (context, error, stackTrace) {
                                  print('图片显示错误: $error');
                                  return Container(
                                    color: const Color(0xFFF0F0F0),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: Color(0xFFCCCCCC),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            '图片无法显示',
                                            style: TextStyle(
                                              color: Color(0xFF999999),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                  ),
                ),


              ],
            ),
          ),
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
