class RatingModel {
  int rating;
  String comment;

  RatingModel({
    this.rating = 0,
    this.comment = '',
  });

  RatingModel copyWith({
    int? rating,
    String? comment,
  }) {
    return RatingModel(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }
}
