import '../reddit_api/like.dart';

abstract class Likable {
  Future<void> like() {
    if (likes == Like.up) {
      return updateLike_(Like.none);
    }
    return updateLike_(Like.up);
  }

  Future<void> dislike() {
    if (likes == Like.down) {
      return updateLike_(Like.none);
    }
    return updateLike_(Like.down);
  }

  Like get likes;
  int get score;
  Future<void> updateLike_(Like like);
}
