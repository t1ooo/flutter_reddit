import '../reddit_api/like.dart';

abstract class Likable {
  Future<void> like() async {
    if (likes == Like.up) {
      return _updateLike(Like.none);
    }
    return await _updateLike(Like.up);
  }

  Future<void> dislike() async {
    if (likes == Like.down) {
      return _updateLike(Like.none);
    }
    return await _updateLike(Like.down);
  }

  Like get likes => throw UnimplementedError();
  int get score => throw UnimplementedError();
  Future<void> _updateLike(Like like) => throw UnimplementedError();
}
