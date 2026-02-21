// 非Web平台的HTML工具存根实现
// 在非Web平台使用，提供与Web平台相同的接口，但所有方法都抛出UnsupportedError异常

// 定义HtmlUtils接口
abstract class HtmlUtils {
  factory HtmlUtils() => StubHtmlUtils();
  
  dynamic createBlob(List<dynamic> blobParts, String type);
  String createObjectUrlFromBlob(dynamic blob);
  dynamic createAnchorElement(String href);
  void setAnchorDownload(dynamic anchor, String download);
  void clickAnchor(dynamic anchor);
  void revokeObjectUrl(String url);
}

// 非Web平台的存根实现
class StubHtmlUtils implements HtmlUtils {
  factory StubHtmlUtils() => StubHtmlUtils._();
  StubHtmlUtils._();
  
  @override
  dynamic createBlob(List<dynamic> blobParts, String type) {
    throw UnsupportedError('Web platform only');
  }
  
  @override
  String createObjectUrlFromBlob(dynamic blob) {
    throw UnsupportedError('Web platform only');
  }
  
  @override
  dynamic createAnchorElement(String href) {
    throw UnsupportedError('Web platform only');
  }
  
  @override
  void setAnchorDownload(dynamic anchor, String download) {
    throw UnsupportedError('Web platform only');
  }
  
  @override
  void clickAnchor(dynamic anchor) {
    throw UnsupportedError('Web platform only');
  }
  
  @override
  void revokeObjectUrl(String url) {
    throw UnsupportedError('Web platform only');
  }
}
