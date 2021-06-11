import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_remote_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  PokeapiRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = PokeapiRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('pokemon.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcretePokemon', () {
    final tNumber = 1;
    final tPokemonModel = PokemonModel.fromJson(
      jsonDecode(fixture('pokemon.json')),
    );

    test(
      '''should perform a GET request to the proper URL''',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        dataSource.getPokemon(tNumber);

        // Assert
        verify(
          mockHttpClient.get('https://pokeapi.co/api/v2/pokemon/$tNumber'),
        );
      },
    );

    test(
      'should return a [PokemonModel] when the response code is 200 (success)',
      () async {
        // Arrange
        setUpMockHttpClientSuccess200();

        // Act
        final result = await dataSource.getPokemon(tNumber);

        // Assert
        verify(
          mockHttpClient.get('https://pokeapi.co/api/v2/pokemon/$tNumber'),
        );
        expect(result, equals(tPokemonModel));
      },
    );

    test(
      'should throw a [ServerException] when the response code is 404 or other',
      () async {
        // Arrange
        setUpMockHttpClientFailure404();

        // Act
        final call = dataSource.getPokemon;

        // Assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
