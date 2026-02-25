import 'package:clevertap_plugin/clevertap_plugin.dart';

class CleverTapService {
  static final CleverTapPlugin ct = CleverTapPlugin();

  static bool _initialized = false;

  /// INIT (call once after app loads)
  static Future<void> init({
    required String accountId,
    String? region,
    String? targetDomain,
    String? token,
  }) async {
    if (_initialized) return;

    await CleverTapPlugin.init(accountId, region, targetDomain, token);
    await CleverTapPlugin.setUseIP(false);

    await CleverTapPlugin.setDebugLevel(3);

    _initialized = true;
  }

  /// LOGIN USER
  static Future<void> login(Map<String, dynamic> profile) async {
    await CleverTapPlugin.onUserLogin(profile);
  }

  /// UPDATE PROFILE
  static Future<void> setProfile(Map<String, dynamic> profile) async {
    await CleverTapPlugin.profileSet(profile);
  }

  /// TRACK EVENT
  static Future<void> track(
    String name, {
    Map<String, dynamic>? props,
  }) async {
    await CleverTapPlugin.recordEvent(name, props ?? {});
  }

  /// SCREEN VIEW
  static Future<void> screen(String screenName) async {
    await CleverTapPlugin.recordScreenView(screenName);
  }
}
