import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokeManager {
  final _shared = GetIt.I<SharedPreferences>();
  static const _key = "TOKEN";

  String? get token {
    return _shared.getString(_key);
  }

  bool hasToken() {
    return _shared.containsKey(_key);
  }

  Future<void> clear() async {
    //await _shared.remove(_key);
    await _shared.clear();
  }

  setToken(String token) async {
    await _shared.setString(_key, token);
  }
}
