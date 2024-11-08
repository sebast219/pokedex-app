import 'pokemon_model.dart';

class PokemonGeneration {
  final String title;
  final String description;
  final String imageUrl;
  final List<Pokemon> pokemonList;

  PokemonGeneration({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pokemonList,
  });

  factory PokemonGeneration.fromJson(Map<String, dynamic> json) {
    return PokemonGeneration(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      pokemonList: (json['pokemonList'] as List<dynamic>)
          .map((pokemonData) => Pokemon.fromJson(pokemonData))
          .toList(),
    );
  }
}
