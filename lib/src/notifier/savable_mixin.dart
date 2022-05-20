mixin SavableMixin {
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

  bool get saved;

  Future<void> _updateSave(bool saved);
}
