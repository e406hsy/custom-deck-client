import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'setting_page.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('CustomDeck'),
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
                      child: const Text('설정'))),
            ];
          },
        )
      ],
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
