import 'package:flutter/material.dart';
import 'services/pokemon_service_generaciones.dart';
import 'models/pokemon_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NuevaPantalla(),
    );
  }
}

class NuevaPantalla extends StatelessWidget {
  const NuevaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
        title: const Text(
          'Pokédex',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generaciones',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Aquí encontrarás todas las generaciones de Pokémon',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: generations.length,
                      itemBuilder: (context, index) {
                        final generation = generations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PokemonListScreen(
                                  generationTitle: generation['title'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    generation['image'],
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  generation['title'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PokemonListScreen extends StatelessWidget {
  final String generationTitle;
  final PokemonService _pokemonService = PokemonService();

  PokemonListScreen({Key? key, required this.generationTitle}) : super(key: key);

  Future<List<Pokemon>> getPokemonListForGeneration() async {
    int generationNumber;

    switch (generationTitle) {
      case 'Generacion I': generationNumber = 1; break;
      case 'Generacion II': generationNumber = 2; break;
      case 'Generacion III': generationNumber = 3; break;
      case 'Generacion IV': generationNumber = 4; break;
      case 'Generacion V': generationNumber = 5; break;
      case 'Generacion VI': generationNumber = 6; break;
      case 'Generacion VII': generationNumber = 7; break;
      case 'Generacion VIII': generationNumber = 8; break;
      case 'Generacion IX': generationNumber = 9; break;
      default: return [];
    }

    try {
      return await _pokemonService.fetchPokemonByGeneration(generationNumber);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(generationTitle),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder<List<Pokemon>>(
        future: getPokemonListForGeneration(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los Pokémon'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay Pokémon para esta generación'));
          } else {
            final pokemonList = snapshot.data!;
            return ListView.builder(
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      pokemon.imageUrl,
                      height: 50,
                      width: 50,
                    ),
                    title: Text(pokemon.name),
                    subtitle: Text(
                      'Altura: ${pokemon.height} | Peso: ${pokemon.weight}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                pokemon.imageUrl,
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pokemon.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              pokemon.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text('Altura: ${pokemon.height}', style: const TextStyle(fontSize: 16)),
            Text('Peso: ${pokemon.weight}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Estadísticas:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Ataque: ${pokemon.attack}', style: const TextStyle(fontSize: 16)),
            Text('Defensa: ${pokemon.defense}', style: const TextStyle(fontSize: 16)),
            Text('Velocidad: ${pokemon.speed}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> generations = [
  {
    'title': 'Generacion I',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/c/cc/latest/20220221171901/Ilustraci%C3%B3n_de_Kanto_D%C3%ADa_de_Pok%C3%A9mon_2022.png/185px-Ilustraci%C3%B3n_de_Kanto_D%C3%ADa_de_Pok%C3%A9mon_2022.png',
  },
  {
    'title': 'Generacion II',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/6/62/latest/20220221173052/Artwork_aventura_en_Johto.png/185px-Artwork_aventura_en_Johto.png',
  },
  {
    'title': 'Generacion III',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/6/65/latest/20220222061534/Artwork_aventura_en_Hoenn.png/185px-Artwork_aventura_en_Hoenn.png',
  },
  {
    'title': 'Generacion IV',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/7/7a/latest/20220223024354/Artwork_aventura_en_Sinnoh.png/185px-Artwork_aventura_en_Sinnoh.png',
  },
  {
   
    'title': 'Generacion V',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/3/3e/latest/20220224072037/Artwork_aventura_en_Teselia.png/185px-Artwork_aventura_en_Teselia.png',
  },  {
   
    'title': 'Generacion VI',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/f/f9/latest/20220225052745/Artwork_aventura_en_Kalos.png/185px-Artwork_aventura_en_Kalos.png',
  },  {
   
    'title': 'Generacion VII',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/7/71/latest/20220226024848/Artwork_aventura_en_Alola.png/185px-Artwork_aventura_en_Alola.png',
  },  {
   
    'title': 'Generacion VIII',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/8/86/latest/20220227023222/Artwork_aventura_en_Galar.png/185px-Artwork_aventura_en_Galar.png',
  },  {
   
    'title': 'Generacion IX',
    'image': 'https://images.wikidexcdn.net/mwuploads/wikidex/thumb/8/86/latest/20230531122933/Artwork_conexi%C3%B3n_EP_y_HOME.png/185px-Artwork_conexi%C3%B3n_EP_y_HOME.png',
  },
];
