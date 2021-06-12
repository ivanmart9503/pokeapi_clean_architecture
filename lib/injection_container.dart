import 'dart:math';

import 'package:pokeapi_clean_architecture/core/network/network_info.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_local_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/datasources/pokeapi_remote_data_source.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/data/repositories/pokeapi_repository_impl.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/repositories/pokeapi_repository.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_concrete_pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/domain/usecases/get_random_pokemon.dart';
import 'package:pokeapi_clean_architecture/features/pokeapi/presentation/bloc/pokeapi_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Pokeapi Feature
  // Bloc
  sl.registerFactory(
    () => PokeapiBloc(
      getConcretePokemon: sl(),
      getRandomPokemon: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => GetConcretePokemon(sl()));
  sl.registerLazySingleton(() => GetRandomPokemon(sl()));

  // Repositories
  sl.registerLazySingleton<PokeapiRepository>(
    () => PokeapiRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      random: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<PokeapiRemoteDataSource>(
    () => PokeapiRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PokeapiLocalDataSource>(
    () => PokeapiLocalDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // Thirdparty packages
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => http.Client());

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  // Others
  sl.registerLazySingleton(() => Random());
}
