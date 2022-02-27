import 'package:custom_deck/connection/http_service.dart';
import 'package:custom_deck/framework/application_context.dart';
import 'package:custom_deck/setting/setting_service.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'http_service_test.mocks.dart';


@GenerateMocks([SettingService])
void main() {
  late SettingService settingServiceMock = MockSettingService();
  ApplicationContext.mapObject(SettingService, settingServiceMock);

  HttpService httpService = HttpService();

  test('test1', () {
    when(settingServiceMock.getIp()).thenAnswer((realInvocation)async => 'www.google.com');
    httpService.callHttpGet('');
  });
}
