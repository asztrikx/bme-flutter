import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokeManager {
  final _shared = GetIt.I<SharedPreferences>();
  static const key = "TOKEN";

  String? get token {
    return _shared.getString(key) ?? null;
  }

  bool hasToken() {
    return _shared.containsKey(key);
  }

  setToken(String? token) async {
    if (token == null) {
      await _shared.remove(key);
    } else {
      await _shared.setString(key, token);
    }
  }
}
