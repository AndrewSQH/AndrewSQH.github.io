import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 错误类型枚举
enum ErrorType {
  /// 网络错误
  network,
  /// 存储错误
  storage,
  /// 图片处理错误
  imageProcessing,
  /// 权限错误
  permission,
  /// 其他错误
  other,
}

/// 错误处理服务
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;

  ErrorHandler._internal();

  /// 处理错误
  /// [context] - BuildContext，用于显示错误提示
  /// [error] - 错误对象
  /// [errorType] - 错误类型
  /// [customMessage] - 自定义错误消息
  /// [showErrorDialog] - 是否显示错误对话框，默认为false，显示SnackBar
  void handleError(
    BuildContext context,
    dynamic error,
    ErrorType errorType,
    {String? customMessage,
    bool showErrorDialog = false,
    String? errorId}) {
    // 记录错误日志
    _logError(error, errorType, errorId);

    // 获取错误消息
    final String errorMessage = customMessage ?? _getErrorMessage(error, errorType);

    // 显示错误提示
    if (showErrorDialog) {
      _showErrorDialog(context, errorMessage);
    } else {
      _showErrorSnackBar(context, errorMessage);
    }
  }

  /// 记录错误日志
  void _logError(dynamic error, ErrorType errorType, String? errorId) {
    final String errorIdStr = errorId ?? DateTime.now().millisecondsSinceEpoch.toString();
    print('[ErrorHandler] [$errorIdStr] [${errorType.name}] Error: $error');
    
    // 这里可以添加更详细的日志记录，如发送到远程日志服务
  }

  /// 获取错误消息
  String _getErrorMessage(dynamic error, ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return '网络连接失败，请检查网络设置后重试';
      case ErrorType.storage:
        return '存储操作失败，请检查存储空间后重试';
      case ErrorType.imageProcessing:
        return '图片处理失败，请重试';
      case ErrorType.permission:
        return '权限不足，请授予必要的权限后重试';
      case ErrorType.other:
        return '操作失败，请重试';
    }
  }

  /// 显示错误对话框
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('错误'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 显示错误SnackBar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 显示成功提示
  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 显示信息提示
  void showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 显示警告提示
  void showWarningMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
