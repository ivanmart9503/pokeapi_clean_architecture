import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokeapi_clean_architecture/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfo;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  test(
    'should forward the call to [DataConnectionChecker.hasConnection]',
    () async {
      // Arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);

      // Act
      final result = await networkInfo.isConnected;

      // Assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, equals(true));
    },
  );
}
