import 'package:flutter/material.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/pages/pokeapi_page.dart';
import 'package:pokeapi_clean_architecture/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokeapi',
      home: PokeapiPage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}
