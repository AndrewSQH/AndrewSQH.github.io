import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utils/app_colors.dart';

class FreeCropDialog extends StatefulWidget {
  final Uint8List? imageBytes;
  final File? imageFile;
  final ValueChanged<Map<String, dynamic>> onCropComplete;

  const FreeCropDialog({
    super.key,
    this.imageBytes,
    this.imageFile,
    required this.onCropComplete,
  });

  @override
  State<FreeCropDialog> createState() => _FreeCropDialogState();
}

class _FreeCropDialogState extends State<FreeCropDialog> {
  double _imageScale = 1.0;
  Offset _imageOffset = Offset.zero;
  Size? _imageSize;
  Size? _displaySize;
  ui.Image? _loadedImage;
  bool _isLoading = true;
  
  Offset _baseOffset = Offset.zero;
  double _lastScale = 1.0;
  
  Rect _cropRect = Rect.zero;
  bool _isResizing = false;
  bool _isDragging = false;
  Alignment _resizeAlignment = Alignment.center;
  Offset _lastResizePosition = Offset.zero;
  Offset _lastDragPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      if (widget.imageBytes != null) {
        // 对于小图片，直接使用内存加载
        final codec = await ui.instantiateImageCodec(widget.imageBytes!);
        final frame = await codec.getNextFrame();
        setState(() {
          _loadedImage = frame.image;
          _imageSize = Size(frame.image.width.toDouble(), frame.image.height.toDouble());
          _isLoading = false;
        });
      } else if (widget.imageFile != null) {
        // 对于大图片，使用文件流加载，减少内存使用
        final file = widget.imageFile!;
        final length = await file.length();
        
        // 如果文件较小（小于10MB），直接读取
        if (length < 10 * 1024 * 1024) {
          final bytes = await file.readAsBytes();
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          setState(() {
            _loadedImage = frame.image;
            _imageSize = Size(frame.image.width.toDouble(), frame.image.height.toDouble());
            _isLoading = false;
          });
        } else {
          // 如果文件较大，使用文件流加载
          final stream = file.openRead();
          final bytesBuilder = BytesBuilder();
          await for (final chunk in stream) {
            bytesBuilder.add(chunk);
          }
          final bytes = bytesBuilder.toBytes();
          final codec = await ui.instantiateImageCodec(bytes, targetWidth: 1024, targetHeight: 1024);
          final frame = await codec.getNextFrame();
          setState(() {
            _loadedImage = frame.image;
            _imageSize = Size(frame.image.width.toDouble(), frame.image.height.toDouble());
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('加载图片失败: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _loadedImage?.dispose();
    super.dispose();
  }

  Future<void> _completeCrop() async {
    if (_loadedImage == null || _imageSize == null || _displaySize == null) {
      Navigator.of(context).pop();
      return;
    }

    try {
      final croppedBytes = await _cropImage();
      if (croppedBytes != null) {
        widget.onCropComplete({
          'bytes': croppedBytes,
          'offset': _imageOffset,
          'scale': _imageScale,
        });
      }
    } catch (e) {
      print('裁剪失败: $e');
    }
    
    Navigator.of(context).pop();
  }

  Future<Uint8List?> _cropImage() async {
    if (_loadedImage == null || _imageSize == null || _displaySize == null) {
      return null;
    }

    final imageWidth = _imageSize!.width;
    final imageHeight = _imageSize!.height;
    final displayWidth = _displaySize!.width;
    final displayHeight = _displaySize!.height;

    final fittedSize = _calculateFittedSize(_imageSize!, _displaySize!);
    
    final scaledWidth = fittedSize.width * _imageScale;
    final scaledHeight = fittedSize.height * _imageScale;
    
    final imageDisplayLeft = (displayWidth - scaledWidth) / 2 + _imageOffset.dx;
    final imageDisplayTop = (displayHeight - scaledHeight) / 2 + _imageOffset.dy;

    final cropLeft = _cropRect.left - imageDisplayLeft;
    final cropTop = _cropRect.top - imageDisplayTop;
    final cropWidth = _cropRect.width;
    final cropHeight = _cropRect.height;

    final scaleX = imageWidth / scaledWidth;
    final scaleY = imageHeight / scaledHeight;
    
    final srcLeft = cropLeft * scaleX;
    final srcTop = cropTop * scaleY;
    final srcWidth = cropWidth * scaleX;
    final srcHeight = cropHeight * scaleY;

    final safeSrcLeft = srcLeft.clamp(0.0, imageWidth);
    final safeSrcTop = srcTop.clamp(0.0, imageHeight);
    final safeSrcRight = (srcLeft + srcWidth).clamp(0.0, imageWidth);
    final safeSrcBottom = (srcTop + srcHeight).clamp(0.0, imageHeight);
    final safeSrcWidth = safeSrcRight - safeSrcLeft;
    final safeSrcHeight = safeSrcBottom - safeSrcTop;

    if (safeSrcWidth <= 0 || safeSrcHeight <= 0) {
      return null;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, safeSrcWidth, safeSrcHeight));

    canvas.drawImageRect(
      _loadedImage!,
      Rect.fromLTWH(safeSrcLeft, safeSrcTop, safeSrcWidth, safeSrcHeight),
      Rect.fromLTWH(0, 0, safeSrcWidth, safeSrcHeight),
      Paint(),
    );

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(safeSrcWidth.toInt(), safeSrcHeight.toInt());
    final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    
    croppedImage.dispose();

    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFF0F0F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '裁剪图片',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                constraints: BoxConstraints(
                  minHeight: 300,
                  maxHeight: 500,
                ),
                color: Colors.black,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _loadedImage == null
                        ? const Center(
                            child: Text(
                              '无法加载图片',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              _displaySize = Size(constraints.maxWidth, constraints.maxHeight);
                              return _buildCropArea(constraints);
                            },
                          ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFF0F0F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        '取消',
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _completeCrop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropArea(BoxConstraints constraints) {
    final containerSize = Size(constraints.maxWidth, constraints.maxHeight);
    
    if (_cropRect == Rect.zero && _imageSize != null) {
      final fittedSize = _calculateFittedSize(_imageSize!, containerSize);
      
      final imageDisplayLeft = (containerSize.width - fittedSize.width) / 2;
      final imageDisplayTop = (containerSize.height - fittedSize.height) / 2;
      
      double cropWidth, cropHeight;
      
      if (fittedSize.width / fittedSize.height > 3 / 4) {
        cropHeight = fittedSize.height;
        cropWidth = cropHeight * 3 / 4;
      } else {
        cropWidth = fittedSize.width;
        cropHeight = cropWidth * 4 / 3;
      }
      
      cropWidth = cropWidth.clamp(50.0, fittedSize.width);
      cropHeight = cropHeight.clamp(50.0, fittedSize.height);
      
      final cropLeft = imageDisplayLeft + (fittedSize.width - cropWidth) / 2;
      final cropTop = imageDisplayTop + (fittedSize.height - cropHeight) / 2;
      
      _cropRect = Rect.fromLTWH(
        cropLeft,
        cropTop,
        cropWidth,
        cropHeight,
      );
    }
    
    // 如果裁剪框仍然为零，使用默认值
    if (_cropRect == Rect.zero) {
      final cropWidth = containerSize.width * 0.75;
      final cropHeight = cropWidth * 4 / 3;
      final cropLeft = (containerSize.width - cropWidth) / 2;
      final cropTop = (containerSize.height - cropHeight) / 2;
      _cropRect = Rect.fromLTWH(cropLeft, cropTop, cropWidth, cropHeight);
    }

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          setState(() {
            final scaleFactor = pointerSignal.scrollDelta.dy > 0 ? 0.9 : 1.1;
            _imageScale = (_imageScale * scaleFactor).clamp(0.5, 5.0);
            _constrainImage(_cropRect, containerSize);
          });
        }
      },
      child: GestureDetector(
        onScaleStart: (details) {
          _baseOffset = _imageOffset;
          _lastScale = 1.0;
        },
        onScaleUpdate: (details) {
          setState(() {
            final scaleDelta = details.scale / _lastScale;
            _lastScale = details.scale;
            
            _imageScale = (_imageScale * scaleDelta).clamp(0.5, 5.0);
            
            final offset = details.focalPoint - details.localFocalPoint;
            _imageOffset = _baseOffset + offset;
            
            _constrainImage(_cropRect, containerSize);
          });
        },
        onScaleEnd: (details) {
          _baseOffset = _imageOffset;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black,
              ),
            ),
            
            Positioned.fill(
              child: ClipRect(
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(_imageOffset.dx, _imageOffset.dy)
                    ..scale(_imageScale, _imageScale),
                  alignment: Alignment.center,
                  child: RawImage(
                    image: _loadedImage,
                    fit: BoxFit.contain,
                    width: containerSize.width,
                    height: containerSize.height,
                  ),
                ),
              ),
            ),
            
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: CropOverlayPainter(cropRect: _cropRect),
                ),
              ),
            ),
            
            Positioned.fromRect(
              rect: _cropRect,
              child: GestureDetector(
                onPanStart: (details) {
                  _isDragging = true;
                  _lastDragPosition = details.globalPosition;
                },
                onPanUpdate: (details) {
                  if (_isDragging) {
                    setState(() {
                      final delta = details.globalPosition - _lastDragPosition;
                      _lastDragPosition = details.globalPosition;
                      
                      final newLeft = (_cropRect.left + delta.dx).clamp(0.0, containerSize.width - _cropRect.width);
                      final newTop = (_cropRect.top + delta.dy).clamp(0.0, containerSize.height - _cropRect.height);
                      
                      _cropRect = Rect.fromLTWH(
                        newLeft,
                        newTop,
                        _cropRect.width,
                        _cropRect.height,
                      );
                    });
                  }
                },
                onPanEnd: (details) {
                  _isDragging = false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      _buildResizeHandle(Alignment.topLeft, containerSize),
                      _buildResizeHandle(Alignment.topRight, containerSize),
                      _buildResizeHandle(Alignment.bottomLeft, containerSize),
                      _buildResizeHandle(Alignment.bottomRight, containerSize),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _constrainImage(Rect cropRect, Size containerSize) {
    if (_imageSize == null) return;
    
    final fittedSize = _calculateFittedSize(_imageSize!, containerSize);
    final scaledWidth = fittedSize.width * _imageScale;
    final scaledHeight = fittedSize.height * _imageScale;
    
    final minX = cropRect.right - scaledWidth / 2 - containerSize.width / 2;
    final maxX = cropRect.left + scaledWidth / 2 - containerSize.width / 2;
    final minY = cropRect.bottom - scaledHeight / 2 - containerSize.height / 2;
    final maxY = cropRect.top + scaledHeight / 2 - containerSize.height / 2;
    
    if (scaledWidth >= cropRect.width) {
      _imageOffset = Offset(
        _imageOffset.dx.clamp(minX, maxX),
        _imageOffset.dy,
      );
    }
    if (scaledHeight >= cropRect.height) {
      _imageOffset = Offset(
        _imageOffset.dx,
        _imageOffset.dy.clamp(minY, maxY),
      );
    }
  }

  Size _calculateFittedSize(Size imageSize, Size containerSize) {
    final imageAspect = imageSize.width / imageSize.height;
    final containerAspect = containerSize.width / containerSize.height;
    
    if (imageAspect > containerAspect) {
      return Size(containerSize.width, containerSize.width / imageAspect);
    } else {
      return Size(containerSize.height * imageAspect, containerSize.height);
    }
  }

  Widget _buildResizeHandle(Alignment alignment, Size containerSize) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onPanStart: (details) {
          _isResizing = true;
          _resizeAlignment = alignment;
          _lastResizePosition = details.globalPosition;
        },
        onPanUpdate: (details) {
          if (_isResizing) {
            setState(() {
              final delta = details.globalPosition - _lastResizePosition;
              _lastResizePosition = details.globalPosition;
              
              double newLeft = _cropRect.left;
              double newTop = _cropRect.top;
              double newWidth = _cropRect.width;
              double newHeight = _cropRect.height;
              
              const minSize = 50.0;
              
              if (_resizeAlignment == Alignment.topLeft || _resizeAlignment == Alignment.bottomLeft) {
                newLeft += delta.dx;
                newWidth -= delta.dx;
              }
              if (_resizeAlignment == Alignment.topRight || _resizeAlignment == Alignment.bottomRight) {
                newWidth += delta.dx;
              }
              if (_resizeAlignment == Alignment.topLeft || _resizeAlignment == Alignment.topRight) {
                newTop += delta.dy;
                newHeight -= delta.dy;
              }
              if (_resizeAlignment == Alignment.bottomLeft || _resizeAlignment == Alignment.bottomRight) {
                newHeight += delta.dy;
              }
              
              if (newWidth >= minSize && newHeight >= minSize) {
                newLeft = newLeft.clamp(0.0, containerSize.width - newWidth);
                newTop = newTop.clamp(0.0, containerSize.height - newHeight);
                
                _cropRect = Rect.fromLTWH(
                  newLeft,
                  newTop,
                  newWidth,
                  newHeight,
                );
                
                _constrainImage(_cropRect, containerSize);
              }
            });
          }
        },
        onPanEnd: (details) {
          _isResizing = false;
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cropRect, const Radius.circular(4)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final thirdWidth = cropRect.width / 3;
    final thirdHeight = cropRect.height / 3;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(cropRect.left + thirdWidth * i, cropRect.top),
        Offset(cropRect.left + thirdWidth * i, cropRect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(cropRect.left, cropRect.top + thirdHeight * i),
        Offset(cropRect.right, cropRect.top + thirdHeight * i),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! CropOverlayPainter || oldDelegate.cropRect != cropRect;
  }
}
