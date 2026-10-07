class Movie {
  final int id;
  final int? kpId;
  final String type;
  final String title;
  final int year;
  final double rating;
  final String poster;
  final String? description;

  Movie({
    required this.id,
    this.kpId,
    required this.type,
    required this.title,
    required this.year,
    required this.rating,
    required this.poster,
    this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      kpId: json['kpId'],
      type: json['type'] ?? 'movie',
      title: json['title'] ?? 'Без названия',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      poster: json['poster'] ?? '',
      description: json['description'],
    );
  }
}