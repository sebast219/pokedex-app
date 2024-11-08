import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  Future<List<Pokemon>> fetchPokemonByGeneration(int generation) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/generation/$generation');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<Pokemon> pokemonList = [];

      for (var species in data['pokemon_species']) {
        final pokemonUrl = species['url'];
        final pokemonId = int.parse(pokemonUrl.split('/')[6]);

        final pokemonDetails = await fetchPokemonDetails(pokemonId);

        if (pokemonDetails != null) {
          pokemonList.add(pokemonDetails);
        }
      }
      return pokemonList;
    } else {
      throw Exception('Error al cargar Pokémon');
    }
  }
  Future<Pokemon?> fetchPokemonDetails(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pokemon.fromJson(data);
    } else {
      print('Error al cargar detalles del Pokémon $id');
      return null;
    }
  }
}
