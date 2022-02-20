// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:custom_deck/main_page.dart';
import 'package:flutter/material.dart';

import 'package:custom_deck/main_app_bar.dart';

void main() => runApp(const CustomDeckApplication());

class CustomDeckApplication extends StatelessWidget {
  const CustomDeckApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CustomDeck',
      home: Scaffold(
        appBar: MainAppBar(),
        body: MainPage(),
      ),
    );
  }
}
