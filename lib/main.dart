// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'setting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomDeck',
      home: Scaffold(
        appBar: AppBar(
          title: Text('CustomDeck'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
            ),
            PopupMenuButton<TextButton>(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(_createSettingRoute());
                          },
                          child: Text('설정'))),
                ];
              },
            )
          ],
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }

  Route _createSettingRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            fillColor: Colors.transparent,
            transitionType: SharedAxisTransitionType.scaled,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        });
  }
}
