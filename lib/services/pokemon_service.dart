// pokemon_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  final String baseUrl = "https://pokeapi.co/api/v2/pokemon";

  Future<Pokemon?> fetchPokemon(String query) async {
    final url = Uri.parse('$baseUrl/$query');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Pokemon.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
