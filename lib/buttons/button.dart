class Button {
  Button(this._id);

  final int _id;

  int get id => _id;
}

class CustomDeckPage {
  CustomDeckPage(this.xCount, this.yCount, Map<int, Map<int, Button>> buttons)
      : buttons = Map.unmodifiable(buttons);
  final int xCount;
  final int yCount;
  final Map<int, Map<int, Button>> buttons;

  int get size => xCount * yCount;
}

class ButtonRepositoryImpl extends ButtonRepository {
  @override
  Future<CustomDeckPage> getPage() {
    // TODO: implement getButtons
    throw UnimplementedError();
  }
}

abstract class ButtonRepository {
  static ButtonRepository instance = MockButtonRepository();

  static ButtonRepository getInstance() => instance;

  Future<CustomDeckPage> getPage();
}

class MockButtonRepository extends ButtonRepository {
  @override
  Future<CustomDeckPage> getPage() async {
    await Future.delayed(const Duration(seconds: 15));

    return CustomDeckPage(4, 2, {
      0: {0: Button(1), 1: Button(2)},
      1: {0: Button(3), 1: Button(4)},
      2: {0: Button(5)}
    });
  }
}
