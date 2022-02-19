// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'main_app_bar.dart';
import 'package:flutter/material.dart';
import 'setting_page.dart';

void main() => runApp(const CustomDeckApplication());

class CustomDeckApplication extends StatelessWidget {
  const CustomDeckApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomDeck',
      home: Scaffold(
        appBar: MainAppBar(),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }

}
