import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_concrete_pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_random_pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/bloc/pokeapi_bloc.dart';

class MockGetConcretePokemon extends Mock implements GetConcretePokemon {}

class MockGetRandomPokemon extends Mock implements GetRandomPokemon {}

void main() {
  MockGetConcretePokemon mockGetConcretePokemon;
  MockGetRandomPokemon mockGetRandomPokemon;
  PokeapiBloc bloc;

  setUp(() {
    mockGetConcretePokemon = MockGetConcretePokemon();
    mockGetRandomPokemon = MockGetRandomPokemon();
    bloc = PokeapiBloc(
      getConcretePokemon: mockGetConcretePokemon,
      getRandomPokemon: mockGetRandomPokemon,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tPokemon = Pokemon(
    id: 1,
    name: 'Bulbasaur',
    types: ['grass', 'poison'],
    spriteUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
  );

  test(
    'initial state should be [PokeapiInitial]',
    () async {
      // Assert
      expect(bloc.state, equals(PokeapiInitial()));
    },
  );

  group('GetConcretePokemonStarted', () {
    final tNumber = 1;

    blocTest(
      'should emit [PokeapiLoadInProgress, PokeapiLoadSuccess] when data is gotten successfully',
      build: () {
        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (_) => bloc.add(GetConcretePokemonStarted(tNumber)),
      verify: (_) {
        verify(mockGetConcretePokemon(tNumber));
      },
      expect: [
        PokeapiLoadInProgress(),
        PokeapiLoadSuccess(tPokemon),
      ],
    );

    blocTest(
      'should emit [PokeapiLoadInProgress, PokeapiLoadFailure] when getting data fails',
      build: () {
        when(mockGetConcretePokemon(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (_) => bloc.add(GetConcretePokemonStarted(tNumber)),
      verify: (_) {
        verify(mockGetConcretePokemon(tNumber));
      },
      expect: [
        PokeapiLoadInProgress(),
        PokeapiLoadFailure(),
      ],
    );
  });

  group('GetRandomPokemonStarted', () {
    blocTest(
      'should emit [PokeapiLoadInProgress, PokeapiLoadSuccess] when data is gotten successfully',
      build: () {
        when(mockGetRandomPokemon()).thenAnswer((_) async => Right(tPokemon));
        return bloc;
      },
      act: (_) => bloc.add(GetRandomPokemonStarted()),
      verify: (_) {
        verify(mockGetRandomPokemon());
      },
      expect: [
        PokeapiLoadInProgress(),
        PokeapiLoadSuccess(tPokemon),
      ],
    );

    blocTest(
      'should emit [PokeapiLoadInProgress, PokeapiLoadFailure] when getting data fails',
      build: () {
        when(mockGetRandomPokemon())
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (_) => bloc.add(GetRandomPokemonStarted()),
      verify: (_) {
        verify(mockGetRandomPokemon());
      },
      expect: [
        PokeapiLoadInProgress(),
        PokeapiLoadFailure(),
      ],
    );
  });
}
