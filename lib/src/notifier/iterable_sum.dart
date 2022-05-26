extension IterableSum<T extends num> on Iterable<T> {
  T sum() {
    return this.isEmpty ? (0 as T) : this.reduce((r, v) => r + v as T);
  }
}
