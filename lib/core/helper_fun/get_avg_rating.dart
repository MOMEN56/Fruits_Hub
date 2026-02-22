num getAvgRating(List<dynamic>? reviews) {
  // ? nullable, dynamic
  if (reviews == null || reviews.isEmpty) return 0;
  var sum = 0.0;
  for (var review in reviews) {
    sum += (review['ratting'] as num? ?? 0); // safe ?? 0
  }
  return sum / reviews.length;
}
