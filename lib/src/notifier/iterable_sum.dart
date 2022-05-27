extension IterableSum<T extends num> on Iterable<T> {
  T sum() {
    return isEmpty ? (0 as T) : reduce((r, v) => r + v as T);
  }
}
