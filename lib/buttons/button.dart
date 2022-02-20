class Button {
  Button(this._id);

  final int _id;

  int get id => _id;
}

class Page {
  Page(this.xCount, this.yCount, Map<int, Map<int, Button>> buttons)
      : buttons = Map.unmodifiable(buttons);
  final int xCount;
  final int yCount;
  final Map<int, Map<int, Button>> buttons;
}

class ButtonRepositoryImpl extends ButtonRepository {
  @override
  Future<Page> getPage() {
    // TODO: implement getButtons
    throw UnimplementedError();
  }
}

abstract class ButtonRepository {
  static ButtonRepository instance = MockButtonRepository();

  static ButtonRepository getInstance() => instance;

  Future<Page> getPage();
}

class MockButtonRepository extends ButtonRepository {
  @override
  Future<Page> getPage() async {
    await Future.delayed(const Duration(seconds: 15));

    return Page(4, 2, {
      0: {0: Button(1), 1: Button(2)},
      1: {0: Button(3), 1: Button(4)},
      2: {0: Button(5)}
    });
  }
}
