// view_models/rating_view_model.dart
import 'package:flutter/material.dart';
import '../../models/feedback/feedback_model.dart';

class RatingViewModel with ChangeNotifier {
  RatingModel _ratingData = RatingModel();

  RatingModel get ratingData => _ratingData;

  void setRating(int rating) {
    _ratingData = _ratingData.copyWith(rating: rating);
    notifyListeners();
  }

  void setComment(String comment) {
    _ratingData = _ratingData.copyWith(comment: comment);
    notifyListeners();
  }

  Future<void> submitRating() async {
    // Here you would typically send the data to your backend
    // For now, we'll just print it
    print(
        'Submitting rating: ${_ratingData.rating}, comment: ${_ratingData.comment}');

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    // Clear the form after submission
    _ratingData = RatingModel();
    notifyListeners();
  }
}
