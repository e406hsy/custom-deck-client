// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:developer';

import 'package:custom_deck/buttons/button.dart';
import 'package:custom_deck/framework/application_context.dart';
import 'package:custom_deck/main_app_bar.dart';
import 'package:custom_deck/main_page.dart';
import 'package:custom_deck/setting/setting_service.dart';
import 'package:flutter/material.dart';

void main() {

  initialize();

  runApp(CustomDeckApplication());
}

void initialize() {
  ApplicationContext.mapObject(ButtonRepository, MockButtonRepository());
  ApplicationContext.map(SettingService, () => SettingService());
}

class CustomDeckApplication extends StatelessWidget {
  final GlobalKey<MainPageState> _key = GlobalKey();

  CustomDeckApplication({Key? key}) : super(key: key);

  void refresh() {
    log('debug: called main.dart refresh');
    _key.currentState!.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomDeck',
      home: Scaffold(
        appBar: MainAppBar(
          onRefresh: refresh,
        ),
        body: MainPage(
          key: _key,
        ),
      ),
    );
  }
}
