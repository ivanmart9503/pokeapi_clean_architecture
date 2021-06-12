import 'package:flutter/material.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/bloc/pokeapi_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokeapiControls extends StatefulWidget {
  @override
  _PokeapiControlsState createState() => _PokeapiControlsState();
}

class _PokeapiControlsState extends State<PokeapiControls> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _numberCtrl,
            cursorColor: Colors.red,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter a pokedex number',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
              errorBorder: OutlineInputBorder(),
              focusedErrorBorder: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(),
            ),
            validator: (value) {
              try {
                if (value.isEmpty) {
                  throw Exception();
                }

                int.parse(value);
                return null;
              } on Exception {
                return 'Please enter a valid number';
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RaisedButton(
                child: Text('Random pokemon'),
                onPressed: () {
                  context.read<PokeapiBloc>().add(GetRandomPokemonStarted());
                },
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text('Search pokemon'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final number = int.parse(_numberCtrl.text);
                    context
                        .read<PokeapiBloc>()
                        .add(GetConcretePokemonStarted(number));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
