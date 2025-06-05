import 'package:frontend_coding_challenge/core/utils/nullable_value.dart';

extension GenericExtension<T> on T? {
  /// Returns true if the object is null.
  bool get isNull => this == null;

  /// Returns true if the object is not null.
  bool get isNotNull => !isNull;

  /// Returns true if the object is a String and not empty.
  bool get isNotEmptyString => this is String && (this as String).isNotEmpty;

  /// Returns true if the object is a String and empty.
  bool get isEmptyString => this is String && (this as String).isEmpty;

  /// Wraps the object in a NullableValue.
  NullableValue<T> get asNullable => NullableValue<T>(this);
}
