import 'dart:developer';

import 'package:custom_deck/buttons/button.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late _LoadState _loadState;
  late Map<int, Map<int, Button>> _buttons;
  final ButtonRepository _buttonRepository = ButtonRepository.getInstance();

  @override
  void initState() {
    _loadState = _LoadState.before;
    _buttonRepository
        .getButtons()
        .then((value) => setState(() {
              _buttons = value;
              _loadState = _LoadState.successful;
            }))
        .onError((error, stackTrace) => setState(() {
              _loadState = _LoadState.failure;
              log('error : $error');
              debugPrintStack(stackTrace: stackTrace);
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loadState) {
      case _LoadState.successful:
        return _ButtonGridView(_buttons);
      case _LoadState.before:
        return const Center(child: CircularProgressIndicator());
      case _LoadState.failure:
        return const Center(
          child: Text(
              'Load Failed. Check Settings are correct. And Press Refresh.'),
        );
    }
  }
}

enum _LoadState { before, failure, successful }

class _ButtonGridView extends StatelessWidget {
  const _ButtonGridView(this._buttons);

  final Map<int, Map<int, Button>> _buttons;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: getItems(),
    );
  }

  List<_GridButtonItem> getItems() {
    List<_GridButtonItem> list = [];

    for (var i = 0; i < 2; i++) {
      Map<int, Button>? xAxisButtons = _buttons[i];
      for (var j = 0; j < 8; j++) {
        if (xAxisButtons == null) {
          list.add(_GridButtonItem.empty);
        } else {
          Button? button = xAxisButtons[j];
          if (button == null) {
            list.add(_GridButtonItem.empty);
          } else {
            list.add(_GridButtonItem(button));
          }
        }
      }
    }

    return list;
  }
}

class _GridButtonItem extends StatelessWidget {
  const _GridButtonItem._(this.id);

  static _GridButtonItem empty = const _GridButtonItem._(-1);

  final int id;

  _GridButtonItem(Button button) : id = button.id;

  @override
  Widget build(BuildContext context) {
    if (this == empty) {
      return const GridTile(child: Text('none'));
    }

    return TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered))
                return Colors.blue.withOpacity(0.04);
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.blue.withOpacity(0.12);
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: () {},
        child: Text('id $id'));
  }
}
