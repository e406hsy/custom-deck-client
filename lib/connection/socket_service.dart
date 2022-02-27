import 'dart:developer';

import 'package:custom_deck/framework/application_context.dart';
import 'package:custom_deck/setting/setting_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

abstract class WebSocketService {
  WebSocketService._();

  static WebSocketService getInstance() => _MockWebSocketService();

  final List<VoidCallback> _listeners = [];

  bool isConnected();

  Future<bool> connect(String url);

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void requestAction(jsonString);
}

class _MockWebSocketService extends WebSocketService {
  _MockWebSocketService() : super._();

  @override
  Future<bool> connect(String url) async {
    await Future.delayed(const Duration(seconds: 4));
    return true;
  }

  @override
  bool isConnected() {
    // TODO: implement isConnected
    throw UnimplementedError();
  }

  @override
  void requestAction(jsonString) {
    // TODO: implement requestAction
  }
}

class WebSocketServiceImpl extends WebSocketService {

  WebSocketServiceImpl() : _settingService = ApplicationContext.get(SettingService), super._();

  IOWebSocketChannel? _channel;

  final SettingService _settingService;

  @override
  Future<bool> connect(String url) async {
    _channel = IOWebSocketChannel.connect(Uri.parse(
        'ws://${await _settingService.getIp()}:${await _settingService.getPort()}/endpoint'));
    return true;
  }

  @override
  bool isConnected() {
    if (_channel == null) {
      return true;
    }
    return _channel!.closeCode == null;
  }

  @override
  void requestAction(jsonString) {
    if (isConnected()) {
      _channel!.sink.add(jsonString);
    } else {
      // TODO: 연결안된 상태에서 버튼 클릭 안내 문구 노출
    }
  }
}

main() async {
  var channel =
      IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080/endpoint'));

  channel.sink.add('data');
  channel.sink.add('received!');

  await Future.delayed(const Duration(seconds: 3));
  channel.sink.close(status.goingAway);
}
