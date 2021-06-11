import 'package:dartz/dartz.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';

abstract class PokeapiRepository {
  Future<Either<Failure, Pokemon>> getConcretePokemon(int number);
  Future<Either<Failure, Pokemon>> getRandomPokemon();
}
