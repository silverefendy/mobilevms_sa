import 'package:mobile_vms/core/errors/app_exception.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';
import 'package:mobile_vms/domain/models/qr_models.dart';
import 'package:mobile_vms/domain/repositories/qr_operations_repository.dart';

class QROperationsRepositoryImpl implements QROperationsRepository {
  QROperationsRepositoryImpl(this._apiClient);

  final JwtApiClient _apiClient;

  @override
  Future<QRCodeGenerateResponse> generateQRCode({
    required String visitId,
    int? expires_in_minutes,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/qr-codes/generate',
        data: {
          'visit_id': visitId,
          if (expires_in_minutes != null) 'expires_in_minutes': expires_in_minutes,
        },
      );
      return QRCodeGenerateResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to generate QR code');
    }
  }

  @override
  Future<QRCodeResponse> getQRCode(String qrCodeId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/qr-operations/qr-codes/$qrCodeId',
      );
      return QRCodeResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get QR code');
    }
  }

  @override
  Future<QRCodeResponse> revokeQRCode(String qrCodeId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/qr-codes/$qrCodeId/revoke',
      );
      return QRCodeResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to revoke QR code');
    }
  }

  @override
  Future<ScanResolveResponse> resolveScan(String token) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/scans/resolve',
        data: {'token': token},
      );
      return ScanResolveResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to resolve scan');
    }
  }

  @override
  Future<CheckInEventResponse> executeCheckIn({
    required String token,
    String? gateId,
    String? gateDeviceId,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/scans/execute',
        data: {
          'token': token,
          if (gateId != null) 'gate_id': gateId,
          if (gateDeviceId != null) 'gate_device_id': gateDeviceId,
          if (notes != null) 'notes': notes,
        },
      );
      return CheckInEventResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to execute check-in');
    }
  }

  @override
  Future<CheckOutEventResponse> checkOutVisit({
    required String visitId,
    String? gateId,
    String? gateDeviceId,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/visits/$visitId/check-out',
        data: {
          if (gateId != null) 'gate_id': gateId,
          if (gateDeviceId != null) 'gate_device_id': gateDeviceId,
          if (notes != null) 'notes': notes,
        },
      );
      return CheckOutEventResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to check-out visitor');
    }
  }

  @override
  Future<VisitResponse> completeVisit(String visitId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/v1/qr-operations/visits/$visitId/complete',
      );
      return VisitResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to complete visit');
    }
  }

  @override
  Future<VisitorLogListResponse> getVisitorLogs({
    String? visitorId,
    String? visitId,
    String? visitRequestId,
    String? eventType,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/qr-operations/visitor-logs',
        queryParameters: {
          if (visitorId != null) 'visitor_id': visitorId,
          if (visitId != null) 'visit_id': visitId,
          if (visitRequestId != null) 'visit_request_id': visitRequestId,
          if (eventType != null) 'event_type': eventType,
          if (page != null) 'page': page,
          if (pageSize != null) 'page_size': pageSize,
        },
      );
      return VisitorLogListResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get visitor logs');
    }
  }

  @override
  Future<VisitorLogResponse> getVisitorLog(String logId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/qr-operations/visitor-logs/$logId',
      );
      return VisitorLogResponse.fromJson(response.data!);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Failed to get visitor log');
    }
  }
}
