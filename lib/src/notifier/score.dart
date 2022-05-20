import '../reddit_api/like.dart';

int calcScore(int score, Like oldLike, Like newLike) {
  if (oldLike == Like.up) {
    if (newLike == Like.down) {
      return score - 2;
    } else if (newLike == Like.none) {
      return score - 1;
    }
  } else if (oldLike == Like.none) {
    if (newLike == Like.down) {
      return score - 1;
    } else if (newLike == Like.up) {
      return score + 1;
    }
  } else if (oldLike == Like.down) {
    if (newLike == Like.up) {
      return score + 2;
    } else if (newLike == Like.none) {
      return score + 1;
    }
  }
  return score;
}
