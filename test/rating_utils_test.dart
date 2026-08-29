import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/farmer/fertilizer_search/rating_utils.dart';

void main() {
  group('calculateStoreRatingUpdate', () {
    test('adds a first rating and computes the average', () {
      final result = calculateStoreRatingUpdate(
        currentRating: 0,
        currentReviews: 0,
        currentRatingSum: 0,
        newRating: 4,
      );

      expect(result.totalReviews, 1);
      expect(result.ratingSum, 4);
      expect(result.rating, 4);
    });

    test('updates an existing user rating without double counting', () {
      final result = calculateStoreRatingUpdate(
        currentRating: 4,
        currentReviews: 2,
        currentRatingSum: 8,
        newRating: 5,
        previousUserRating: 3,
      );

      expect(result.totalReviews, 2);
      expect(result.ratingSum, 10);
      expect(result.rating, 5);
    });

    test('falls back to rating * reviews when sum is missing', () {
      final result = calculateStoreRatingUpdate(
        currentRating: 4,
        currentReviews: 2,
        currentRatingSum: 0,
        newRating: 2,
      );

      expect(result.totalReviews, 3);
      expect(result.ratingSum, 10);
      expect(result.rating, closeTo(3.3333, 0.0001));
    });
  });
}

