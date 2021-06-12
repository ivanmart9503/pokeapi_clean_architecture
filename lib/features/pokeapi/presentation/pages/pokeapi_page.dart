import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/bloc/pokeapi_bloc.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/widgets/initial_message.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/widgets/loading.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/widgets/pokeapi_controls.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/widgets/pokemon_info_display.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/widgets/pokemon_not_found_message.dart';
import 'package:pokeapi_clean_architecture/injection_container.dart';

class PokeapiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokeapiBloc>(
      create: (context) => sl<PokeapiBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            height: 40,
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          children: [
            BlocBuilder<PokeapiBloc, PokeapiState>(
              builder: (context, state) {
                if (state is PokeapiInitial) {
                  return InitialMessage();
                }

                if (state is PokeapiLoadInProgress) {
                  return Loading();
                }

                if (state is PokeapiLoadSuccess) {
                  return PokemonInfoDisplay(state.pokemon);
                }

                if (state is PokeapiLoadFailure) {
                  return PokemonNotFoundMessage();
                }
              },
            ),
            PokeapiControls(),
          ],
        ),
      ),
    );
  }
}
