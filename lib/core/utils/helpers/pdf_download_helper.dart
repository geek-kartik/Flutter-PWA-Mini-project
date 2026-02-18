import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

/// To define category of title
enum PdfHelperTitle { invoice }

/// Helper class to download any pdf files with given category of titles in [PdfHelperTitle]
class PdfDownloadHelper {
  static Future<void> downloadProtectedPdf({
    required String url,
    required PdfHelperTitle title,
  }) async {
    final response = await http.get(Uri.parse(url));

    final userAgent = html.window.navigator.userAgent.toLowerCase();

    final isIOS =
        userAgent.contains("iphone") ||
        userAgent.contains("ipad") ||
        userAgent.contains("ipod");

    if (isIOS) {
      html.window.location.href = url;
      return;
    }

    final blob = html.Blob([response.bodyBytes]);
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: blobUrl)
      ..setAttribute(
        "download",
        "${title.name}_${DateTime.now().millisecondsSinceEpoch}.pdf",
      )
      ..click();

    html.Url.revokeObjectUrl(blobUrl);
  }
}
