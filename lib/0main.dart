import 'package:flutter/material.dart' show BuildContext, MaterialApp, StatelessWidget, Widget, runApp;
import '1home_widget.dart';

void main() {
  runApp(pokedex());
}

class pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de modo de debug
      title: 'Poquedex',
      home: HomeWidget(),
    );
  }
}

