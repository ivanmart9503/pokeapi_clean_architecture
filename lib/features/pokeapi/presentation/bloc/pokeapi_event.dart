part of 'pokeapi_bloc.dart';

abstract class PokeapiEvent extends Equatable {
  const PokeapiEvent();

  @override
  List<Object> get props => [];
}

class GetConcretePokemonStarted extends PokeapiEvent {
  final int number;

  GetConcretePokemonStarted(this.number);

  @override
  List<Object> get props => [number];
}

class GetRandomPokemonStarted extends PokeapiEvent {}
