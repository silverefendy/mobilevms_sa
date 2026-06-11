import 'package:mobile_vms/domain/models/qr_models.dart';

abstract class QROperationsRepository {
  /// Generate QR code for a visit
  Future<QRCodeGenerateResponse> generateQRCode({
    required String visitId,
    int? expires_in_minutes,
  });

  /// Get QR code details
  Future<QRCodeResponse> getQRCode(String qrCodeId);

  /// Revoke QR code
  Future<QRCodeResponse> revokeQRCode(String qrCodeId);

  /// Resolve scan (preview without execution)
  Future<ScanResolveResponse> resolveScan(String token);

  /// Execute check-in
  Future<CheckInEventResponse> executeCheckIn({
    required String token,
    String? gateId,
    String? gateDeviceId,
    String? notes,
  });

  /// Check-out visitor
  Future<CheckOutEventResponse> checkOutVisit({
    required String visitId,
    String? gateId,
    String? gateDeviceId,
    String? notes,
  });

  /// Complete visit
  Future<VisitResponse> completeVisit(String visitId);

  /// Get visitor logs
  Future<VisitorLogListResponse> getVisitorLogs({
    String? visitorId,
    String? visitId,
    String? visitRequestId,
    String? eventType,
    int? page,
    int? pageSize,
  });

  /// Get visitor log details
  Future<VisitorLogResponse> getVisitorLog(String logId);
}
