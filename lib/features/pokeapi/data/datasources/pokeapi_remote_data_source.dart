import 'dart:convert';
import 'dart:math';

import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

abstract class PokeapiRemoteDataSource {
  /// Calls the https://pokeapi.co/api/v2/pokemon/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<PokemonModel> getPokemon(int number);
}

class PokeapiRemoteDataSourceImpl implements PokeapiRemoteDataSource {
  final http.Client client;

  PokeapiRemoteDataSourceImpl(this.client);

  @override
  Future<PokemonModel> getPokemon(int number) async {
    final result = await client.get(
      'https://pokeapi.co/api/v2/pokemon/$number',
    );

    if (result.statusCode == 200) {
      return PokemonModel.fromJson(jsonDecode(result.body));
    } else {
      throw ServerException();
    }
  }
}
