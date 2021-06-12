import 'package:flutter/material.dart';

class InitialMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'Try to search a Pokemon!',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
