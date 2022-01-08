import 'episode.dart';

class TvShow{
  final int id;
  final String name;
  final String posterUrl;
  final DateTime airs;
  final List<String> genres;
  final String summary;
  final List<Episode> episodes;

  TvShow({
    required this.id,
    required this.name,
    required this.posterUrl,
    required this.airs,
    required this.genres,
    required this.summary,
    required this.episodes
  });

  factory TvShow.fromJson(Map<String, dynamic> json){
    return TvShow(
        id: json['id'],
        name: json['name'],
        posterUrl: json['image']?['original'] ?? '',
        airs: DateTime.parse(json['airstamp']),
        genres: json['genres'] ?? [],
        summary: json['summary'] ?? '',
        episodes: json['episodes'] != null
            ? (json['episodes'] as List<Map<String, dynamic>>)
              .map<Episode>((episodeJson) => Episode.fromJson(episodeJson))
              .toList()
            : []
    );
  }

  @override
  String toString() {
    return "Series: $name";
  }

  @override
  bool operator ==(Object other) {
    other as TvShow;
    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}