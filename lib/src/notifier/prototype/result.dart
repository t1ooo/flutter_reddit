typedef UndoFn = Future<Result?> Function();
typedef RetryFn = Future<Result?> Function();

class Result {}

class Ok extends Result {
  Ok(this.message, [this.undo]);
  String message;
  UndoFn? undo;
  String toString() => message;
}

class Error extends Result {
  Error(this.message, [this.retry]);
  String message;
  RetryFn? retry;
  String toString() => 'Error: $message';
}

class Reload extends Result {}
