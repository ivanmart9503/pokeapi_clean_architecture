import 'package:dartz/dartz.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';

class GetRandomPokemon {
  final PokeapiRepository repository;

  GetRandomPokemon(this.repository);

  Future<Either<Failure, Pokemon>> call() async {
    return await repository.getRandomPokemon();
  }
}
