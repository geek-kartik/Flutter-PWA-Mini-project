/// Central route path and name constants.
/// Use these for navigation and route definitions so path and name stay in sync.
class RouteConstants {
  RouteConstants._();

  static const String home = '/';
  static const String homeName = 'home';

  static const String login = '/login';
  static const String loginName = 'login';

  static const String cart = '/cart';
  static const String cartName = 'cart';

  static const String invoice = '/invoice/:invoiceId';
  static const String pdfViewerName = 'pdf_viewer';
}
