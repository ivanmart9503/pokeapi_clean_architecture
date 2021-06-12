import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pokeapi_clean_architecture/core/errors/failures.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_concrete_pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_random_pokemon.dart';

part 'pokeapi_event.dart';
part 'pokeapi_state.dart';

typedef Future<Either<Failure, Pokemon>> GetConcreteOrRandom();

class PokeapiBloc extends Bloc<PokeapiEvent, PokeapiState> {
  final GetConcretePokemon getConcretePokemon;
  final GetRandomPokemon getRandomPokemon;

  PokeapiBloc({
    @required this.getConcretePokemon,
    @required this.getRandomPokemon,
  }) : super(PokeapiInitial());

  @override
  Stream<PokeapiState> mapEventToState(
    PokeapiEvent event,
  ) async* {
    if (event is GetConcretePokemonStarted) {
      yield* _getConcreteOrRandomPokemon(
        () => getConcretePokemon(event.number),
      );
    } else if (event is GetRandomPokemonStarted) {
      yield* _getConcreteOrRandomPokemon(
        () => getRandomPokemon(),
      );
    }
  }

  Stream<PokeapiState> _getConcreteOrRandomPokemon(
    GetConcreteOrRandom usecase,
  ) async* {
    yield PokeapiLoadInProgress();

    final result = await usecase();

    yield* result.fold(
      (failure) async* {
        yield PokeapiLoadFailure();
      },
      (pokemon) async* {
        yield PokeapiLoadSuccess(pokemon);
      },
    );
  }
}
