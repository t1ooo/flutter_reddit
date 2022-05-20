extension IterableSum<T extends num> on Iterable<T> {
  T sum() {
    return this.reduce((r, v) => r + v as T);
  }
}
