// models/pokemon_model.dart
class Pokemon {
  final String name;
  final String imageUrl;
  final double height;
  final double weight;
  final int attack;
  final int defense;
  final int speed;
  final String description;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.description,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      speed: json['stats'][5]['base_stat'],
      description: json['description'] ?? 'Descripcion no disponible', 
    );
  }
}
