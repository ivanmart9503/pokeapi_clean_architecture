import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_local_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  PokeapiLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = PokeapiLocalDataSourceImpl(mockSharedPreferences);
  });

  final tKey = 'pokemon';

  group('getLastPokemon', () {
    final tPokemonModel = PokemonModel.fromJson(
      jsonDecode(fixture('cached_pokemon.json')),
    );

    test(
      'should return [PokemonModel] from [SharedPreferences] when there is one in the cache',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('cached_pokemon.json'));

        // Act
        final result = await dataSource.getLastPokemon();

        // Assert
        verify(mockSharedPreferences.getString(tKey));
        expect(result, equals(tPokemonModel));
      },
    );

    test(
      'should throw CacheException when there is not a cached value',
      () async {
        // Arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // Act
        final call = dataSource.getLastPokemon;

        // Assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cachePokemon', () {
    final tPokemonModel = PokemonModel(
      name: 'Bulbasaur',
      types: ['grass', 'poison'],
      spriteUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
    );

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // Arrange

        // Act
        dataSource.cachePokemon(tPokemonModel);

        // Assert
        final expectedJsonString = jsonEncode(tPokemonModel.toJson());
        verify(mockSharedPreferences.setString(
          'pokemon',
          expectedJsonString,
        ));
      },
    );
  });
}
