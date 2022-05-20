import '../reddit_api/like.dart';

abstract class Likable {
  Future<void> like() async {
    if (likes == Like.up) {
      return updateLike_(Like.none);
    }
    return await updateLike_(Like.up);
  }

  Future<void> dislike() async {
    if (likes == Like.down) {
      return updateLike_(Like.none);
    }
    return await updateLike_(Like.down);
  }

  Like get likes;
  int get score;
  Future<void> updateLike_(Like like);
}
