import 'package:connectivity/connectivity.dart';
import 'package:flutter_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/controllers/controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final di = GetIt.instance;

Future<void> init() async {
  /// features
  _initFeatures();

  /// core
  _initCore();

  /// external
  await _initExternal();
}

void _initFeatures() {
  // Controllers
  di.registerFactory(
    () => Controller(
      getConcreteNumberTrivia: di(),
      getRandomNumberTrivia: di(),
      inputConverter: di(),
    ),
  );

  // Use cases
  di.registerLazySingleton(() => GetConcreteNumberTrivia(di()));
  di.registerLazySingleton(() => GetRandomNumberTrivia(di()));

  // Repository
  di.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: di(),
      localDataSource: di(),
      networkInfo: di(),
    ),
  );

  // Data sources
  di.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: di()));
  di.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: di()));
}

void _initCore() {
  di.registerLazySingleton(() => InputConverter());
  di.registerLazySingleton<NetworkInfo>(() => NetworkImpl(di()));
}

Future<void> _initExternal() async {
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => prefs);
  di.registerLazySingleton(() => http.Client());
  di.registerLazySingleton(() => Connectivity());
}
