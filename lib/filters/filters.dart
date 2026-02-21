import 'package:flutter/material.dart';
import 'filter_base.dart';

/// 阿玛罗滤镜
class AmaroFilter extends FilterBase {
  AmaroFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增加对比度和亮度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 200, 100)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 30).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 复古滤镜
class AntiqueFilter extends FilterBase {
  AntiqueFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 棕褐色调
    final Paint sepiaPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 160, 120, 80)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), sepiaPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 美颜滤镜
class BeautyFilter extends FilterBase {
  BeautyFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 柔和肤色
    final Paint skinPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 245, 235)
      ..blendMode = BlendMode.lighten;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), skinPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 略微降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 黑猫滤镜
class BlackCatFilter extends FilterBase {
  BlackCatFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 显著增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 使图像变暗
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 添加轻微的蓝色调
    final Paint bluePaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 100, 150, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bluePaint);
  }
}

/// 布兰南滤镜
class BrannanFilter extends FilterBase {
  BrannanFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 添加蓝色调
    final Paint bluePaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 100, 150, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bluePaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 40).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 静谧滤镜
class CalmFilter extends FilterBase {
  CalmFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 添加柔和的绿色调
    final Paint greenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 150, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), greenPaint);
  }
}

/// 冷色调滤镜
class CoolFilter extends FilterBase {
  CoolFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的蓝色调
    final Paint bluePaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 100, 150, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bluePaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 蜡笔滤镜
class CrayonFilter extends FilterBase {
  CrayonFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 简化颜色（海报效果）
    final Paint posterPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.colorBurn;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), posterPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 添加轻微的颜色偏移
    final Paint colorShiftPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), colorShiftPaint);
  }
}

/// 早鸟滤镜
class EarlybirdFilter extends FilterBase {
  EarlybirdFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 30).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 祖母绿滤镜
class EmeraldFilter extends FilterBase {
  EmeraldFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加绿色调
    final Paint greenPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 100, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), greenPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 常青滤镜
class EvergreenFilter extends FilterBase {
  EvergreenFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的绿色调
    final Paint greenPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 80, 180, 120)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), greenPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 赫菲滤镜
class HefeFilter extends FilterBase {
  HefeFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 30).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 哈德逊滤镜
class HudsonFilter extends FilterBase {
  HudsonFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 2. 添加冷色调
    final Paint coolPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 100, 150, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), coolPaint);

    // 3. 略微降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 墨韵滤镜
class InkwellFilter extends FilterBase {
  InkwellFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 转换为灰度
    final Paint grayPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), grayPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 洛莫滤镜
class LomoFilter extends FilterBase {
  LomoFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 添加红色和绿色调
    final Paint colorPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 180, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), colorPaint);

    // 3. 强烈的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.7,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 120).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 1977滤镜
class N1977Filter extends FilterBase {
  N1977Filter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖粉色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 180, 160)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 纳什维尔滤镜
class NashvilleFilter extends FilterBase {
  NashvilleFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖棕色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 220, 180, 140)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 30).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 怀旧滤镜
class NostalgiaFilter extends FilterBase {
  NostalgiaFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 棕褐色调
    final Paint sepiaPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 160, 120, 80)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), sepiaPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 40).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 皮克斯滤镜
class PixarFilter extends FilterBase {
  PixarFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 鲜艳的色彩
    final Paint vibrantPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vibrantPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 晨曦滤镜
class RiseFilter extends FilterBase {
  RiseFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 浪漫滤镜
class RomanceFilter extends FilterBase {
  RomanceFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的粉色调
    final Paint pinkPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 180, 200)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), pinkPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 樱花滤镜
class SakuraFilter extends FilterBase {
  SakuraFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的粉色调
    final Paint pinkPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 160, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), pinkPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 山景滤镜
class SierraFilter extends FilterBase {
  SierraFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 220, 180, 140)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 30).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 素描滤镜
class SketchFilter extends FilterBase {
  SketchFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 转换为灰度
    final Paint grayPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), grayPaint);

    // 2. 反相
    final Paint invertPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.difference;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), invertPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 美白滤镜
class SkinwhitenFilter extends FilterBase {
  SkinwhitenFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增亮图像
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 2. 添加柔和的白色调
    final Paint whitePaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 245, 235)
      ..blendMode = BlendMode.lighten;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), whitePaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 清甜滤镜
class SugarTabletsFilter extends FilterBase {
  SugarTabletsFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加鲜艳的色彩
    final Paint vibrantPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vibrantPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 日出滤镜
class SunriseFilter extends FilterBase {
  SunriseFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 180, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 晚霞滤镜
class SunsetFilter extends FilterBase {
  SunsetFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖橙色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 160, 80)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 苏特罗滤镜
class SutroFilter extends FilterBase {
  SutroFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 2. 添加暖棕色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 200, 140, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 3. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 4. 添加强烈的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.7,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 100).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 甜蜜滤镜
class SweetsFilter extends FilterBase {
  SweetsFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的粉彩色调
    final Paint pastelPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), pastelPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 温柔滤镜
class TenderFilter extends FilterBase {
  TenderFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 200, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 吐司2滤镜
class Toaster2Filter extends FilterBase {
  Toaster2Filter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 显著增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 2. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 3. 添加强烈的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.7,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 120).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

/// 瓦伦西亚滤镜
class ValenciaFilter extends FilterBase {
  ValenciaFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 2. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 150)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 瓦尔登湖滤镜
class WaldenFilter extends FilterBase {
  WaldenFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加绿蓝色调
    final Paint greenBluePaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 120, 200, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), greenBluePaint);

    // 2. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 暖色调滤镜
class WarmFilter extends FilterBase {
  WarmFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 200, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 白猫滤镜
class WhitecatFilter extends FilterBase {
  WhitecatFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 显著增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 2. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 添加轻微的蓝色调
    final Paint bluePaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 150, 200, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), bluePaint);
  }
}

/// XPRO II滤镜
class XproiiFilter extends FilterBase {
  XproiiFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的颜色偏移
    final Paint colorShiftPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 150, 200)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), colorShiftPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),
        Color.fromARGB((strength * 40).toInt(), 0, 0, 0),
      ],
    );
    final Paint vignettePaint = Paint()..shader = vignetteGradient.createShader(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vignettePaint);
  }
}

// EnjoyCamera filters

/// 阿宝滤镜
class AbaoFilter extends FilterBase {
  AbaoFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 200, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 魅光滤镜
class CharmFilter extends FilterBase {
  CharmFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的粉色调
    final Paint pinkPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 180, 200)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), pinkPaint);

    // 2. 略微降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 雅韵滤镜
class ElegantFilter extends FilterBase {
  ElegantFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加微妙的暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 200, 180)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 略微降低亮度
    final Paint darkenPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 0, 0, 0)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), darkenPaint);

    // 3. 略微增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 30).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);
  }
}

/// 范德尔滤镜
class FandelFilter extends FilterBase {
  FandelFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加金色调
    final Paint goldenPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 200, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), goldenPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 繁花滤镜
class FloralFilter extends FilterBase {
  FloralFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加柔和的粉彩色调
    final Paint pastelPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 255, 180, 200)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), pastelPaint);

    // 2. 略微降低对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 40).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.softLight;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 鸢尾滤镜
class IrisFilter extends FilterBase {
  IrisFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 增强色彩
    final Paint vibrantPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 200, 150, 255)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), vibrantPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 略微增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 50).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 鲜润滤镜
class JuicyFilter extends FilterBase {
  JuicyFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加新鲜色调
    final Paint freshPaint = Paint()
      ..color = Color.fromARGB((strength * 80).toInt(), 150, 255, 200)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), freshPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 增加亮度
    final Paint brightenPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 255, 255, 255)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), brightenPaint);
  }
}

/// 凯尔文滤镜
class LordKelvinFilter extends FilterBase {
  LordKelvinFilter(super.strength);

  @override
  void applyToCanvas(Canvas canvas, int width, int height) {
    // 1. 添加强烈的暖色调
    final Paint warmPaint = Paint()
      ..color = Color.fromARGB((strength * 100).toInt(), 255, 180, 100)
      ..blendMode = BlendMode.color;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), warmPaint);

    // 2. 增加对比度
    final Paint contrastPaint = Paint()
      ..color = Color.fromARGB((strength * 60).toInt(), 128, 128, 128)
      ..blendMode = BlendMode.overlay;
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), contrastPaint);

    // 3. 添加轻微的暗角
    final Gradient vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        Color.fromARGB(0, 0, 0, 0),