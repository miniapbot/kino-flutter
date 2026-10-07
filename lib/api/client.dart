import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

const String API_BASE = 'https://kino.lazerok.site';

class ApiClient {
  static Future<List<Movie>> getMovies() async {
    final res = await http.get(Uri.parse('$API_BASE/api/catalog'));
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки каталога: ${res.statusCode}');
    }
    final data = json.decode(res.body);
    final movies = (data['movies'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  static Future<List<Movie>> getSeries() async {
    final res = await http.get(Uri.parse('$API_BASE/api/catalog'));
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки каталога: ${res.statusCode}');
    }
    final data = json.decode(res.body);
    final series = (data['series'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return series;
  }

  static Future<Movie> getMovie(int kpId) async {
    final res = await http.get(Uri.parse('$API_BASE/api/movie/$kpId'));
    if (res.statusCode != 200) {
      throw Exception('Ошибка загрузки фильма: ${res.statusCode}');
    }
    return Movie.fromJson(json.decode(res.body));
  }

  static String getPlayerUrl(int kpId) {
    return '$API_BASE/player/$kpId';
  }
}