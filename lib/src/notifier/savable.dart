abstract class Savable {
  bool get saved;
  Future<void> save(bool save);
}
