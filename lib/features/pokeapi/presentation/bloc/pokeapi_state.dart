part of 'pokeapi_bloc.dart';

abstract class PokeapiState extends Equatable {
  const PokeapiState();

  @override
  List<Object> get props => [];
}

class PokeapiInitial extends PokeapiState {}

class PokeapiLoadInProgress extends PokeapiState {}

class PokeapiLoadSuccess extends PokeapiState {
  final Pokemon pokemon;

  PokeapiLoadSuccess(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokeapiLoadFailure extends PokeapiState {}
