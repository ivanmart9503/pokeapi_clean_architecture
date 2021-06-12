import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';

class PokemonInfoDisplay extends StatelessWidget {
  final Pokemon pokemon;
  final Map<String, Color> typesColors = {
    'normal': Colors.grey.shade200,
    'fire': Colors.deepOrange.shade200,
    'water': Colors.blue.shade200,
    'grass': Colors.green.shade200,
    'electric': Colors.yellow.shade200,
    'ice': Colors.lightBlue.shade200,
    'fighting': Colors.red.shade200,
    'poison': Colors.purple.shade200,
    'ground': Colors.amber.shade200,
    'flying': Colors.purple.shade200,
    'psychic': Colors.pink.shade200,
    'bug': Colors.lime.shade200,
    'rock': Colors.amber.shade200,
    'ghost': Colors.deepPurple.shade200,
    'dark': Colors.brown.shade200,
    'dragon': Colors.deepPurple.shade200,
    'steel': Colors.grey.shade200,
    'fairy': Colors.pink.shade200,
  };

  PokemonInfoDisplay(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPokemonSprite(context),
        _buildPokemonNameAndNumber(),
        _buildPokemonTypes(),
      ],
    );
  }

  Widget _buildPokemonSprite(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      child: pokemon.spriteUrl != null
          ? SvgPicture.network(
              pokemon.spriteUrl,
              alignment: Alignment.center,
              fit: BoxFit.contain,
            )
          : Center(
              child: Text(
                'Error while loading the illustration',
              ),
            ),
    );
  }

  Widget _buildPokemonNameAndNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${pokemon.name.toUpperCase()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Nº ${pokemon.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPokemonTypes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pokemon.types
            .map((type) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Chip(
                    label: Text(
                      type.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: typesColors[type],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
