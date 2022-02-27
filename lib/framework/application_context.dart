class ApplicationContext {

  ApplicationContext._();

  static final Map<Type, Function> _FactoryMap = {};
  static final Map<Type, dynamic> _objectMap = {};

  static void map<T>(Type T, Function object) {
    _FactoryMap.putIfAbsent(T, () => object);
  }

  static void mapObject<T>(Type T, dynamic object) {
    _objectMap.putIfAbsent(T, () => object);
  }

  static T get<T>(Type type) {
    T? object = _objectMap[type];

    if (object == null) {
      object = _FactoryMap[type]?.call();

      _objectMap[type] = () => object;
    }

    return object!;
  }
}