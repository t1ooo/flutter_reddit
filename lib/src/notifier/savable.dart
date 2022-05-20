abstract class Savable {
  Future<void> save() async {
    if (saved) {
      return;
    }
    return _updateSave(true);
  }

  Future<void> unsave() async {
    if (!saved) {
      return;
    }
    return _updateSave(false);
  }

  Future<void> _updateSave(bool saved);

  bool get saved;
}
