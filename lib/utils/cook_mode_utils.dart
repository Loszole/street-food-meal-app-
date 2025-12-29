import 'package:wakelock_plus/wakelock_plus.dart';

class CookModeUtils {
  static Future<void> setCookMode(bool enabled) async {
    if (enabled) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }
}