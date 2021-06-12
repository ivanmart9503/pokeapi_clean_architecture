import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/core/network/network_info.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_local_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_remote_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/models/pokemon_model.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/repositories/pokeapi_repository_impl.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';

class MockPokeapiRemoteDataSource extends Mock
    implements PokeapiRemoteDataSource {}

class MockPokeapiLocalDataSource extends Mock
    implements PokeapiLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockRandom extends Mock implements Random {}

void main() {
  MockPokeapiRemoteDataSource mockRemoteDataSource;
  MockPokeapiLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockRandom mockRandom;
  PokeapiRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockPokeapiRemoteDataSource();
    mockLocalDataSource = MockPokeapiLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockRandom = MockRandom();
    repository = PokeapiRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      random: mockRandom,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcretePokemon', () {
    final tNumber = 1;
    final tPokemonModel = PokemonModel(
      id: 1,
      name: 'Bulbasaur',
      types: ['grass', 'poison'],
      spriteUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
    );
    final Pokemon tPokemon = tPokemonModel;

    test(
      'should check if the device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // Act
        repository.getConcretePokemon(tNumber);

        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getPokemon(any))
              .thenAnswer((_) async => tPokemonModel);

          // Act
          final result = await repository.getConcretePokemon(tNumber);

          // Assert
          verify(mockRemoteDataSource.getPokemon(tNumber));
          expect(result, equals(Right(tPokemon)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getPokemon(any))
              .thenAnswer((_) async => tPokemonModel);

          // Act
          await repository.getConcretePokemon(tNumber);

          // Assert
          verify(mockRemoteDataSource.getPokemon(tNumber));
          verify(mockLocalDataSource.cachePokemon(tPokemonModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getPokemon(any))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getConcretePokemon(tNumber);

          // Assert
          verify(mockRemoteDataSource.getPokemon(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last [PokemonModel] cached locally',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastPokemon())
              .thenAnswer((_) async => tPokemonModel);

          // Act
          final result = await repository.getConcretePokemon(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastPokemon());
          expect(result, equals(Right(tPokemon)));
        },
      );

      test(
        'should return a [CacheFailure] when there is not cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastPokemon())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getConcretePokemon(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastPokemon());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomPokemon', () {
    final tRandomNumber = 1;
    final tPokemonModel = PokemonModel(
      id: 1,
      name: 'Bulbasaur',
      types: ['grass', 'poison'],
      spriteUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
    );
    final Pokemon tPokemon = tPokemonModel;

    test(
      'should check if the device is online',
      () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // Act
        repository.getRandomPokemon();

        // Assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRandom.nextInt(any)).thenReturn(tRandomNumber);
          when(mockRemoteDataSource.getPokemon(any))
              .thenAnswer((_) async => tPokemonModel);

          // Act
          final result = await repository.getRandomPokemon();

          // Assert
          verify(mockRemoteDataSource.getPokemon(tRandomNumber));
          expect(result, equals(Right(tPokemon)));
        },
      );

      test(
        'should cache data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRandom.nextInt(any)).thenReturn(tRandomNumber);
          when(mockRemoteDataSource.getPokemon(any))
              .thenAnswer((_) async => tPokemonModel);

          // Act
          await repository.getRandomPokemon();

          // Assert
          verify(mockRemoteDataSource.getPokemon(tRandomNumber));
          verify(mockLocalDataSource.cachePokemon(tPokemonModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRandom.nextInt(any)).thenReturn(tRandomNumber);
          when(mockRemoteDataSource.getPokemon(any))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getRandomPokemon();

          // Assert
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last [PokemonModel] cached locally',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastPokemon())
              .thenAnswer((_) async => tPokemonModel);

          // Act
          final result = await repository.getRandomPokemon();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastPokemon());
          expect(result, equals(Right(tPokemon)));
        },
      );

      test(
        'should return a [CacheFailure] when there is not cached data present',
        () async {
          // Arrange
          when(mockLocalDataSource.getLastPokemon())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getRandomPokemon();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastPokemon());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
