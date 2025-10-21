class RatingModel {
  final String id;
  final double rating;
  final String comment;

  RatingModel({
    required this.id,
    required this.rating,
    required this.comment,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json["id"],
      rating: json["rating"].toDouble(),
      comment: json["comment"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "rating": rating,
      "comment": comment,
    };
  }
}

