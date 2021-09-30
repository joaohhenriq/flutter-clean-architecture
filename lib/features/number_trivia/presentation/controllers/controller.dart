import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:get/get.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero';

class Controller extends GetxController {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  Controller({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  });

  String message = 'Start searching';
  bool isLoading = false;

  void _updateMessage(String value) {
    message = value;
    update(['message']);
  }

  void _updateIsLoading(bool value) {
    isLoading = value;
    update(['loading']);
  }

  void getConcreteNumber(String number) {
    final inputEither = inputConverter.stringToUnsignedInteger(number);
    inputEither.fold(_inputConverterLeftSide, _inputConverterRightSide);
  }

  void _inputConverterLeftSide(Failure failure) {
    _updateMessage(INVALID_INPUT_FAILURE_MESSAGE);
  }

  void _inputConverterRightSide(int integer) async {
    _updateIsLoading(true);

    final concreteEither = await getConcreteNumberTrivia(Params(number: integer));

    concreteEither.fold(
      (failure) => _updateMessage(_mapFailureToMessage(failure)),
      (trivia) => _updateMessage(trivia.text),
    );

    _updateIsLoading(false);
  }

  void getRandomNumber() async {
    _updateIsLoading(true);

    final randomEither = await getRandomNumberTrivia(NoParams());

    randomEither.fold(
          (failure) => _updateMessage(_mapFailureToMessage(failure)),
          (trivia) => _updateMessage(trivia.text),
    );

    _updateIsLoading(false);
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
