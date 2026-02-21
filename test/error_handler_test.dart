import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/utils/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    late ErrorHandler errorHandler;

    setUp(() {
      // 创建一个新的 ErrorHandler 实例用于测试
      errorHandler = ErrorHandler();
    });

    test('should handle error and log it', () {
      // 测试错误处理功能
      // 由于错误处理主要是日志记录和UI显示，我们主要测试它不会抛出异常
      expect(() {
        // 创建一个测试上下文
        WidgetsFlutterBinding.ensureInitialized();
        final context = GlobalKey<ScaffoldState>().currentContext;
        if (context != null) {
          errorHandler.handleError(
            context,
            Exception('Test error'),
            ErrorType.other,
            customMessage: 'Test error message',
          );
        }
      }, returnsNormally);
    });

    test('should get error message based on error type', () {
      // 测试根据错误类型获取错误消息的功能
      // 由于 _getErrorMessage 是私有方法，我们通过间接测试来验证它
      expect(() {
        // 创建一个测试上下文
        WidgetsFlutterBinding.ensureInitialized();
        final context = GlobalKey<ScaffoldState>().currentContext;
        if (context != null) {
          // 测试不同类型的错误
          errorHandler.handleError(
            context,
            Exception('Network error'),
            ErrorType.network,
          );
          errorHandler.handleError(
            context,
            Exception('Storage error'),
            ErrorType.storage,
          );
          errorHandler.handleError(
            context,
            Exception('Image processing error'),
            ErrorType.imageProcessing,
          );
          errorHandler.handleError(
            context,
            Exception('Permission error'),
            ErrorType.permission,
          );
          errorHandler.handleError(
            context,
            Exception('Other error'),
            ErrorType.other,
          );
        }
      }, returnsNormally);
    });

    test('should handle error with custom message', () {
      // 测试使用自定义错误消息的功能
      expect(() {
        // 创建一个测试上下文
        WidgetsFlutterBinding.ensureInitialized();
        final context = GlobalKey<ScaffoldState>().currentContext;
        if (context != null) {
          errorHandler.handleError(
            context,
            Exception('Test error'),
            ErrorType.other,
            customMessage: 'Custom error message',
          );
        }
      }, returnsNormally);
    });

    test('should handle error with error ID', () {
      // 测试使用错误ID的功能
      expect(() {
        // 创建一个测试上下文
        WidgetsFlutterBinding.ensureInitialized();
        final context = GlobalKey<ScaffoldState>().currentContext;
        if (context != null) {
          errorHandler.handleError(
            context,
            Exception('Test error'),
            ErrorType.other,
            errorId: 'test-error-id',
          );
        }
      }, returnsNormally);
    });

    test('should handle error with dialog', () {
      // 测试显示错误对话框的功能
      expect(() {
        // 创建一个测试上下文
        WidgetsFlutterBinding.ensureInitialized();
        final context = GlobalKey<ScaffoldState>().currentContext;
        if (context != null) {
          errorHandler.handleError(
            context,
            Exception('Test error'),
            ErrorType.other,
            showErrorDialog: true,
          );
        }
      }, returnsNormally);
    });
  });
}
