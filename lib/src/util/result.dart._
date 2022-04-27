import 'package:equatable/equatable.dart';

class Result<V, E> extends Equatable {
  const Result(this.value, this.error);

  factory Result.empty() => Result(null, null);
  factory Result.value(V value) => Result(value, null);
  factory Result.error(E error) => Result(null, error);

  final V? value;
  final E? error;

  void onValue(Function(V) fn) {
    if (value != null) {
      fn(value!);
    }
  }

  void onError(Function(E) fn) {
    if (error != null) {
      fn(error!);
    }
  }

  @override
  List<Object?> get props => [
        value,
        error,
      ];
}
