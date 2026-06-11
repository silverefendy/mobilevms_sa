# UAT Checklist

## Overview
This document provides a comprehensive User Acceptance Testing (UAT) checklist for the migrated Flutter VMS application using the vms_sa backend.

## Test Environment Setup

### Prerequisites
- [ ] Backend server (vms_sa) is running and accessible
- [ ] Backend database is properly configured
- [ ] Redis is running for refresh token storage
- [ ] Flutter app is built and installed on test device
- [ ] Test user accounts are created in the backend
- [ ] Test company is configured in the backend

### Configuration
- [ ] Server URL is configured in the app
- [ ] Company code is known and valid
- [ ] Test credentials are documented

---

## Phase D: Authentication Migration

### D.1 Server Setup
- [ ] App launches and shows splash screen
- [ ] When no server URL is configured, user is redirected to server setup screen
- [ ] User can enter server URL (http:// or https://)
- [ ] Test connection button validates server connectivity
- [ ] Valid server URL is saved successfully
- [ ] User is redirected to login screen after successful setup

### D.2 Login Flow
- [ ] Login screen displays username, password, and company code fields
- [ ] Company code field is required
- [ ] Login button is disabled when form is invalid
- [ ] Valid credentials (username, password, company code) successfully authenticate
- [ ] JWT access token and refresh token are stored securely
- [ ] User is redirected to dashboard after successful login
- [ ] Invalid credentials show appropriate error message
- [ ] Network errors show appropriate error message
- [ ] Remembered credentials (username, company code) are pre-filled

### D.3 Token Refresh
- [ ] Access token is automatically refreshed when expired
- [ ] Refresh token is used to obtain new access token
- [ ] User session remains active during token refresh
- [ ] Invalid refresh token forces logout
- [ ] Logout clears all stored tokens

### D.4 Logout
- [ ] Logout button in dashboard works
- [ ] Logout confirmation dialog is shown
- [ ] Logout clears local auth state
- [ ] Logout calls backend logout endpoint
- [ ] User is redirected to login screen after logout

---

## Phase G: QR Flow Migration

### G.1 QR Scanner
- [ ] Scanner screen launches successfully
- [ ] Camera permission is requested and granted
- [ ] QR code scanning works with mobile_scanner
- [ ] Scanner shows "Start Scanning" button initially
- [ ] Scanning state shows camera view
- [ ] Scanning detects QR codes correctly

### G.2 QR Resolve
- [ ] Scanned QR code is resolved via backend API
- [ ] Invalid QR codes show appropriate error message
- [ ] Valid QR codes show visitor/visit information
- [ ] Resolve operation does not execute check-in
- [ ] Resolve warnings are displayed if any

### G.3 QR Execute (Check-in)
- [ ] After successful resolve, check-in is executed
- [ ] Check-in calls backend execute endpoint
- [ ] Successful check-in shows success message
- [ ] Failed check-in shows error message
- [ ] User can scan another QR code after success
- [ ] User can retry after failure

### G.4 QR Code Generation
- [ ] QR code can be generated for a visit (if feature is implemented)
- [ ] Generated QR code is scannable
- [ ] QR code expiration is respected

---

## Phase H: Approval Flow Migration

### H.1 Approvals Screen
- [ ] Approvals screen is accessible from dashboard
- [ ] Pending approval tasks are loaded from backend
- [ ] Empty state shows when no pending approvals
- [ ] Loading indicator shows during data fetch
- [ ] Error state shows appropriate message
- [ ] Refresh button reloads approval tasks

### H.2 Approve Task
- [ ] Approve button is shown for each task
- [ ] Approve confirmation dialog is shown
- [ ] Approve calls backend approve endpoint
- [ ] Successful approval removes task from list
- [ ] Success message is shown
- [ ] Failed approval shows error message

### H.3 Reject Task
- [ ] Reject button is shown for each task
- [ ] Reject dialog requires reason input
- [ ] Reject with empty reason shows validation error
- [ ] Reject calls backend reject endpoint
- [ ] Successful rejection removes task from list
- [ ] Success message is shown
- [ ] Failed rejection shows error message

### H.4 Task Details
- [ ] Task shows visit request ID
- [ ] Task shows approval type
- [ ] Task shows approval level
- [ ] Task shows due date
- [ ] Task shows status badge

---

## Phase F: Model Mapping

### F.1 Auth Models
- [ ] LoginRequest matches backend schema
- [ ] TokenResponse matches backend schema
- [ ] UserBasicInfo matches backend schema
- [ ] RefreshRequest matches backend schema
- [ ] ChangePasswordRequest matches backend schema
- [ ] LogoutRequest matches backend schema
- [ ] MeResponse matches backend schema

### F.2 QR Models
- [ ] QRCodeResponse matches backend schema
- [ ] QRCodeGenerateRequest matches backend schema
- [ ] QRCodeGenerateResponse matches backend schema
- [ ] ScanResolveRequest matches backend schema
- [ ] ScanResolveResponse matches backend schema
- [ ] ScanExecuteRequest matches backend schema
- [ ] CheckInEventResponse matches backend schema
- [ ] CheckOutEventResponse matches backend schema
- [ ] CheckOutRequest matches backend schema
- [ ] VisitResponse matches backend schema
- [ ] VisitorLogResponse matches backend schema
- [ ] VisitorLogListResponse matches backend schema

### F.3 Approval Models
- [ ] ApprovalTaskResponse matches backend schema
- [ ] ApprovalTaskApproveRequest matches backend schema
- [ ] ApprovalTaskRejectRequest matches backend schema
- [ ] ApprovalDecisionResponse matches backend schema
- [ ] ApprovalTaskListResponse matches backend schema
- [ ] ApprovalDecisionListResponse matches backend schema

### F.4 Dashboard Models
- [ ] SecurityDashboardMetrics matches backend schema
- [ ] ReceptionDashboardMetrics matches backend schema
- [ ] ManagerDashboardMetrics matches backend schema
- [ ] HRDashboardMetrics matches backend schema
- [ ] ExecutiveDashboardMetrics matches backend schema

### F.5 Lookup Models
- [ ] DepartmentLookupResponse matches backend schema
- [ ] EmployeeLookupResponse matches backend schema
- [ ] GateLookupResponse matches backend schema
- [ ] VisitPurposeLookupResponse matches backend schema

### F.6 Visitor Models
- [ ] VisitorResponse matches backend schema
- [ ] VisitRequestResponse matches backend schema
- [ ] VisitorListResponse matches backend schema
- [ ] VisitRequestListResponse matches backend schema
- [ ] VisitorCreateRequest matches backend schema
- [ ] VisitRequestCreateRequest matches backend schema

---

## Phase E: API Client Migration

### E.1 JWT API Client
- [ ] JWT API client is properly initialized
- [ ] Access token is injected into Authorization header
- [ ] Token type is correctly set (Bearer)
- [ ] Auto-refresh works on 401 responses
- [ ] Refresh token is used to obtain new access token
- [ ] Failed refresh clears tokens and forces logout
- [ ] Error handling is centralized
- [ ] Network errors are handled appropriately

### E.2 Repository Implementations
- [ ] JwtAuthRepositoryImpl uses JWT API client
- [ ] QROperationsRepositoryImpl uses JWT API client
- [ ] ApprovalRepositoryImpl uses JWT API client
- [ ] All repositories handle AppException correctly
- [ ] All repositories map backend errors to user-friendly messages

---

## Cross-Functional Tests

### X.1 Navigation
- [ ] GoRouter navigation works correctly
- [ ] Back navigation works correctly
- [ ] Deep linking works (if implemented)
- [ ] Navigation preserves state appropriately

### X.2 State Management
- [ ] Provider state updates correctly
- [ ] AuthController state changes trigger UI updates
- [ ] Repository changes trigger UI updates
- [ ] State is persisted across navigation

### X.3 Error Handling
- [ ] Network errors show user-friendly messages
- [ ] Server errors show user-friendly messages
- [ ] Validation errors show user-friendly messages
- [ ] Error states are recoverable
- [ ] Error logging is implemented

### X.4 Security
- [ ] Access tokens are stored securely
- [ ] Refresh tokens are stored securely
- [ ] Tokens are cleared on logout
- [ ] HTTPS is used in production
- [ ] Sensitive data is not logged

### X.5 Performance
- [ ] App launches within acceptable time
- [ ] Login completes within acceptable time
- [ ] QR scanning is responsive
- [ ] Approval operations complete within acceptable time
- [ ] No memory leaks detected
- [ ] No excessive CPU usage

---

## Device-Specific Tests

### Android
- [ ] App installs successfully on Android
- [ ] Camera permission is requested correctly
- [ ] QR scanner works on Android
- [ ] Secure storage works on Android
- [ ] Back button behavior is correct

### iOS
- [ ] App installs successfully on iOS
- [ ] Camera permission is requested correctly
- [ ] QR scanner works on iOS
- [ ] Secure storage works on iOS
- [ ] Swipe back navigation works

---

## Regression Tests

### R.1 Legacy Features
- [ ] All previously working features still work
- [ ] No breaking changes introduced
- [ ] Data migration is not required
- [ ] User experience is not degraded

### R.2 Backend Compatibility
- [ ] All API endpoints are called correctly
- [ ] Request/response formats match backend expectations
- [ ] Authentication works with backend
- [ ] Authorization works with backend
- [ ] Rate limiting is respected

---

## Sign-Off

### Tester Information
- **Tester Name**: ___________________
- **Test Date**: ___________________
- **Test Environment**: ___________________

### Results Summary
- **Total Tests**: _____
- **Passed**: _____
- **Failed**: _____
- **Blocked**: _____
- **N/A**: _____

### Approval
- **Approved for Production**: [ ] Yes [ ] No
- **Comments**: ___________________
- **Approver Name**: ___________________
- **Approval Date**: ___________________
