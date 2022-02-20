import 'dart:io';

class Button {}

class ButtonRepositoryImpl extends ButtonRepository {
  @override
  Future<Map<int, Map<int, Button>>> getButtons() {
    // TODO: implement getButtons
    throw UnimplementedError();
  }
}

abstract class ButtonRepository {
  static ButtonRepository instance = MockButtonRepository();

  static ButtonRepository getInstance() => instance;

  Future<Map<int, Map<int, Button>>> getButtons();
}

class MockButtonRepository extends ButtonRepository {
  @override
  Future<Map<int, Map<int, Button>>> getButtons() async {
    await Future.delayed(Duration(seconds: 50));


    return {
      1: {1: Button(), 2: Button()},
      2: {1: Button()}
    };
  }
}
