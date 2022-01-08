class Episode {

  final int id;
  final String name;
  final int number;
  final int season;
  final String? imageUrl;
  final DateTime? airs;
  final String summary;

  Episode({
    required this.id,
    required this.name,
    required this.number,
    required this.season,
    this.imageUrl,
    this.airs,
    required this.summary
  });

  factory Episode.fromJson(Map<String, dynamic> json){
    return Episode(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image']?['medium'] ?? '',
        number: json['number'],
        season: json['season'],
        airs: json['airstamp'] != null ? DateTime.parse(json['airstamp']) : null,
        summary: json['summary'] ?? ''
    );
  }
}