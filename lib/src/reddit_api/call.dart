/// try to call nullable function and return result
T? tryCall<T>(T? Function()? fn) {
  return fn != null ? fn() : null;
}
