import 'package:dartz/dartz.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';

class GetConcretePokemon {
  final PokeapiRepository repository;

  GetConcretePokemon(this.repository);

  Future<Either<Failure, Pokemon>> call(int number) async {
    return await repository.getConcretePokemon(number);
  }
}
