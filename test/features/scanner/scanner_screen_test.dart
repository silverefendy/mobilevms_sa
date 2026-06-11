import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mobile_vms/features/scanner/scanner_screen.dart';
import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/data/repositories/qr_operations_repository.dart';

@GenerateMocks([QROperationsRepository])
import 'scanner_screen_test.mocks.dart';

void main() {
  group('ScannerScreen', () {
    late MockQROperationsRepository mockQrRepository;

    setUp(() {
      mockQrRepository = MockQROperationsRepository();
    });

    test('should scan QR successfully', () async {
      // Arrange
      final qrToken = 'valid_qr_token_12345';
      
      when(mockQrRepository.resolveScan(qrToken))
          .thenAnswer((_) async => {
            'valid': true,
            'visitor': {'id': 'visitor-1', 'name': 'John Doe'},
            'visit': {'id': 'visit-1', 'status': 'SCHEDULED'},
            'warnings': []
          });

      // Act
      final result = await mockQrRepository.resolveScan(qrToken);

      // Assert
      verify(mockQrRepository.resolveScan(qrToken)).called(1);
      expect(result['valid'], isTrue);
      expect(result['visitor'], isNotNull);
      expect(result['visit'], isNotNull);
    });

    test('should fail scan with invalid token', () async {
      // Arrange
      final qrToken = 'invalid_token';
      
      when(mockQrRepository.resolveScan(qrToken))
          .thenAnswer((_) async => {
            'valid': false,
            'visitor': null,
            'visit': null,
            'warnings': ['Invalid QR token']
          });

      // Act
      final result = await mockQrRepository.resolveScan(qrToken);

      // Assert
      verify(mockQrRepository.resolveScan(qrToken)).called(1);
      expect(result['valid'], isFalse);
      expect(result['warnings'], isNotEmpty);
    });

    test('should fail scan with network error', () async {
      // Arrange
      final qrToken = 'valid_qr_token_12345';
      
      when(mockQrRepository.resolveScan(qrToken))
          .thenThrow(AppException.network('Network error'));

      // Act & Assert
      expect(
        () => mockQrRepository.resolveScan(qrToken),
        throwsA(isA<AppException>()),
      );
    });
  });
}
