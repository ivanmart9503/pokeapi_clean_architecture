import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pokeapi_clean_architecture/core/errors/exceptions.dart';
import 'package:pokeapi_clean_architecture/core/network/network_info.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_local_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_remote_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';

class PokeapiRepositoryImpl implements PokeapiRepository {
  final PokeapiRemoteDataSource remoteDataSource;
  final PokeapiLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final Random random;

  PokeapiRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
    @required this.random,
  });

  @override
  Future<Either<Failure, Pokemon>> getConcretePokemon(int number) async {
    return await _getConcreteOrRandomPokemon(number);
  }

  @override
  Future<Either<Failure, Pokemon>> getRandomPokemon() async {
    return await _getConcreteOrRandomPokemon(random.nextInt(898));
  }

  Future<Either<Failure, Pokemon>> _getConcreteOrRandomPokemon(
    int number,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPokemon(number);
        await localDataSource.cachePokemon(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localDataSource.getLastPokemon();
        return Right(result);
      } on CacheException catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}
