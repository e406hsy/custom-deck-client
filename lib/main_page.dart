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
  late int xCount;
  late int yCount;

  @override
  void initState() {
    _loadState = _LoadState.before;
    _buttonRepository
        .getPage()
        .then((value) => setState(() {
              xCount = value.xCount;
              yCount = value.yCount;
              _buttons = value.buttons;
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
        return _ButtonGridView(xCount, yCount, _buttons);
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
  const _ButtonGridView(this.xCount, this.yCount, this._buttons);

  final int xCount;
  final int yCount;
  final Map<int, Map<int, Button>> _buttons;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: xCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.4) /
            xCount *
            yCount,
      ),
      padding: const EdgeInsets.all(8),
      itemCount: xCount * yCount,
      itemBuilder: (context, index) => _getItem(index),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  _GridButtonItem _getItem(int index) {
    var xIndex = index ~/ xCount;
    var yIndex = index % xCount;

    Button? button = _buttons[xIndex]?[yIndex];

    return button != null ? _GridButtonItem(button) : _GridButtonItem.empty;
  }
}

class _GridButtonItem extends StatelessWidget {
  static _GridButtonItem empty = const _GridButtonItem._(-1);

  _GridButtonItem(Button button) : id = button.id;

  const _GridButtonItem._(this.id);

  final int id;

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
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed)) {
                return Colors.blue.withOpacity(0.12);
              }
              return null; // Defer to the widget's default.
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Colors.blue))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {},
        child: Text(
          'id $id',
          style: const TextStyle(color: Colors.black),
        ));
  }
}
