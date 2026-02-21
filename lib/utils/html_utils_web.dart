// Web平台的HTML工具实现
// 仅在Web平台使用，包含对dart:html的导入和使用

import 'dart:html' as html;

// 定义HtmlUtils接口
abstract class HtmlUtils {
  factory HtmlUtils() => WebHtmlUtils();
  
  dynamic createBlob(List<dynamic> blobParts, String type);
  String createObjectUrlFromBlob(dynamic blob);
  dynamic createAnchorElement(String href);
  void setAnchorDownload(dynamic anchor, String download);
  void clickAnchor(dynamic anchor);
  void revokeObjectUrl(String url);
}

// Web平台的实现
class WebHtmlUtils implements HtmlUtils {
  factory WebHtmlUtils() => WebHtmlUtils._();
  WebHtmlUtils._();
  
  @override
  dynamic createBlob(List<dynamic> blobParts, String type) {
    return html.Blob(blobParts, type);
  }
  
  @override
  String createObjectUrlFromBlob(dynamic blob) {
    return html.Url.createObjectUrlFromBlob(blob);
  }
  
  @override
  dynamic createAnchorElement(String href) {
    return html.AnchorElement(href: href);
  }
  
  @override
  void setAnchorDownload(dynamic anchor, String download) {
    anchor.download = download;
  }
  
  @override
  void clickAnchor(dynamic anchor) {
    anchor.click();
  }
  
  @override
  void revokeObjectUrl(String url) {
    html.Url.revokeObjectUrl(url);
  }
}
