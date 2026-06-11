# Implementation Plan

**Project:** VMS Mobile Migration
**Date:** June 11, 2026
**Phase:** Phase C - Implementation Plan
**Status:** In Progress

---

## Executive Summary

This implementation plan provides a detailed roadmap for migrating the Flutter reference implementation (mobilevms_sa/reference) to use the vms_sa backend APIs. The plan is organized by priority levels with estimated effort, dependencies, and migration risks.

**Total Estimated Effort:** 35-49 days (7-10 weeks)
**Critical Path:** Authentication → API Client → Model Mapping → QR Flow → Approval Flow

---

## 1. Critical Priority Tasks

### 1.1 Phase D: Authentication Migration

**Priority:** CRITICAL
**Estimated Effort:** 5-7 days
**Dependencies:** None (foundational work)
**Risk Level:** HIGH

#### Task D.1: Create JWT Authentication Models

**Files to Create:**
- `lib/domain/models/auth_models.dart`
- `lib/domain/models/user_models.dart`

**Files to Modify:**
- `lib/domain/models/auth_session.dart` (replace)

**Description:**
Create domain models matching backend authentication schemas:
- `LoginRequest`: {username, password, company_code, device_id}
- `TokenResponse`: {access_token, refresh_token, token_type, expires_in, user}
- `UserBasicInfo`: {id, username, email, full_name, language, company_id, roles, permissions}
- `MeResponse`: {id, username, email, full_name, phone, language, company_id, company_name, roles, permissions, last_login_at, mfa_enabled}
- `RefreshRequest`: {refresh_token}
- `ChangePasswordRequest`: {old_password, new_password}
- `LogoutRequest`: {refresh_token}

**Acceptance Criteria:**
- All models match backend Pydantic schemas exactly
- Models use UUID types for ID fields
- Models include proper JSON serialization

**Estimated Effort:** 1 day

---

#### Task D.2: Create JWT Authentication Repository

**Files to Create:**
- `lib/domain/repositories/jwt_auth_repository.dart` (interface)
- `lib/data/repositories/jwt_auth_repository_impl.dart` (implementation)

**Files to Modify:**
- `lib/data/repositories/auth_repository_impl.dart` (replace or deprecate)

**Description:**
Create new JWT-based authentication repository:
- `login(username, password, company_code, device_id)`: Returns TokenResponse
- `refreshTokens(refresh_token)`: Returns TokenResponse
- `logout(refresh_token)`: Invalidates session
- `getCurrentUser()`: Returns MeResponse
- `changePassword(old_password, new_password)`: Changes password
- `clearLocalAuthState()`: Clears stored tokens

**API Endpoints:**
- POST /api/v1/auth/login
- POST /api/v1/auth/refresh
- POST /api/v1/auth/logout
- GET /api/v1/auth/me
- POST /api/v1/auth/change-password

**Acceptance Criteria:**
- Repository implements JWT authentication flow
- Tokens stored securely using flutter_secure_storage
- Auto-refresh implemented when access token expires
- Proper error handling for 401/403 responses

**Estimated Effort:** 2 days

---

#### Task D.3: Update AuthController for JWT

**Files to Modify:**
- `lib/core/auth/auth_controller.dart`

**Description:**
Update AuthController to handle JWT authentication:
- Replace session-based auth with JWT token auth
- Implement auto-refresh logic
- Update session restoration to use stored tokens
- Add permission checking support
- Add company_code field to login

**Acceptance Criteria:**
- AuthController manages access_token and refresh_token
- Auto-refresh triggers before token expiration
- Session restoration validates tokens with backend
- Permissions and roles available for UI checks

**Estimated Effort:** 2 days

---

#### Task D.4: Update Login Screen

**Files to Modify:**
- `lib/features/auth/login_screen.dart`

**Description:**
Update login screen to support JWT authentication:
- Add company_code input field
- Update login call to include company_code
- Update error handling for JWT errors
- Remove ERPNext-specific error messages

**Acceptance Criteria:**
- Login screen accepts username, password, company_code
- Error messages are generic (not ERPNext-specific)
- Login flow works with JWT backend

**Estimated Effort:** 0.5 day

---

#### Task D.5: Update Server Setup Screen

**Files to Modify:**
- `lib/features/auth/server_setup_screen.dart`

**Description:**
Update server setup to work with JWT backend:
- Remove ERPNext-specific validation
- Add validation for vms_sa backend
- Update base URL configuration

**Acceptance Criteria:**
- Server setup validates vms_sa backend
- Base URL stored correctly
- Health check implemented

**Estimated Effort:** 0.5 day

---

#### Task D.6: Remove ERPNext Dependencies

**Files to Modify:**
- `lib/core/network/api_client.dart`
- `lib/data/repositories/auth_repository_impl.dart` (delete or deprecate)

**Description:**
Remove all ERPNext/Frappe dependencies:
- Remove cookie management (CookieJar, dio_cookie_manager)
- Remove CSRF token handling
- Remove /api/method/ endpoint pattern
- Remove {message: ...} response parsing

**Acceptance Criteria:**
- No ERPNext/Frappe dependencies remain
- API client uses standard REST endpoints
- No cookie management
- No CSRF token handling

**Estimated Effort:** 1 day

---

### 1.2 Phase E: API Client Migration

**Priority:** CRITICAL
**Estimated Effort:** 3-5 days
**Dependencies:** Phase D (Authentication)
**Risk Level:** HIGH

#### Task E.1: Create New API Client

**Files to Create:**
- `lib/core/network/jwt_api_client.dart`

**Files to Modify:**
- `lib/core/network/api_client.dart` (replace)

**Description:**
Create new JWT-based API client:
- Base URL configuration
- JWT token injection in Authorization header
- Request interceptor for token refresh
- Response interceptor for error handling
- Retry strategy for failed requests
- Timeout configuration
- Error mapping to AppException

**Features:**
- Automatic token refresh on 401
- Request retry with exponential backoff
- Centralized error handling
- Logging support
- Timeout handling (connect, receive, send)

**Acceptance Criteria:**
- API client injects JWT token in Authorization header
- Auto-refresh triggers on 401 responses
- Failed requests retry with backoff
- Errors mapped to AppException with proper messages
- Timeout configuration matches backend expectations

**Estimated Effort:** 2 days

---

#### Task E.2: Update API Client Configuration

**Files to Modify:**
- `lib/config/app_config.dart`

**Description:**
Update API configuration for JWT backend:
- Add environment configuration (dev, staging, production)
- Add API timeout configuration
- Add retry configuration
- Add logging configuration

**Acceptance Criteria:**
- Environment-specific configurations
- Configurable timeouts
- Configurable retry strategy
- Optional API logging

**Estimated Effort:** 0.5 day

---

#### Task E.3: Create Error Contract

**Files to Create:**
- `lib/core/errors/api_error.dart`
- `lib/core/errors/error_handler.dart`

**Description:**
Create centralized error handling matching backend error contract:
- 401 Unauthorized → Token expired/invalid
- 403 Forbidden → Insufficient permissions
- 404 Not Found → Resource not found
- 409 Conflict → Resource conflict
- 422 Unprocessable Entity → Validation error
- 429 Too Many Requests → Rate limit exceeded
- 500 Internal Server Error → Server error

**Acceptance Criteria:**
- All HTTP status codes mapped to user-friendly errors
- Error messages match backend error responses
- Permission errors trigger logout
- Validation errors display field-specific messages

**Estimated Effort:** 1 day

---

#### Task E.4: Update Repository Implementations

**Files to Modify:**
- `lib/data/repositories/operations_repository_impl.dart`

**Description:**
Update repository implementations to use new API client:
- Replace ERPNext endpoints with vms_sa endpoints
- Update request/response handling
- Update error handling

**Acceptance Criteria:**
- All repositories use new API client
- Endpoints match vms_sa API
- Error handling uses new error contract

**Estimated Effort:** 1.5 days

---

### 1.3 Phase F: Model Mapping

**Priority:** CRITICAL
**Estimated Effort:** 3-4 days
**Dependencies:** Phase E (API Client)
**Risk Level:** HIGH

#### Task F.1: Create QR Operation Models

**Files to Create:**
- `lib/domain/models/qr_models.dart`

**Description:**
Create domain models matching backend QR schemas:
- `QRCodeResponse`: {id, company_id, visit_id, visit_request_id, token_id, status, issued_at, expires_at, used_at, scan_count}
- `QRCodeGenerateRequest`: {visit_id, expires_in_minutes}
- `QRCodeGenerateResponse`: {qr_code, raw_token}
- `ScanResolveRequest`: {token}
- `ScanResolveResponse`: {valid, visitor, visit, warnings}
- `ScanExecuteRequest`: {token, gate_id, gate_device_id, notes}
- `CheckInEventResponse`: {id, visit_id, visit_request_id, visitor_id, company_id, gate_id, gate_device_id, performed_by, qr_code_id, checked_in_at, method, notes}
- `CheckOutEventResponse`: {id, visit_id, visit_request_id, visitor_id, company_id, gate_id, gate_device_id, performed_by, qr_code_id, checked_out_at, method, notes}
- `CheckOutRequest`: {gate_id, gate_device_id, notes}
- `VisitResponse`: {id, visit_request_id, visitor_id, host_employee_id, visit_purpose_id, scheduled_start_at, scheduled_end_at, status, created_at, updated_at}
- `VisitorLogResponse`: {id, visitor_id, visit_id, visit_request_id, company_id, event_type, event_time, performed_by, details}

**Acceptance Criteria:**
- All models match backend Pydantic schemas
- UUID types used for ID fields
- DateTime types used for timestamps
- Proper JSON serialization

**Estimated Effort:** 1 day

---

#### Task F.2: Create Approval Models

**Files to Create:**
- `lib/domain/models/approval_models.dart`

**Description:**
Create domain models matching backend approval schemas:
- `ApprovalTaskResponse`: {id, company_id, visit_request_id, approver_user_id, approval_type, level, status, due_at, assigned_at, started_at, completed_at, escalated_from_id, notes, created_at, updated_at}
- `ApprovalTaskApproveRequest`: {reason, comments}
- `ApprovalTaskRejectRequest`: {reason, comments}
- `ApprovalDecisionResponse`: {id, approval_task_id, decided_by, decision, reason, comments, decided_at, metadata_json, created_at}
- `ApprovalTaskListResponse`: {items, total, page, page_size, pages}
- `ApprovalDecisionListResponse`: {items, total, page, page_size, pages}

**Acceptance Criteria:**
- All models match backend Pydantic schemas
- Pagination models included
- Proper JSON serialization

**Estimated Effort:** 0.5 day

---

#### Task F.3: Create Dashboard Models

**Files to Create:**
- `lib/domain/models/dashboard_models.dart`

**Description:**
Create domain models matching backend dashboard schemas:
- `SecurityDashboardMetrics`: {active_visitors, pending_approvals, today_check_ins, today_check_outs, alerts}
- `ReceptionDashboardMetrics`: {expected_visitors, checked_in_visitors, pending_check_outs, gate_activity}
- `ManagerDashboardMetrics`: {team_visit_requests, approval_rate, visitor_statistics}
- `HRDashboardMetrics`: {visitor_trends, department_statistics, compliance_metrics}
- `ExecutiveDashboardMetrics`: {company_statistics, trends, kpis}

**Acceptance Criteria:**
- All models match backend analytics schemas
- Metrics are properly typed
- Proper JSON serialization

**Estimated Effort:** 0.5 day

---

#### Task F.4: Create Lookup Models

**Files to Create:**
- `lib/domain/models/lookup_models.dart`

**Description:**
Create domain models matching backend lookup schemas:
- `DepartmentLookupResponse`: {items}
- `EmployeeLookupResponse`: {items}
- `GateLookupResponse`: {items}
- `VisitPurposeLookupResponse`: {items}
- `LookupRequest`: {query, limit}

**Acceptance Criteria:**
- All models match backend lookup schemas
- Autocomplete-friendly structure
- Proper JSON serialization

**Estimated Effort:** 0.5 day

---

#### Task F.5: Create Visitor and Visit Request Models

**Files to Create:**
- `lib/domain/models/visitor_models.dart`

**Description:**
Create domain models matching backend visitor schemas:
- `VisitorResponse`: {id, first_name, last_name, email, phone, company, status, created_at, updated_at}
- `VisitRequestResponse`: {id, visitor_id, host_employee_id, purpose_id, scheduled_start, scheduled_end, status, request_no, created_at, updated_at}
- `VisitorListResponse`: {items, total, page, page_size, pages}
- `VisitRequestListResponse`: {items, total, page, page_size, pages}

**Acceptance Criteria:**
- All models match backend Pydantic schemas
- Pagination models included
- Proper JSON serialization

**Estimated Effort:** 0.5 day

---

#### Task F.6: Update Existing Models

**Files to Modify:**
- `lib/domain/models/operation_models.dart`
- `lib/domain/models/employee_models.dart`
- `lib/domain/models/menu_item.dart`

**Description:**
Update existing models to match backend schemas:
- Update `ScanResolution` to match `ScanResolveResponse`
- Update `ScanOutcome` to match backend response
- Update `VisitorRecord` to match `VisitorResponse`
- Update `ApprovalRecord` to match `ApprovalTaskResponse`
- Update employee models to match backend schemas

**Acceptance Criteria:**
- All models updated to match backend
- Backward compatibility maintained where possible
- Deprecation warnings for old fields

**Estimated Effort:** 1 day

---

## 2. High Priority Tasks

### 2.1 Phase G: QR Flow Migration

**Priority:** HIGH
**Estimated Effort:** 4-5 days
**Dependencies:** Phase F (Model Mapping)
**Risk Level:** HIGH

#### Task G.1: Create QR Operations Repository

**Files to Create:**
- `lib/domain/repositories/qr_operations_repository.dart` (interface)
- `lib/data/repositories/qr_operations_repository_impl.dart` (implementation)

**Description:**
Create QR operations repository matching backend API:
- `generateQRCode(visit_id, expires_in_minutes)`: Returns QRCodeGenerateResponse
- `getQRCode(qr_code_id)`: Returns QRCodeResponse
- `revokeQRCode(qr_code_id)`: Returns QRCodeResponse
- `resolveScan(token)`: Returns ScanResolveResponse
- `executeCheckIn(token, gate_id, gate_device_id, notes)`: Returns CheckInEventResponse
- `checkOutVisit(visit_id, gate_id, gate_device_id, notes)`: Returns CheckOutEventResponse
- `completeVisit(visit_id)`: Returns VisitResponse
- `getVisitorLogs(filters)`: Returns VisitorLogListResponse
- `getVisitorLog(log_id)`: Returns VisitorLogResponse

**API Endpoints:**
- POST /api/v1/qr-operations/qr-codes/generate
- GET /api/v1/qr-operations/qr-codes/{id}
- POST /api/v1/qr-operations/qr-codes/{id}/revoke
- POST /api/v1/qr-operations/scans/resolve
- POST /api/v1/qr-operations/scans/execute
- POST /api/v1/qr-operations/visits/{id}/check-out
- POST /api/v1/qr-operations/visits/{id}/complete
- GET /api/v1/qr-operations/visitor-logs
- GET /api/v1/qr-operations/visitor-logs/{id}

**Acceptance Criteria:**
- All QR operations implemented
- Resolve → execute pattern enforced
- Gate and gate_device tracking supported
- Proper error handling for invalid QR codes

**Estimated Effort:** 2 days

---

#### Task G.2: Update Scan Coordinator

**Files to Modify:**
- `lib/features/scanner/scan_coordinator.dart`

**Description:**
Update ScanCoordinator to use new QR operations repository:
- Update `resolveScanAction` to use new API
- Update `executeScanAction` to use new API
- Add support for gate selection
- Add support for notes
- Update state management for new response structure
- Add validation for backend state machine rules

**Acceptance Criteria:**
- ScanCoordinator uses new QR operations repository
- Resolve → execute pattern enforced
- Gate selection supported
- Notes supported
- State machine validation implemented

**Estimated Effort:** 1.5 days

---

#### Task G.3: Update Scanner Screen

**Files to Modify:**
- `lib/features/scanner/scanner_screen.dart`

**Description:**
Update scanner screen to support new QR workflow:
- Add gate selection UI
- Add notes input UI
- Update scan result display
- Update error handling
- Add warnings display from resolve response

**Acceptance Criteria:**
- Gate selection UI implemented
- Notes input UI implemented
- Scan results display correctly
- Warnings displayed from backend
- Error messages user-friendly

**Estimated Effort:** 1 day

---

#### Task G.4: Add QR Code Generation Screen

**Files to Create:**
- `lib/features/qr/qr_generate_screen.dart`
- `lib/features/qr/qr_generate_controller.dart`

**Description:**
Create QR code generation screen:
- Visit selection
- Expiry time configuration
- QR code display
- QR code download/share
- QR code revocation

**Acceptance Criteria:**
- QR code generation implemented
- Visit selection works
- Expiry time configurable
- QR code display and share work
- QR code revocation works

**Estimated Effort:** 1 day

---

### 2.2 Phase H: Approval Flow Migration

**Priority:** HIGH
**Estimated Effort:** 4-5 days
**Dependencies:** Phase F (Model Mapping)
**Risk Level:** HIGH

#### Task H.1: Create Approval Repository

**Files to Create:**
- `lib/domain/repositories/approval_repository.dart` (interface)
- `lib/data/repositories/approval_repository_impl.dart` (implementation)

**Description:**
Create approval repository matching backend API:
- `getApprovalTasks(filters)`: Returns ApprovalTaskListResponse
- `getPendingTasks(page, page_size)`: Returns ApprovalTaskListResponse
- `getApprovalTask(task_id)`: Returns ApprovalTaskResponse
- `approveTask(task_id, reason, comments)`: Returns ApprovalTaskResponse
- `rejectTask(task_id, reason, comments)`: Returns ApprovalTaskResponse
- `cancelTask(task_id)`: Returns ApprovalTaskResponse
- `getApprovalDecisions(filters)`: Returns ApprovalDecisionListResponse
- `getApprovalDecision(decision_id)`: Returns ApprovalDecisionResponse

**API Endpoints:**
- GET /api/v1/approvals/tasks
- GET /api/v1/approvals/tasks/pending
- GET /api/v1/approvals/tasks/{id}
- POST /api/v1/approvals/tasks/{id}/approve
- POST /api/v1/approvals/tasks/{id}/reject
- POST /api/v1/approvals/tasks/{id}/cancel
- GET /api/v1/approvals/decisions
- GET /api/v1/approvals/decisions/{id}

**Acceptance Criteria:**
- All approval operations implemented
- Pagination supported
- Filtering supported
- Permission checks enforced

**Estimated Effort:** 2 days

---

#### Task H.2: Update Approvals Controller

**Files to Modify:**
- `lib/features/approvals/approvals_controller.dart`

**Description:**
Update approvals controller to use new approval repository:
- Update `refresh` to use new API
- Update `approve` to use new API
- Update `reject` to use new API
- Add support for approval history
- Add support for approval details
- Add permission checks

**Acceptance Criteria:**
- ApprovalsController uses new approval repository
- Approval history implemented
- Approval details implemented
- Permission checks enforced

**Estimated Effort:** 1 day

---

#### Task H.3: Update Approvals Screen

**Files to Modify:**
- `lib/features/approvals/approvals_screen.dart`

**Description:**
Update approvals screen to support new approval workflow:
- Display approval task details
- Display approval history
- Add approval detail screen
- Add approval history screen
- Add permission-based UI rendering
- Update error handling

**Acceptance Criteria:**
- Approval task details displayed
- Approval history displayed
- Approval detail screen implemented
- Approval history screen implemented
- Permission-based UI rendering works

**Estimated Effort:** 1.5 days

---

#### Task H.4: Add Approval Detail Screen

**Files to Create:**
- `lib/features/approvals/approval_detail_screen.dart`

**Description:**
Create approval detail screen:
- Display full approval task information
- Display visitor information
- Display visit request information
- Display approval history
- Approve/Reject actions with reason/comments
- Cancel action

**Acceptance Criteria:**
- Full approval task information displayed
- Visitor information displayed
- Visit request information displayed
- Approval history displayed
- Approve/Reject with reason/comments works
- Cancel action works

**Estimated Effort:** 1 day

---

### 2.3 Phase K: Error Contract

**Priority:** HIGH
**Estimated Effort:** 2-3 days
**Dependencies:** Phase E (API Client)
**Risk Level:** MEDIUM

#### Task K.1: Implement Centralized Error Handler

**Files to Create:**
- `lib/core/errors/error_handler.dart`
- `lib/core/errors/api_error.dart`

**Description:**
Implement centralized error handler matching backend error contract:
- Map HTTP status codes to AppException
- Parse backend error responses
- Extract field-specific validation errors
- Handle permission errors (trigger logout)
- Handle rate limit errors (display retry message)
- Handle server errors (display generic message)

**Acceptance Criteria:**
- All HTTP status codes mapped
- Backend error responses parsed
- Validation errors field-specific
- Permission errors trigger logout
- Rate limit errors show retry message
- Server errors show generic message

**Estimated Effort:** 1.5 days

---

#### Task K.2: Update Error Display

**Files to Modify:**
- `lib/features/auth/login_screen.dart`
- `lib/features/scanner/scanner_screen.dart`
- `lib/features/approvals/approvals_screen.dart`

**Description:**
Update error display across all screens:
- Use centralized error messages
- Display field-specific validation errors
- Display permission errors
- Display rate limit errors
- Display server errors

**Acceptance Criteria:**
- All screens use centralized error messages
- Validation errors field-specific
- Permission errors trigger logout
- Rate limit errors show retry time
- Server errors show generic message

**Estimated Effort:** 1 day

---

## 3. Medium Priority Tasks

### 3.1 Phase I: Dashboard Migration

**Priority:** MEDIUM
**Estimated Effort:** 5-7 days
**Dependencies:** Phase F (Model Mapping)
**Risk Level:** MEDIUM

#### Task I.1: Create Dashboard Repository

**Files to Create:**
- `lib/domain/repositories/dashboard_repository.dart` (interface)
- `lib/data/repositories/dashboard_repository_impl.dart` (implementation)

**Description:**
Create dashboard repository matching backend API:
- `getSecurityDashboard(use_cache)`: Returns SecurityDashboardMetrics
- `getReceptionDashboard(use_cache)`: Returns ReceptionDashboardMetrics
- `getManagerDashboard(use_cache)`: Returns ManagerDashboardMetrics
- `getHRDashboard(use_cache)`: Returns HRDashboardMetrics
- `getExecutiveDashboard(use_cache)`: Returns ExecutiveDashboardMetrics

**API Endpoints:**
- GET /api/v1/dashboard/security
- GET /api/v1/dashboard/reception
- GET /api/v1/dashboard/manager
- GET /api/v1/dashboard/hr
- GET /api/v1/dashboard/executive

**Acceptance Criteria:**
- All dashboard endpoints implemented
- Cache support implemented
- Permission checks enforced
- Error handling implemented

**Estimated Effort:** 2 days

---

#### Task I.2: Update Dashboard Controller

**Files to Modify:**
- `lib/features/dashboard/dashboard_controller.dart`

**Description:**
Update dashboard controller to use new dashboard repository:
- Update to fetch specific dashboard based on user role
- Add caching support
- Add refresh functionality
- Add permission checks

**Acceptance Criteria:**
- Dashboard controller fetches role-specific dashboard
- Cache support implemented
- Refresh functionality works
- Permission checks enforced

**Estimated Effort:** 1 day

---

#### Task I.3: Create Dashboard Screens

**Files to Create:**
- `lib/features/dashboard/security_dashboard_screen.dart`
- `lib/features/dashboard/reception_dashboard_screen.dart`
- `lib/features/dashboard/manager_dashboard_screen.dart`
- `lib/features/dashboard/hr_dashboard_screen.dart`
- `lib/features/dashboard/executive_dashboard_screen.dart`

**Description:**
Create dashboard screens for each dashboard type:
- Display metrics
- Display charts/graphs
- Display lists (active visitors, pending approvals, etc.)
- Add refresh functionality
- Add permission-based rendering

**Acceptance Criteria:**
- All dashboard screens implemented
- Metrics displayed correctly
- Charts/graphs implemented
- Lists displayed correctly
- Refresh works
- Permission-based rendering works

**Estimated Effort:** 3 days

---

#### Task I.4: Update Dashboard Section Widget

**Files to Modify:**
- `lib/features/dashboard/dashboard_section.dart`

**Description:**
Update dashboard section widget to support multiple dashboard types:
- Role-based dashboard selection
- Dashboard switching
- Permission-based rendering

**Acceptance Criteria:**
- Role-based dashboard selection works
- Dashboard switching works
- Permission-based rendering works

**Estimated Effort:** 1 day

---

### 3.2 Phase J: Lookup Optimization

**Priority:** MEDIUM
**Estimated Effort:** 2-3 days
**Dependencies:** Phase F (Model Mapping)
**Risk Level:** LOW

#### Task J.1: Create Lookup Repository

**Files to Create:**
- `lib/domain/repositories/lookup_repository.dart` (interface)
- `lib/data/repositories/lookup_repository_impl.dart` (implementation)

**Description:**
Create lookup repository matching backend API:
- `lookupDepartments(query, limit)`: Returns DepartmentLookupResponse
- `lookupEmployees(query, limit)`: Returns EmployeeLookupResponse
- `lookupGates(query, limit)`: Returns GateLookupResponse
- `lookupVisitPurposes(query, limit)`: Returns VisitPurposeLookupResponse

**API Endpoints:**
- GET /api/v1/lookups/departments
- GET /api/v1/lookups/employees
- GET /api/v1/lookups/gates
- GET /api/v1/lookups/visit-purposes

**Acceptance Criteria:**
- All lookup endpoints implemented
- Autocomplete functionality works
- Debouncing implemented
- Permission checks enforced

**Estimated Effort:** 1.5 days

---

#### Task J.2: Create Lookup Widgets

**Files to Create:**
- `lib/features/widgets/department_lookup.dart`
- `lib/features/widgets/employee_lookup.dart`
- `lib/features/widgets/gate_lookup.dart`
- `lib/features/widgets/visit_purpose_lookup.dart`

**Description:**
Create lookup widgets for autocomplete:
- Search input with debouncing
- Dropdown with results
- Selection handling
- Error handling

**Acceptance Criteria:**
- All lookup widgets implemented
- Autocomplete works smoothly
- Debouncing prevents excessive API calls
- Selection handling works
- Error handling works

**Estimated Effort:** 1.5 days

---

### 3.3 Phase N: Testing

**Priority:** MEDIUM
**Estimated Effort:** 5-7 days
**Dependencies:** All implementation phases
**Risk Level:** MEDIUM

#### Task N.1: Unit Tests

**Files to Create:**
- `test/domain/models/auth_models_test.dart`
- `test/domain/models/qr_models_test.dart`
- `test/domain/models/approval_models_test.dart`
- `test/domain/models/dashboard_models_test.dart`
- `test/domain/models/visitor_models_test.dart`

**Description:**
Create unit tests for all domain models:
- Test JSON serialization
- Test validation
- Test equality
- Test copyWith

**Acceptance Criteria:**
- All domain models have unit tests
- Test coverage > 80%
- All tests pass

**Estimated Effort:** 2 days

---

#### Task N.2: Repository Tests

**Files to Create:**
- `test/data/repositories/jwt_auth_repository_test.dart`
- `test/data/repositories/qr_operations_repository_test.dart`
- `test/data/repositories/approval_repository_test.dart`
- `test/data/repositories/dashboard_repository_test.dart`
- `test/data/repositories/lookup_repository_test.dart`

**Description:**
Create unit tests for all repositories:
- Test API calls
- Test error handling
- Test data parsing
- Use mock API client

**Acceptance Criteria:**
- All repositories have unit tests
- Test coverage > 70%
- All tests pass

**Estimated Effort:** 2 days

---

#### Task N.3: Widget Tests

**Files to Create:**
- `test/features/auth/login_screen_test.dart`
- `test/features/scanner/scanner_screen_test.dart`
- `test/features/approvals/approvals_screen_test.dart`
- `test/features/dashboard/dashboard_screen_test.dart`

**Description:**
Create widget tests for key screens:
- Test UI rendering
- Test user interactions
- Test state changes
- Use mock controllers

**Acceptance Criteria:**
- Key screens have widget tests
- Test coverage > 60%
- All tests pass

**Estimated Effort:** 1.5 days

---

#### Task N.4: Integration Tests

**Files to Create:**
- `integration_test/app_test.dart`
- `integration_test/auth_flow_test.dart`
- `integration_test/qr_flow_test.dart`
- `integration_test/approval_flow_test.dart`

**Description:**
Create integration tests for critical flows:
- Test authentication flow
- Test QR scan flow
- Test approval flow
- Use test backend or mock backend

**Acceptance Criteria:**
- Critical flows have integration tests
- All tests pass
- Flows work end-to-end

**Estimated Effort:** 1.5 days

---

## 4. Low Priority Tasks

### 4.1 Phase L: Offline Strategy Review

**Priority:** LOW
**Estimated Effort:** 1-2 days
**Dependencies:** None
**Risk Level:** LOW

#### Task L.1: Generate Offline Strategy Document

**Files to Create:**
- `docs/mobile/OFFLINE_STRATEGY.md`

**Description:**
Generate offline strategy document covering:
- Offline scan capabilities
- Offline approval capabilities
- Sync strategy
- Conflict resolution
- Data storage strategy

**Acceptance Criteria:**
- Offline strategy document created
- All aspects covered
- Recommendations provided

**Estimated Effort:** 1 day

---

### 4.2 Phase M: Push Notification Readiness

**Priority:** LOW
**Estimated Effort:** 1-2 days
**Dependencies:** None
**Risk Level:** LOW

#### Task M.1: Generate Push Notification Readiness Document

**Files to Create:**
- `docs/mobile/PUSH_NOTIFICATION_READINESS.md`

**Description:**
Generate push notification readiness document covering:
- Device registration
- Notification token management
- FCM readiness
- OneSignal readiness
- Integration strategy

**Acceptance Criteria:**
- Push notification readiness document created
- All aspects covered
- Recommendations provided

**Estimated Effort:** 1 day

---

### 4.3 Phase O: Performance Review

**Priority:** LOW
**Estimated Effort:** 2-3 days
**Dependencies:** All implementation phases
**Risk Level:** LOW

#### Task O.1: Performance Audit

**Description:**
Perform performance audit:
- Check for duplicate API calls
- Check for large payloads
- Check for rebuild loops
- Check for memory leaks
- Check for slow screens

**Acceptance Criteria:**
- Performance audit completed
- Issues identified
- Recommendations documented

**Estimated Effort:** 1 day

---

#### Task O.2: Performance Optimization

**Description:**
Implement performance optimizations:
- Fix duplicate API calls
- Optimize large payloads
- Fix rebuild loops
- Fix memory leaks
- Optimize slow screens

**Acceptance Criteria:**
- Performance issues resolved
- App performance improved
- No regressions

**Estimated Effort:** 1-2 days

---

## 5. Final Deliverables

### 5.1 Documentation Deliverables

**Priority:** HIGH
**Estimated Effort:** 2-3 days
**Dependencies:** All phases
**Risk Level:** LOW

#### Task 5.1.1: Generate UAT Checklist

**Files to Create:**
- `docs/mobile/UAT_CHECKLIST.md`

**Description:**
Generate UAT checklist covering:
- Authentication flow
- QR scan flow
- Approval flow
- Dashboard functionality
- Error handling
- Permission checks
- Performance

**Acceptance Criteria:**
- UAT checklist created
- All features covered
- Test cases documented

**Estimated Effort:** 1 day

---

#### Task 5.1.2: Generate Compatibility Matrix

**Files to Create:**
- `docs/mobile/COMPATIBILITY_MATRIX.md`

**Description:**
Generate compatibility matrix covering:
- API compatibility
- Model compatibility
- Feature compatibility
- Browser compatibility
- Device compatibility

**Acceptance Criteria:**
- Compatibility matrix created
- All aspects covered
- Gaps documented

**Estimated Effort:** 1 day

---

#### Task 5.1.3: Generate Final Report

**Files to Create:**
- `docs/mobile/FINAL_REPORT.md`

**Description:**
Generate final report covering:
- Architecture summary
- Migration summary
- API compatibility summary
- Authentication summary
- QR summary
- Approval summary
- Testing summary
- Technical debt
- Remaining risks

**Acceptance Criteria:**
- Final report created
- All sections covered
- Recommendations provided

**Estimated Effort:** 1 day

---

## 6. Migration Risks

### 6.1 Critical Risks

#### Risk 1: Authentication Migration Failure
**Description:** JWT authentication may not work correctly with backend
**Probability:** MEDIUM
**Impact:** CRITICAL
**Mitigation:**
- Thorough testing with backend team
- Implement fallback to session-based auth temporarily
- Have rollback plan ready

#### Risk 2: API Contract Changes
**Description:** Backend API contracts may change during migration
**Probability:** MEDIUM
**Impact:** HIGH
**Mitigation:**
- Freeze backend API before migration
- Use API versioning
- Implement backward compatibility where possible

#### Risk 3: Data Model Mismatches
**Description:** Data models may not match backend exactly
**Probability:** MEDIUM
**Impact:** HIGH
**Mitigation:**
- Use backend Pydantic schemas as source of truth
- Implement comprehensive validation
- Add logging for debugging

### 6.2 High Risks

#### Risk 4: QR Security Model Incompatibility
**Description:** QR security model may not be compatible with Flutter implementation
**Probability:** LOW
**Impact:** HIGH
**Mitigation:**
- Work closely with backend team on QR security
- Implement comprehensive QR validation
- Add extensive logging

#### Risk 5: Permission System Complexity
**Description:** Permission system may be too complex to implement fully
**Probability:** MEDIUM
**Impact:** HIGH
**Mitigation:**
- Implement permission system incrementally
- Start with basic permission checks
- Add granular permissions over time

#### Risk 6: State Machine Validation Failures
**Description:** State machine validation may fail due to edge cases
**Probability:** MEDIUM
**Impact:** HIGH
**Mitigation:**
- Implement comprehensive state machine testing
- Add detailed error messages
- Work with backend team on validation rules

### 6.3 Medium Risks

#### Risk 7: Performance Degradation
**Description:** New implementation may have performance issues
**Probability:** MEDIUM
**Impact:** MEDIUM
**Mitigation:**
- Implement performance monitoring
- Optimize critical paths
- Use caching where appropriate

#### Risk 8: Testing Coverage Gaps
**Description:** Testing may not cover all edge cases
**Probability:** MEDIUM
**Impact:** MEDIUM
**Mitigation:**
- Implement comprehensive test suite
- Use integration tests for critical flows
- Perform manual testing

### 6.4 Low Risks

#### Risk 9: UI/UX Regression
**Description:** UI/UX may regress during migration
**Probability:** LOW
**Impact:** MEDIUM
**Mitigation:**
- Preserve existing UI components
- Perform UI testing
- Get user feedback

#### Risk 10: Dependency Conflicts
**Description:** New dependencies may conflict with existing ones
**Probability:** LOW
**Impact:** LOW
**Mitigation:**
- Test dependency compatibility
- Use dependency resolution tools
- Update dependencies carefully

---

## 7. Implementation Timeline

### 7.1 Week 1-2: Critical Foundation
- Phase D: Authentication Migration (5-7 days)
- Phase E: API Client Migration (3-5 days)

**Milestone:** Authentication and API layer complete

### 7.2 Week 3: Model Mapping
- Phase F: Model Mapping (3-4 days)

**Milestone:** All data models aligned with backend

### 7.3 Week 4-5: Core Features
- Phase G: QR Flow Migration (4-5 days)
- Phase H: Approval Flow Migration (4-5 days)

**Milestone:** QR and approval workflows complete

### 7.4 Week 6: Additional Features
- Phase I: Dashboard Migration (5-7 days)
- Phase J: Lookup Optimization (2-3 days)
- Phase K: Error Contract (2-3 days)

**Milestone:** Additional features complete

### 7.5 Week 7-8: Testing & Documentation
- Phase N: Testing (5-7 days)
- Phase L: Offline Strategy Review (1-2 days)
- Phase M: Push Notification Readiness (1-2 days)
- Final Deliverables (2-3 days)

**Milestone:** Testing complete, documentation ready

### 7.6 Week 9-10: Performance & Polish
- Phase O: Performance Review (2-3 days)
- Bug fixes and polish
- UAT preparation

**Milestone:** Production ready

---

## 8. Success Criteria

### 8.1 Technical Success Criteria

- [ ] Application builds successfully
- [ ] Application runs successfully on target platforms
- [ ] Authentication works with JWT backend
- [ ] All API calls use vms_sa backend
- [ ] QR workflow follows backend security model
- [ ] Approval workflow follows backend workflow
- [ ] Dashboard functionality works correctly
- [ ] Permission checks enforced throughout app
- [ ] Error handling matches backend error contract
- [ ] No ERPNext/Frappe dependencies remain
- [ ] Test coverage > 70%
- [ ] Performance meets requirements

### 8.2 Functional Success Criteria

- [ ] Users can login with JWT authentication
- [ ] Users can scan QR codes with resolve → execute pattern
- [ ] Users can approve/reject visit requests
- [ ] Users can view dashboards based on role
- [ ] Users can search for employees, departments, gates, visit purposes
- [ ] Error messages are user-friendly
- [ ] App handles network failures gracefully
- [ ] App handles token expiration gracefully

### 8.3 Documentation Success Criteria

- [ ] AUDIT_REPORT.md complete
- [ ] GAP_ANALYSIS.md complete
- [ ] IMPLEMENTATION_PLAN.md complete
- [ ] OFFLINE_STRATEGY.md complete
- [ ] PUSH_NOTIFICATION_READINESS.md complete
- [ ] UAT_CHECKLIST.md complete
- [ ] COMPATIBILITY_MATRIX.md complete
- [ ] FINAL_REPORT complete

---

## 9. Resource Requirements

### 9.1 Development Resources

- **Flutter Developer:** 1 full-time equivalent (FTE)
- **Backend Developer:** 0.5 FTE (for API support)
- **QA Engineer:** 0.5 FTE (for testing)
- **UI/UX Designer:** 0.25 FTE (for UI adaptations)

### 9.2 Infrastructure Resources

- **Development Backend:** vms_sa backend instance
- **Test Backend:** vms_sa backend instance (test data)
- **CI/CD Pipeline:** For automated testing and deployment
- **Test Devices:** iOS and Android devices for testing

### 9.3 Tools and Resources

- **Flutter SDK:** Latest stable version
- **IDE:** VS Code or Android Studio
- **Backend API Documentation:** vms_sa OpenAPI/Swagger docs
- **Testing Tools:** Flutter test, integration_test
- **Version Control:** Git

---

## 10. Next Steps

1. **Review and Approve Implementation Plan:** Get stakeholder approval
2. **Set Up Development Environment:** Configure development backend and tools
3. **Begin Phase D - Authentication Migration:** Start with critical foundation
4. **Weekly Progress Reviews:** Track progress and adjust plan as needed
5. **Continuous Testing:** Test each phase before moving to next

---

**Report Generated:** June 11, 2026
**Next Review:** After Phase D completion
**Estimated Completion:** 7-10 weeks from start
