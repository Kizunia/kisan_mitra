class StoreRatingUpdate {
  final double rating;
  final int totalReviews;
  final double ratingSum;

  const StoreRatingUpdate({
    required this.rating,
    required this.totalReviews,
    required this.ratingSum,
  });
}

StoreRatingUpdate calculateStoreRatingUpdate({
  required double currentRating,
  required int currentReviews,
  required double currentRatingSum,
  required double newRating,
  double? previousUserRating,
}) {
  final normalizedCurrentSum =
      currentRatingSum > 0 ? currentRatingSum : currentRating * currentReviews;

  final bool isUpdate = previousUserRating != null;
  final double updatedSum = isUpdate
      ? normalizedCurrentSum - previousUserRating + newRating
      : normalizedCurrentSum + newRating;

  final int updatedReviews = isUpdate
      ? (currentReviews > 0 ? currentReviews : 1)
      : currentReviews + 1;

  final double updatedRating = updatedReviews > 0 ? updatedSum / updatedReviews : 0.0;

  return StoreRatingUpdate(
    rating: updatedRating,
    totalReviews: updatedReviews,
    ratingSum: updatedSum,
  );
}

