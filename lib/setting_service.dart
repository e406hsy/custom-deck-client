
import 'package:shared_preferences/shared_preferences.dart';

const ipKey= 'custom_deck_server_ip';
const portKey= 'custom_deck_server_port';

class SettingData {
  SettingData(this.ip, this.port);

  String ip = '';
  int port = 0;
}

class SettingService {
  static SettingService instance = SettingService();

  static SettingService getInstance() => instance;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getIp() async {
    var value = (await _prefs).getString(ipKey);
    return value ?? '';
  }

  Future<int> getPort() async {
    var value = (await _prefs).getInt(portKey);
    return value ?? 24001;
  }

  void setIp(String ip) {
    _prefs.then((value) => value.setString(ipKey, ip));
  }

  void setPort(int port) {
    _prefs.then((value) => value.setInt(portKey, port));
  }

  Future<SettingData> getSettingData() async {
    return SettingData(await getIp(), await getPort());
  }
}