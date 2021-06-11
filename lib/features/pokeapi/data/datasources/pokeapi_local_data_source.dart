import 'dart:convert';

import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PokeapiLocalDataSource {
  /// Get last pokemon cached when user had internet connection
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<PokemonModel> getLastPokemon();

  /// Cache [PokemonModel] with [SharedPreferences].
  Future<void> cachePokemon(PokemonModel pokemonModel);
}

class PokeapiLocalDataSourceImpl implements PokeapiLocalDataSource {
  final SharedPreferences prefs;

  PokeapiLocalDataSourceImpl(this.prefs);

  @override
  Future<PokemonModel> getLastPokemon() {
    final result = prefs.getString('pokemon');

    if (result != null) {
      return Future.value(PokemonModel.fromJson(jsonDecode(result)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePokemon(PokemonModel pokemonModel) async {
    return await prefs.setString('pokemon', jsonEncode(pokemonModel.toJson()));
  }
}
