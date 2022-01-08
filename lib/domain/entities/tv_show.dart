import 'episode.dart';

class TvShow{
  final int id;
  final String name;
  final String posterUrl;
  final DateTime? airs;
  final DateTime? premiered;
  final DateTime? ended;
  final List<String> genres;
  final String summary;
  final List<Episode> episodes;
  final double? rating;
  final int? weight;

  TvShow({
    required this.id,
    required this.name,
    required this.posterUrl,
    this.airs,
    this.premiered,
    this.ended,
    required this.genres,
    required this.summary,
    required this.episodes,
    required this.rating,
    required this.weight
  });

  factory TvShow.fromJson(Map<String, dynamic> json){
    return TvShow(
      id: json['id'],
      name: json['name'],
      posterUrl: json['image']?['original'] ?? '',
      airs: json['airstamp'] != null ? DateTime.parse(json['airstamp']) : null,
      premiered: json['premiered'] != null ? DateTime.parse(json['premiered']) : null,
      ended: json['ended'] != null ? DateTime.parse(json['ended']) : null,
      genres: json['genres'] != null
          ? (json['genres'] as List<dynamic>)
            .map<String>((genres) => genres.toString())
            .toList()
          : [],
      summary: json['summary'] ?? '',
      episodes: json['episodes'] != null
          ? (json['episodes'] as List<Map<String, dynamic>>)
            .map<Episode>((episodeJson) => Episode.fromJson(episodeJson))
            .toList()
          : [],
      rating: json['rating']?['average'] != null
        ? (json['rating']?['average'] is int)
          ? (json['rating']?['average'] as int).toDouble()
          : json['rating']['average']
        : null,
      weight: json['weight']
    );
  }

  @override
  String toString() {
    return "TvShow: $name";
  }

  @override
  bool operator ==(Object other) {
    other as TvShow;
    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  TvShow copy(){
    return TvShow(
        id: id,
        name: name,
        posterUrl: posterUrl,
        genres: genres,
        summary: summary,
        episodes: List.from(episodes),
        rating: rating,
        weight: weight
    );
  }
}