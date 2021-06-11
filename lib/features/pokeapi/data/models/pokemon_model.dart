import 'package:flutter/foundation.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/entities/pokemon.dart';

class PokemonModel extends Pokemon {
  PokemonModel({
    @required String name,
    @required List<String> types,
    @required String spriteUrl,
  }) : super(
          name: name,
          types: types,
          spriteUrl: spriteUrl,
        );

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      types: getTypesFromJson(json),
      spriteUrl: getSpriteUrlFromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "types": types
          .map((type) => {
                "type": {"name": type}
              })
          .toList(),
      "sprites": {
        "other": {
          "dream_world": {"front_default": spriteUrl}
        },
      },
    };
  }
}

List<String> getTypesFromJson(Map<String, dynamic> json) {
  final rawTypes = json['types'] as List<dynamic>;
  return rawTypes.map((e) {
    return e['type']['name'] as String;
  }).toList();
}

String getSpriteUrlFromJson(Map<String, dynamic> json) {
  return json['sprites']['other']['dream_world']['front_default'];
}
