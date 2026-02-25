import 'package:moengage_flutter/moengage_flutter.dart';

class MoeService {
  static final MoeService _instance = MoeService._internal();

  factory MoeService() => _instance;

  MoeService._internal();

  final MoEngageFlutter _moe =
      MoEngageFlutter('XXXXXXX'); //replace with actual moengage app id

  /// Initialize SDK (call once after app loads)
  Future<void> init() async {
    try {
      _moe.initialise();
      _moe.identifyUser('guest_${DateTime.now().millisecondsSinceEpoch}');
    } catch (e) {
      print('MoE init error: $e');
    }
  }

  /// Login user
  Future<void> setUser({
    required String id,
    String? name,
    String? email,
    String? phone,
  }) async {
    if (name != null) _moe.setFirstName(name);
    if (email != null) _moe.setEmail(email);
    if (phone != null) _moe.setPhoneNumber(phone);
  }

  /// Generic event trigger
  Future<void> track(String event, {Map<String, dynamic>? props}) async {
    final attr = MoEProperties();

    props?.forEach((key, value) {
      attr.addAttribute(key, value);
    });

    _moe.trackEvent(event, attr);
  }

  /// Logout
  Future<void> logout() async {
    _moe.logout();
  }
}
