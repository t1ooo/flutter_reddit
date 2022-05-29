String formatMembers(int n) {
  if (n < 1000) {
    return n.toString();
  }
  return '${(n / 1000).floor()}k';
}
