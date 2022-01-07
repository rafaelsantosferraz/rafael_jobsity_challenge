class Episode {

  final String name;
  final int number;
  final int season;
  final String summary;
  final String? imageUrl;

  Episode({
    required this.name,
    required this.number,
    required this.season,
    required this.summary,
    this.imageUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json){
    return Episode(
        name: json['name'],
        number: json['number'],
        season: json['season'],
        summary: json['summary'],
        imageUrl: json['imageUrl']
    );
  }
}