import 'package:flutter/material.dart';
import 'services/popular_pokemon_service.dart';
import '../models/pokemon_model.dart';

class ContentWidget extends StatefulWidget {
  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  List<Pokemon> _popularPokemons = []; // Lista para almacenar Pokémon populares
  final PopularPokemonService _popularPokemonService = PopularPokemonService();

  @override
  void initState() {
    super.initState();
    _fetchPopularPokemons(); // Llama a la función para obtener Pokémon populares al iniciar
  }

  // Función para obtener Pokémon populares
  void _fetchPopularPokemons() async {
    final pokemons = await _popularPokemonService.fetchPopularPokemons();
    setState(() {
      _popularPokemons = pokemons; // Actualiza el estado con los Pokémon populares
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              'Top Populares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Lista de Pokémon populares
            Column(
              children: _popularPokemons.asMap().entries.map((entry) {
                int index = entry.key;
                var pokemon = entry.value;
                return Container(
                  width: 400,
                  height: 100,
                  child: Card(
                    color: cardColors[index % cardColors.length], // Asigna un color basado en el índice
                    margin: EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Text(pokemon.name),
                      leading: Image.network(
                        pokemon.imageUrl,
                        height: 50,
                        width: 50,
                      ),
                      subtitle: Text('Height: ${pokemon.height}, Weight: ${pokemon.weight}'),
                      onTap: () {
                        // Navegar a la pantalla de detalles al hacer clic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de detalles del Pokémon
class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.network(
                pokemon.imageUrl,
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${pokemon.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Height: ${pokemon.height}'),
            Text('Weight: ${pokemon.weight}'),
            SizedBox(height: 20),
            Text(
              'More Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(pokemon.description ?? 'No additional information available.'),
          ],
        ),
      ),
    );
  }
}

// Lista de colores de las cards
final List<Color> cardColors = [
  const Color.fromARGB(255, 40, 243, 33),
  Colors.red,
  Colors.orange,
  Colors.blue,
  Colors.purple,
];
