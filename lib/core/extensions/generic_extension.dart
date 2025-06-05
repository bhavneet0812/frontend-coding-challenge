import 'package:frontend_coding_challenge/core/utils/nullable_value.dart';

extension GenericExtension<T> on T? {
  /// Wraps the object in a NullableValue.
  NullableValue<T> get asNullable => NullableValue<T>(this);
}
