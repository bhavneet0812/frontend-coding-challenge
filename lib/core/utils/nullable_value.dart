class NullableValue<T> {
  final T? value;

  const NullableValue(this.value);

  bool get isNull => value == null;

  bool get isNotNull => value != null;

  T? getOrNull() => value;

  T getOrDefault(T defaultValue) => value ?? defaultValue;

  @override
  String toString() => 'NullableValue(value: $value)';
}
