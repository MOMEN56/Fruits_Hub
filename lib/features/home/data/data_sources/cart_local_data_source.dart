import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';

class CartLocalDataSource {
  Future<String> readRaw() async {
    return Prefs.getString(kCartData);
  }

  Future<void> writeRaw(String raw) async {
    await Prefs.setString(kCartData, raw);
  }

  Future<void> clear() async {
    await Prefs.setString(kCartData, '');
  }
}
