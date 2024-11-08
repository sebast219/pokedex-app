import 'package:flutter/material.dart';
import 'contenido1.dart';
import 'contenido2.dart';
import 'services/pokemon_service.dart'; 
import 'models/pokemon_model.dart';
class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fondo transparente para la AppBar
        elevation: 0, // Sin sombra en la AppBar
        toolbarHeight: 50, // Altura personalizada para la AppBar
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view, color: const Color.fromARGB(137, 0, 0, 0)), // Icono para vista de cuadrícula
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NuevaPantalla()),
            );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(),
                  ContentWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  Pokemon? _pokemon; // creo esta variable para guardar el pokemon buscado 

  // Función para buscar el Pokémon
  void _searchPokemon(String query) async {
    final pokemon = await PokemonService().fetchPokemon(query); // aqui llamo el servicio  para buscar el pokemon de la api 

    setState(() {
      _pokemon = pokemon; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(    
            'Pokédex',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Una Pokédex es una enciclopedia electrónica que contiene información sobre todos los Pokémon.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(242, 242, 242, 242),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color.fromARGB(137, 0, 0, 0)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '¿Qué Pokémon estás buscando?',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (query) {
                      _searchPokemon(query); // esto llama la funcion de buscar
                    },
                  ),
                ),
              ],
            ),
          ),
          //aqui se muestra el pokemon buscado
          if (_pokemon != null)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  _pokemon!.imageUrl,
                  height: 100,
                  width: 100,
                ),
                Text(
                  _pokemon!.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Height: ${_pokemon!.height}"),
                Text("Weight: ${_pokemon!.weight}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}


