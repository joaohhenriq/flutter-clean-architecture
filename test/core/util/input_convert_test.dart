import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () async {
      final str = '123';

      final result = inputConverter?.stringToUnsignedInteger(str);

      expect(result, Right(123));
    });

    test('should return a Failure when the string is not an integer', () async {
      final str = 'abc'; // or '1.0'

      final result = inputConverter?.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer', () async {
      final str = '-123'; // or '1.0'

      final result = inputConverter?.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}