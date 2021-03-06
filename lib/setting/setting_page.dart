import 'dart:developer';

import 'package:custom_deck/framework/application_context.dart';
import 'package:custom_deck/setting/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: _SettingFormField(),
    );
  }
}

class _SettingFormField extends StatefulWidget {
  const _SettingFormField({Key? key}) : super(key: key);

  @override
  _SettingFormFieldState createState() => _SettingFormFieldState();
}

class _SettingFormFieldState extends State<_SettingFormField>
    with RestorationMixin {
  final SettingService _settingService = ApplicationContext.get(SettingService);
  late Future<SettingData> setting;

  late FocusNode _ip, _port;

  @override
  void initState() {
    super.initState();
    setting = _settingService.getSettingData();
    _ip = FocusNode();
    _port = FocusNode();
  }

  @override
  void dispose() {
    _ip.dispose();
    _port.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  String get restorationId => 'setting_field';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
  }

  final RestorableInt _autoValidateModeIndex =
      RestorableInt(AutovalidateMode.disabled.index);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmitted() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      _autoValidateModeIndex.value = AutovalidateMode.always.index;

      showInSnackBar('잘못된 입력을 수정해주세요.');
    } else {
      form.save();
      _settingService.setIp((await setting).ip);
      _settingService.setPort((await setting).port);
      showInSnackBar('성공');
    }
  }

  String? _validateIp(String? value) {
    if (value == null || value.isEmpty) {
      return '필수 항목입니다.';
    }
    final ipExpression = RegExp(
        r'^(([0-9]{0,2}|[0-1][0-9]{2}|2[0-4][0-9]|25[0-5]).){3}([0-9]{0,2}|[0-1][0-9]{2}|2[0-4][0-9]|25[0-5])$');
    if (!ipExpression.hasMatch(value)) {
      return '잘못된 형식입니다. ###.###.###.###';
    }
    return null;
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return '필수 항목입니다.';
    }
    final ipExpression = RegExp(r'^[0-9]+$');
    if (!ipExpression.hasMatch(value)) {
      return '숫자만 사용 가능합니다.';
    }
    if (int.parse(value) < 0 || int.parse(value) > 65535) {
      return '잘못된 범위 입니다.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return FutureBuilder<SettingData>(
      future: setting,
      builder: (BuildContext context, AsyncSnapshot<SettingData> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              log('error: $snapshot ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else {
              return Form(
                key: _formKey,
                autovalidateMode:
                    AutovalidateMode.values[_autoValidateModeIndex.value],
                child: Scrollbar(
                  child: SingleChildScrollView(
                    restorationId: 'setting_field_scroll_view',
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        sizedBoxSpace,
                        TextFormField(
                          initialValue: snapshot.data?.ip,
                          restorationId: 'ip_field',
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: '192.168.0.1',
                              labelText: 'IP'),
                          onSaved: (value) {
                            setting
                                .then((_setting) => _setting.ip = value ?? '');
                            _port.requestFocus();
                          },
                          validator: _validateIp,
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          initialValue: snapshot.data?.port.toString(),
                          restorationId: 'port_field',
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: '24001',
                              labelText: 'port'),
                          onSaved: (value) {
                            setting.then((_setting) => _setting.port =
                                value != null ? int.parse(value) : 24001);
                            _port.requestFocus();
                          },
                          maxLength: 5,
                          maxLengthEnforcement:
                              MaxLengthEnforcement.truncateAfterCompositionEnds,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: _validatePort,
                        ),
                        sizedBoxSpace,
                        Center(
                          child: ElevatedButton(
                            onPressed: _handleSubmitted,
                            child: const Text('제출'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
