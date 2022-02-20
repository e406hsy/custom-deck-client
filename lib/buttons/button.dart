class Button {
  Button(this._id);

  final int _id;

  int get id => _id;
}

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
    await Future.delayed(const Duration(seconds: 15));

    return {
      0: {0: Button(1), 1: Button(2)},
      1: {0: Button(3), 1: Button(4)},
      2: {0: Button(5)}
    };
  }
}
