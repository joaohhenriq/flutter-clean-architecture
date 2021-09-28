import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient?.get(Uri.parse(''), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientError() {
    when(mockHttpClient?.get(Uri.parse(''), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', () async {
      setUpMockHttpClientSuccess200();

      dataSource?.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient?.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      setUpMockHttpClientSuccess200();

      final result = dataSource?.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      setUpMockHttpClientError();

      final call = dataSource?.getConcreteNumberTrivia;

      expect(() => call!(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', () async {
      setUpMockHttpClientSuccess200();

      dataSource?.getRandomNumberTrivia();

      verify(mockHttpClient?.get(Uri.parse('http://numbersapi.com/random'), headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200', () async {
      setUpMockHttpClientSuccess200();

      final result = dataSource?.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      setUpMockHttpClientError();

      final call = dataSource?.getRandomNumberTrivia;

      expect(() => call!(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
