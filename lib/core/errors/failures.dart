import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure({String message = 'Server Error'}) : super(message: message);
}

class CacheFailure extends Failure {
  CacheFailure({String message = 'Cache Error'}) : super(message: message);
}
