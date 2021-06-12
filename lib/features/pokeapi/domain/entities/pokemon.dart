import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final List<String> types;
  final String spriteUrl;

  Pokemon({
    @required this.id,
    @required this.name,
    @required this.types,
    @required this.spriteUrl,
  });

  @override
  List<Object> get props => [id, name, types, spriteUrl];
}
