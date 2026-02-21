import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    // 模拟加载时间，实际项目中可以在这里进行初始化操作
    await Future.delayed(const Duration(seconds: 2));
    
    // 导航到主屏幕
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景图片
          Image.asset(
            'assets/templates/1.jpg',
            fit: BoxFit.cover,
          ),
          
          // 半透明遮罩
          Container(
            color: Colors.white.withOpacity(0.85),
          ),
          
          // 内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 应用图标或Logo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '笺',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // 应用名称
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  opacity: 1.0,
                  child: Text(
                    '笺佳至',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'XingKaiTi',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // 应用描述
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  opacity: 1.0,
                  child: Text(
                    '让记录与美好更简单',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                
                // 加载指示器
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  opacity: 1.0,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
