import 'package:flutter/material.dart';

class PokemonNotFoundMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'Pokemon not found :(',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
