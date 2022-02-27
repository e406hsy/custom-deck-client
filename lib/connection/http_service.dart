import 'dart:convert';

import 'package:custom_deck/framework/application_context.dart';
import 'package:custom_deck/setting/setting_service.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final SettingService _settingService = ApplicationContext.get(SettingService);

  Future<Map<String, dynamic>> callHttpGet(String path) async {
    var url = Uri.http(await _settingService.getIp(), path);

    var response = await http.get(url);

    if (response.statusCode != 200) {
      // TODO: appropriate exception message
      throw Exception('http get failed');
    }

    return jsonDecode(response.body);
  }
}
