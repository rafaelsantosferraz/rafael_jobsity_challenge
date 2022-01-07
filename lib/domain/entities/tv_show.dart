import 'episode.dart';

class TvShow{
  final String name;
  final String posterUrl;
  final DateTime airs;
  final List<String> genres;
  final String summary;
  final List<Episode> episodes;

  TvShow({
    required this.name,
    required this.posterUrl,
    required this.airs,
    required this.genres,
    required this.summary,
    required this.episodes
  });

  factory TvShow.fromJson(Map<String, dynamic> json){
    return TvShow(
        name: json['name'],
        posterUrl: json['posterUrl'],
        airs: DateTime.fromMillisecondsSinceEpoch(json['airs']),
        genres: json['genres'],
        summary: json['summary'],
        episodes: (json['episodes'] as List<Map<String, dynamic>>)
            .map<Episode>((episodeJson) => Episode.fromJson(episodeJson))
            .toList()
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