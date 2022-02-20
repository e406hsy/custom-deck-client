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
  ButtonRepository _buttonRepository = ButtonRepository.getInstance();

  @override
  void initState() {
    _loadState = _LoadState.before;
    _buttonRepository.getButtons().then((value) => setState(() {
          _buttons = value;
          _loadState = _LoadState.successful;
        })).onError((error, stackTrace) => setState(() {
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
        return _buttonGridView(_buttons);
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

class _buttonGridView extends StatelessWidget {
  _buttonGridView(this._buttons);

  Map<int, Map<int, Button>> _buttons;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Loaded'),
    );
  }
}
