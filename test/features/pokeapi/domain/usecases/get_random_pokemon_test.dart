import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_random_pokemon.dart';

class MockPokeapiRepository extends Mock implements PokeapiRepository {}

void main() {
  MockPokeapiRepository mockRepository;
  GetRandomPokemon usecase;

  setUp(() {
    mockRepository = MockPokeapiRepository();
    usecase = GetRandomPokemon(mockRepository);
  });

  final tPokemon = Pokemon(
    name: 'Bulbasaur',
    types: ['grass', 'poison'],
    spriteUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
  );

  test(
    'should get a random [Pokemon] from the repository',
    () async {
      // Arrange
      when(mockRepository.getRandomPokemon())
          .thenAnswer((_) async => Right(tPokemon));

      // Act
      final result = await usecase();

      // Assert
      expect(result, equals(Right(tPokemon)));
      verify(mockRepository.getRandomPokemon());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
