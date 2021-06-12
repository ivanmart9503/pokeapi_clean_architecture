import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_concrete_pokemon.dart';

class MockPokeapiRepository extends Mock implements PokeapiRepository {}

void main() {
  MockPokeapiRepository mockRepository;
  GetConcretePokemon usecase;

  setUp(() {
    mockRepository = MockPokeapiRepository();
    usecase = GetConcretePokemon(mockRepository);
  });

  final tNumber = 1;
  final tPokemon = Pokemon(
    id: 1,
    name: 'Bulbasaur',
    types: ['grass', 'poison'],
    spriteUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
  );

  test(
    'should get a [Pokemon] from the repository',
    () async {
      // Arrange
      when(mockRepository.getConcretePokemon(any))
          .thenAnswer((_) async => Right(tPokemon));

      // Act
      final result = await usecase(tNumber);

      // Assert
      expect(result, equals(Right(tPokemon)));
      verify(mockRepository.getConcretePokemon(tNumber));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
