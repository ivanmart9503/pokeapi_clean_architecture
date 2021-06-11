import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tPokemonModel = PokemonModel(
    name: 'Bulbasaur',
    types: ['grass', 'poison'],
    spriteUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
  );
  final tPokemonTypes = ['grass', 'poison'];
  final tPokemonSpriteUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg';

  test(
    'should be a subclass of [Pokemon] entity',
    () async {
      // Assert
      expect(tPokemonModel, isA<Pokemon>());
    },
  );

  test(
    '''should return a valid [List<String>] containing 
    the pokemon's types from JSON''',
    () async {
      // Arrange
      final Map<String, dynamic> json = jsonDecode(fixture('pokemon.json'));

      // Act
      final result = getTypesFromJson(json);

      // Assert
      expect(result, equals(tPokemonTypes));
    },
  );

  test(
    '''should return a valid [String] containing 
    the pokemon's sprite url from JSON''',
    () async {
      // Arrange
      final Map<String, dynamic> json = jsonDecode(fixture('pokemon.json'));

      // Act
      final result = getSpriteUrlFromJson(json);

      // Assert
      expect(result, equals(tPokemonSpriteUrl));
    },
  );

  test(
    'should return a valid [PokemonModel] from JSON',
    () async {
      // Arrange
      final Map<String, dynamic> json = jsonDecode(fixture('pokemon.json'));

      // Act
      final result = PokemonModel.fromJson(json);

      // Assert
      expect(result, equals(tPokemonModel));
    },
  );

  test(
    'should return a JSON map containing the proper data',
    () async {
      // Act
      final result = tPokemonModel.toJson();

      // Assert
      final Map<String, dynamic> expectedJsonMap = {
        "name": "Bulbasaur",
        "types": [
          {
            "type": {"name": "grass"}
          },
          {
            "type": {"name": "poison"}
          }
        ],
        "sprites": {
          "other": {
            "dream_world": {
              "front_default":
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"
            }
          }
        }
      };
      expect(result, equals(expectedJsonMap));
    },
  );
}
