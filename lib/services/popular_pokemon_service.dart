import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PopularPokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon";

  Future<List<Pokemon>> fetchPopularPokemons() async {
    final url = Uri.parse('$baseUrl?limit=10'); 
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Pokemon> pokemons = [];

        for (int i = 2; i < data['results'].length; i++) {
          if (i % 3 != 0) {
            final pokemon = data['results'][i];
            
            final detailsResponse = await http.get(Uri.parse(pokemon['url']));
            if (detailsResponse.statusCode == 200) {
              final details = jsonDecode(detailsResponse.body);
              
              final speciesResponse = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon-species/${details['id']}"));
              String description = '';
              if (speciesResponse.statusCode == 200) {
                final speciesData = jsonDecode(speciesResponse.body);
                final flavorTexts = speciesData['flavor_text_entries'];
                final englishFlavorText = flavorTexts.firstWhere(
                  (entry) => entry['language']['name'] == 'es',
                  orElse: () => null,
                );
                description = englishFlavorText != null ? englishFlavorText['flavor_text'] : 'No description available';
              }

              // Creamos una instancia de Pokemon con todos los detalles
              pokemons.add(Pokemon(
                name: pokemon['name'],
                imageUrl: details['sprites']['front_default'],
                height: details['height'].toDouble(),
                weight: details['weight'].toDouble(),
                attack: details['stats'][1]['base_stat'],
                defense: details['stats'][2]['base_stat'],
                speed: details['stats'][5]['base_stat'],
                description: description,
              ));
            }
          }
        }
        return pokemons;
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
