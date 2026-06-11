# Gap Analysis Report

**Project:** VMS Mobile Migration
**Date:** June 11, 2026
**Phase:** Phase B - Gap Analysis
**Status:** In Progress

---

## Executive Summary

This gap analysis compares the source of truth backend (vms_sa) against the reference Flutter implementation (mobilevms_sa/reference) to identify all gaps that must be addressed during migration.

**Critical Finding:** The reference implementation is tightly coupled to ERPNext/Frappe with significant architectural differences that require complete replacement of authentication, API client, and data models. The migration is essentially a rewrite of the data layer while preserving the UI/UX and architectural patterns.

---

## 1. Authentication Gaps

### 1.1 Authentication Mechanism

| Aspect | Backend (vms_sa) | Flutter Reference | Gap |
|--------|------------------|-------------------|-----|
| **Authentication Type** | JWT (Access + Refresh Tokens) | ERPNext Session (Cookies) | COMPLETE MISMATCH |
| **Login Endpoint** | POST /api/v1/auth/login | POST /api/method/login (form-encoded) | COMPLETE MISMATCH |
| **Login Request** | {username, password, company_code, device_id} | {usr, pwd} | MISSING: company_code, device_id |
| **Login Response** | {access_token, refresh_token, token_type, expires_in, user} | {home_page} + session cookie | COMPLETE MISMATCH |
| **Token Storage** | Secure storage (access_token + refresh_token) | Cookie jar + CSRF token | COMPLETE MISMATCH |
| **Token Refresh** | POST /api/v1/auth/refresh | Not applicable (session-based) | MISSING: Token refresh |
| **Session Validation** | JWT validation + Redis check | GET /api/method/frappe.auth.get_logged_user | COMPLETE MISMATCH |
| **Logout** | POST /api/v1/auth/logout (invalidate refresh token) | POST /api/method/logout | DIFFERENT IMPLEMENTATION |
| **Password Change** | POST /api/v1/auth/change-password | Not implemented | MISSING FEATURE |
| **User Profile** | GET /api/v1/auth/me | GET /api/resource/User/{id} | DIFFERENT ENDPOINT |
| **Account Lockout** | Yes (after failed attempts) | Not implemented | MISSING FEATURE |
| **MFA Support** | Yes (mfa_enabled flag) | Not implemented | MISSING FEATURE |

**Gap Severity:** CRITICAL
**Migration Effort:** HIGH - Complete authentication layer replacement required

### 1.2 Authorization & RBAC

| Aspect | Backend (vms_sa) | Flutter Reference | Gap |
|--------|------------------|-------------------|-----|
| **Authorization Model** | Role-Based Access Control (RBAC) | Basic role list | MISSING: Permission checks |
| **Roles** | Multiple roles per user | Single role list | MISSING: Multi-role support |
| **Permissions** | Granular permission codes | Not implemented | MISSING: Permission system |
| **Permission Enforcement** | Backend + UI (require_permission) | Not implemented | MISSING: UI permission checks |
| **Company Isolation** | Yes (company_id in JWT) | Not implemented | MISSING: Multi-tenant support |
| **User Info** | {id, username, email, full_name, phone, language, company_id, company_name, roles, permissions, last_login_at, mfa_enabled} | {userId, fullName, roles} | MISSING: Most fields |

**Gap Severity:** HIGH
**Migration Effort:** HIGH - Implement permission-based UI rendering

---

## 2. API Endpoint Gaps

### 2.1 Authentication Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| POST /api/v1/auth/login | POST /api/method/login | REPLACE |
| POST /api/v1/auth/refresh | Not implemented | IMPLEMENT |
| POST /api/v1/auth/logout | POST /api/method/logout | REPLACE |
| GET /api/v1/auth/me | GET /api/resource/User/{id} | REPLACE |
| POST /api/v1/auth/change-password | Not implemented | IMPLEMENT |

### 2.2 QR Operations Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| POST /api/v1/qr-operations/qr-codes/generate | Not implemented | IMPLEMENT |
| GET /api/v1/qr-operations/qr-codes/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/qr-operations/qr-codes/{id}/revoke | Not implemented | IMPLEMENT |
| POST /api/v1/qr-operations/scans/resolve | POST /api/method/visitor_management.mobile.resolve_scan_action | REPLACE |
| POST /api/v1/qr-operations/scans/execute | POST /api/method/visitor_management.mobile.execute_scan_action | REPLACE |
| POST /api/v1/qr-operations/visits/{id}/check-out | Not implemented (part of execute) | IMPLEMENT |
| POST /api/v1/qr-operations/visits/{id}/complete | Not implemented | IMPLEMENT |
| GET /api/v1/qr-operations/visitor-logs | Not implemented | IMPLEMENT |
| GET /api/v1/qr-operations/visitor-logs/{id} | Not implemented | IMPLEMENT |

### 2.3 Approval Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/approvals/tasks | GET /api/method/visitor_management.mobile.get_pending_approvals | REPLACE |
| GET /api/v1/approvals/tasks/pending | Not implemented | IMPLEMENT |
| GET /api/v1/approvals/tasks/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/approvals/tasks/{id}/approve | POST /api/method/visitor_management.mobile.submit_approval | REPLACE |
| POST /api/v1/approvals/tasks/{id}/reject | POST /api/method/visitor_management.mobile.submit_approval | REPLACE |
| POST /api/v1/approvals/tasks/{id}/cancel | Not implemented | IMPLEMENT |
| GET /api/v1/approvals/decisions | Not implemented | IMPLEMENT |
| GET /api/v1/approvals/decisions/{id} | Not implemented | IMPLEMENT |

### 2.4 Dashboard Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/dashboard/security | Not implemented | IMPLEMENT |
| GET /api/v1/dashboard/reception | Not implemented | IMPLEMENT |
| GET /api/v1/dashboard/manager | Not implemented | IMPLEMENT |
| GET /api/v1/dashboard/hr | Not implemented | IMPLEMENT |
| GET /api/v1/dashboard/executive | Not implemented | IMPLEMENT |

### 2.5 Lookup Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/lookups/departments | Not implemented | IMPLEMENT |
| GET /api/v1/lookups/employees | Not implemented | IMPLEMENT |
| GET /api/v1/lookups/gates | Not implemented | IMPLEMENT |
| GET /api/v1/lookups/visit-purposes | Not implemented | IMPLEMENT |

### 2.6 Visitor Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/visitors | Not implemented | IMPLEMENT |
| GET /api/v1/visitors/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/visitors | Not implemented | IMPLEMENT |
| PUT /api/v1/visitors/{id} | Not implemented | IMPLEMENT |
| DELETE /api/v1/visitors/{id} | Not implemented | IMPLEMENT |

### 2.7 Visit Request Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/visit-requests | Not implemented | IMPLEMENT |
| GET /api/v1/visit-requests/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/visit-requests | Not implemented | IMPLEMENT |
| PUT /api/v1/visit-requests/{id} | Not implemented | IMPLEMENT |
| DELETE /api/v1/visit-requests/{id} | Not implemented | IMPLEMENT |

### 2.8 Employee Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/employees | Not implemented | IMPLEMENT |
| GET /api/v1/employees/{id} | Not implemented | IMPLEMENT |

### 2.9 Department Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/departments | Not implemented | IMPLEMENT |
| GET /api/v1/departments/{id} | Not implemented | IMPLEMENT |

### 2.10 Gate Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/gates | Not implemented | IMPLEMENT |
| GET /api/v1/gates/{id} | Not implemented | IMPLEMENT |

### 2.11 Notification Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/notifications | Not implemented | IMPLEMENT |
| GET /api/v1/notifications/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/notifications/{id}/mark-read | Not implemented | IMPLEMENT |

### 2.12 Report Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/reports | Not implemented | IMPLEMENT |
| POST /api/v1/reports/exports | Not implemented | IMPLEMENT |

### 2.13 File Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| POST /api/v1/files/upload | Not implemented | IMPLEMENT |
| GET /api/v1/files/{id} | Not implemented | IMPLEMENT |

### 2.14 Badge Endpoints

| Backend Endpoint | Flutter Reference | Status |
|------------------|-------------------|--------|
| GET /api/v1/badges | Not implemented | IMPLEMENT |
| GET /api/v1/badges/{id} | Not implemented | IMPLEMENT |
| POST /api/v1/badges/{id}/print | Not implemented | IMPLEMENT |

### 2.15 Additional Flutter Reference Endpoints (Not in Backend)

| Flutter Reference Endpoint | Backend Equivalent | Status |
|----------------------------|-------------------|--------|
| GET /api/method/visitor_management.visitor_management.api.get_visitor_by_qr | POST /api/v1/qr-operations/scans/resolve | REPLACE |
| GET /api/method/visitor_management.mobile.get_active_visitors | GET /api/v1/visitors (with filter) | REPLACE |
| GET /api/method/visitor_management.mobile.get_recent_activity | GET /api/v1/qr-operations/visitor-logs | REPLACE |

**Gap Severity:** CRITICAL
**Migration Effort:** HIGH - All API endpoints must be replaced

---

## 3. Data Model Gaps

### 3.1 Authentication Models

| Backend Model | Flutter Reference | Gap |
|---------------|-------------------|-----|
| **LoginRequest** | {username, password, company_code, device_id} | {usr, pwd} | MISSING: company_code, device_id |
| **TokenResponse** | {access_token, refresh_token, token_type, expires_in, user} | {home_page} | COMPLETE MISMATCH |
| **UserBasicInfo** | {id, username, email, full_name, language, company_id, roles, permissions} | {userId, fullName, roles} | MISSING: Most fields |
| **MeResponse** | {id, username, email, full_name, phone, language, company_id, company_name, roles, permissions, last_login_at, mfa_enabled} | Not implemented | MISSING: Complete model |
| **RefreshRequest** | {refresh_token} | Not implemented | MISSING |
| **ChangePasswordRequest** | {old_password, new_password} | Not implemented | MISSING |
| **LogoutRequest** | {refresh_token} | Not implemented | MISSING |

### 3.2 QR Operation Models

| Backend Model | Flutter Reference | Gap |
|---------------|-------------------|-----|
| **QRCodeResponse** | {id, company_id, visit_id, visit_request_id, token_id, status, issued_at, expires_at, used_at, scan_count} | Not implemented | MISSING |
| **QRCodeGenerateRequest** | {visit_id, expires_in_minutes} | Not implemented | MISSING |
| **QRCodeGenerateResponse** | {qr_code, raw_token} | Not implemented | MISSING |
| **ScanResolveRequest** | {token} | {qr_code} | FIELD NAME DIFFERENT |
| **ScanResolveResponse** | {valid, visitor, visit, warnings} | {entity_type, current_status, next_action, visitor_name, company, employee_name, reference_id} | DIFFERENT STRUCTURE |
| **ScanExecuteRequest** | {token, gate_id, gate_device_id, notes} | {qr_code, action} | DIFFERENT STRUCTURE |
| **CheckInEventResponse** | {id, visit_id, visit_request_id, visitor_id, company_id, gate_id, gate_device_id, performed_by, qr_code_id, checked_in_at, method, notes} | Not implemented | MISSING |
| **CheckOutEventResponse** | {id, visit_id, visit_request_id, visitor_id, company_id, gate_id, gate_device_id, performed_by, qr_code_id, checked_out_at, method, notes} | Not implemented | MISSING |
| **CheckOutRequest** | {gate_id, gate_device_id, notes} | Not implemented | MISSING |
| **VisitResponse** | {id, visit_request_id, visitor_id, host_employee_id, visit_purpose_id, scheduled_start_at, scheduled_end_at, status, created_at, updated_at} | Not implemented | MISSING |
| **VisitorLogResponse** | {id, visitor_id, visit_id, visit_request_id, company_id, event_type, event_time, performed_by, details} | Not implemented | MISSING |

### 3.3 Approval Models

| Backend Model | Flutter Reference | Gap |
|---------------|-------------------|-----|
| **ApprovalTaskResponse** | {id, company_id, visit_request_id, approver_user_id, approval_type, level, status, due_at, assigned_at, started_at, completed_at, escalated_from_id, notes, created_at, updated_at} | {id, visitor_name, host_name, purpose, requested_at} | COMPLETE MISMATCH |
| **ApprovalTaskApproveRequest** | {reason, comments} | {approval_id, action: approve} | DIFFERENT STRUCTURE |
| **ApprovalTaskRejectRequest** | {reason, comments} | {approval_id, action: reject, reason} | DIFFERENT STRUCTURE |
| **ApprovalDecisionResponse** | {id, approval_task_id, decided_by, decision, reason, comments, decided_at, metadata_json, created_at} | Not implemented | MISSING |

### 3.4 Dashboard Models

| Backend Model | Flutter Reference | Gap |
|---------------|-------------------|-----|
| **SecurityDashboardMetrics** | Not implemented | MISSING |
| **ReceptionDashboardMetrics** | Not implemented | MISSING |
| **ManagerDashboardMetrics** | Not implemented | MISSING |
| **HRDashboardMetrics** | Not implemented | MISSING |
| **ExecutiveDashboardMetrics** | Not implemented | MISSING |

### 3.5 Lookup Models

| Backend Model | Flutter Reference | Gap |
|---------------|-------------------|-----|
| **DepartmentLookupResponse** | Not implemented | MISSING |
| **EmployeeLookupResponse** | Not implemented | MISSING |
| **GateLookupResponse** | Not implemented | MISSING |
| **VisitPurposeLookupResponse** | Not implemented | MISSING |

**Gap Severity:** CRITICAL
**Migration Effort:** HIGH - All data models must be updated

---

## 4. Workflow Gaps

### 4.1 QR Workflow

#### Backend QR Workflow
```
1. Generate QR Code (POST /qr-codes/generate)
   - Input: visit_id, expires_in_minutes
   - Output: qr_code + raw_token (JWT)
   - Security: JWT signed token with visit/visitor info

2. Resolve Scan (POST /scans/resolve)
   - Input: raw_token
   - Output: valid, visitor, visit, warnings
   - Purpose: Preview without execution
   - Security: Validates QR, checks visit status, returns warnings

3. Execute Check-In (POST /scans/execute)
   - Input: raw_token, gate_id, gate_device_id, notes
   - Output: CheckInEvent
   - Validation: QR valid, visit SCHEDULED, visitor not blacklisted, not already checked in
   - Actions: Create CheckInEvent, Update Visit to CHECKED_IN, Mark QR USED, Create VisitorLog

4. Check-Out (POST /visits/{id}/check-out)
   - Input: visit_id, gate_id, gate_device_id, notes
   - Output: CheckOutEvent
   - Validation: Visit CHECKED_IN
   - Actions: Create CheckOutEvent, Update Visit to CHECKED_OUT, Create VisitorLog

5. Complete Visit (POST /visits/{id}/complete)
   - Input: visit_id
   - Output: Visit
   - Validation: Visit CHECKED_OUT
   - Actions: Update Visit to COMPLETED, Create VisitorLog
   - Used by: Scheduler
```

#### Flutter Reference QR Workflow
```
1. Scan QR Code (mobile_scanner)
   - Output: raw_code string

2. Resolve Scan Action (POST /mobile.resolve_scan_action)
   - Input: qr_code
   - Output: entity_type, current_status, next_action, visitor_name, company, employee_name, reference_id
   - Purpose: Determine action (check-in/check-out)

3. Execute Scan Action (POST /mobile.execute_scan_action)
   - Input: qr_code, action
   - Output: status, message, reference_id
   - Actions: Execute determined action

4. Get Visitor Status (GET /get_visitor_by_qr)
   - Input: qr_data
   - Output: status
   - Purpose: Auto-detect check-in/out
```

**Gap Analysis:**
- Backend uses JWT-based QR tokens, Flutter reference uses raw QR strings
- Backend has explicit resolve → execute pattern, Flutter reference has similar pattern but different API
- Backend supports gate and gate_device tracking, Flutter reference does not
- Backend has comprehensive state machine validation, Flutter reference has basic validation
- Backend creates detailed event logs, Flutter reference has basic logging

**Gap Severity:** HIGH
**Migration Effort:** HIGH - QR workflow must be adapted to backend security model

### 4.2 Approval Workflow

#### Backend Approval Workflow
```
1. Create Approval Task (Service)
   - Input: company_id, visit_request_id, host_employee_id, department_id, due_hours, strategy_name
   - Process: Use assignment strategy to find approvers
   - Output: ApprovalTask
   - Actions: Create task, send notification to approver

2. List Approval Tasks (GET /tasks)
   - Input: approver_user_id, status, visit_request_id, date filters, pagination
   - Output: ApprovalTaskListResponse

3. List Pending Tasks (GET /tasks/pending)
   - Input: pagination
   - Output: ApprovalTaskListResponse (current user's pending tasks)

4. Get Approval Task (GET /tasks/{id})
   - Output: ApprovalTaskResponse

5. Approve Task (POST /tasks/{id}/approve)
   - Input: reason, comments
   - Validation: Task PENDING, user is assigned approver
   - Actions: Create ApprovalDecision, Update Task to APPROVED, Update VisitRequest to APPROVED, Create Visit, Send notification

6. Reject Task (POST /tasks/{id}/reject)
   - Input: reason (required), comments
   - Validation: Task PENDING, user is assigned approver
   - Actions: Create ApprovalDecision, Update Task to REJECTED, Update VisitRequest to REJECTED, Send notification

7. Cancel Task (POST /tasks/{id}/cancel)
   - Validation: Task PENDING
   - Actions: Update Task to CANCELLED

8. Expire Task (Scheduler)
   - Validation: Task PENDING
   - Actions: Update Task to EXPIRED, Update VisitRequest to EXPIRED

9. List Approval Decisions (GET /decisions)
   - Input: decided_by, approval_task_id, decision, date filters, pagination
   - Output: ApprovalDecisionListResponse

10. Get Approval Decision (GET /decisions/{id})
    - Output: ApprovalDecisionResponse
```

#### Flutter Reference Approval Workflow
```
1. Get Pending Approvals (GET /mobile.get_pending_approvals)
   - Output: [{id, visitor_name, host_name, purpose, requested_at}]

2. Approve (POST /mobile.submit_approval)
   - Input: approval_id, action: approve
   - Output: Success/Failure

3. Reject (POST /mobile.submit_approval)
   - Input: approval_id, action: reject, reason
   - Output: Success/Failure
```

**Gap Analysis:**
- Backend has comprehensive approval workflow with task lifecycle, Flutter reference has basic approve/reject
- Backend supports approval history and decisions, Flutter reference does not
- Backend has task assignment strategies, Flutter reference does not
- Backend has task expiration and cancellation, Flutter reference does not
- Backend sends notifications on approval actions, Flutter reference does not
- Backend updates visit request status and creates visits on approval, Flutter reference may not

**Gap Severity:** HIGH
**Migration Effort:** HIGH - Approval workflow must be fully implemented

### 4.3 Dashboard Workflow

#### Backend Dashboard Workflow
```
1. Get Security Dashboard (GET /dashboard/security)
   - Output: Security metrics (active visitors, pending approvals, today's check-ins, today's check-outs, alerts)
   - Caching: Redis cache support

2. Get Reception Dashboard (GET /dashboard/reception)
   - Output: Reception metrics (expected visitors, checked-in visitors, pending check-outs, gate activity)

3. Get Manager Dashboard (GET /dashboard/manager)
   - Output: Manager metrics (team visit requests, approval rate, visitor statistics)

4. Get HR Dashboard (GET /dashboard/hr)
   - Output: HR metrics (visitor trends, department statistics, compliance metrics)

5. Get Executive Dashboard (GET /dashboard/executive)
   - Output: Executive metrics (company-wide statistics, trends, KPIs)
```

#### Flutter Reference Dashboard Workflow
```
1. Dashboard Section Widget
   - Basic dashboard structure
   - No actual data fetching
```

**Gap Analysis:**
- Backend has 5 comprehensive dashboard types with metrics, Flutter reference has basic structure only
- Backend supports role-based dashboard access, Flutter reference does not
- Backend has caching for performance, Flutter reference does not

**Gap Severity:** MEDIUM
**Migration Effort:** MEDIUM - Dashboard implementation from scratch

---

## 5. ERPNext/Frappe Dependencies

### 5.1 Direct ERPNext Dependencies in Flutter Reference

| Dependency | Location | Usage |
|------------|----------|-------|
| **ERPNext Login** | auth_repository_impl.dart | POST /api/method/login |
| **ERPNext Session Validation** | auth_controller.dart | GET /api/method/frappe.auth.get_logged_user |
| **ERPNext CSRF Token** | auth_repository_impl.dart | GET /api/method/...get_csrf_token |
| **ERPNext User Profile** | auth_repository_impl.dart | GET /api/resource/User/{id} |
| **ERPNext Logout** | auth_repository_impl.dart | POST /api/method/logout |
| **Frappe API Methods** | operations_repository_impl.dart | All API calls use /api/method/ pattern |
| **Frappe Response Format** | operations_repository_impl.dart | Expects {message: ...} wrapper |
| **Cookie Management** | api_client.dart | CookieJar for session cookies |
| **CSRF Token Management** | api_client.dart | X-Frappe-CSRF-Token header |

### 5.2 ERPNext/Frappe Features Used

| Feature | Backend Equivalent | Migration Action |
|---------|-------------------|------------------|
| Session-based authentication | JWT authentication | REPLACE |
| Cookie management | Token storage | REPLACE |
| CSRF protection | JWT signature | REPLACE |
| /api/method/ endpoints | /api/v1/ endpoints | REPLACE |
| {message: ...} response format | Direct response | REPLACE |
| User resource endpoint | /auth/me endpoint | REPLACE |

**Gap Severity:** CRITICAL
**Migration Effort:** CRITICAL - Complete removal of ERPNext/Frappe dependencies required

---

## 6. Permission Differences

### 6.1 Backend Permission System

| Permission Code | Description |
|-----------------|-------------|
| `auth.login` | Login to system |
| `auth.refresh` | Refresh access token |
| `auth.logout` | Logout from system |
| `qr.generate` | Generate QR codes |
| `qr.read` | View QR codes |
| `qr.revoke` | Revoke QR codes |
| `scan.resolve` | Resolve QR scans (preview) |
| `scan.execute` | Execute QR scans (check-in) |
| `visit.checkout` | Check-out visitors |
| `visit.complete` | Complete visits |
| `visitor_log.read` | View visitor logs |
| `approvals.read` | View approval tasks |
| `approvals.approve` | Approve tasks |
| `approvals.reject` | Reject tasks |
| `approvals.cancel` | Cancel tasks |
| `dashboard.security.read` | View security dashboard |
| `dashboard.reception.read` | View reception dashboard |
| `dashboard.manager.read` | View manager dashboard |
| `dashboard.hr.read` | View HR dashboard |
| `dashboard.executive.read` | View executive dashboard |
| `department.read` | View departments |
| `employee.read` | View employees |
| `gate.read` | View gates |
| `visitor.read` | View visitors |
| `visitor.create` | Create visitors |
| `visitor.update` | Update visitors |
| `visitor.delete` | Delete visitors |

### 6.2 Flutter Reference Permission System

| Permission | Description |
|------------|-------------|
| Basic role list | ["Employee", "System Manager", etc.] |
| No granular permissions | Not implemented |

**Gap Analysis:**
- Backend has comprehensive permission system with 30+ permissions
- Flutter reference has basic role list only
- Backend enforces permissions at API level, Flutter reference does not
- Backend includes permissions in JWT token, Flutter reference does not

**Gap Severity:** HIGH
**Migration Effort:** HIGH - Implement permission-based UI rendering and API call authorization

---

## 7. Missing Screens

### 7.1 Backend Features Without Flutter Reference Screens

| Feature | Required Screens | Status |
|---------|-----------------|--------|
| **Password Change** | Change Password Screen | MISSING |
| **User Profile** | User Profile Screen | MISSING |
| **QR Code Generation** | QR Code Generation Screen | MISSING |
| **QR Code List** | QR Code List Screen | MISSING |
| **Approval History** | Approval History Screen | MISSING |
| **Approval Detail** | Approval Detail Screen | MISSING |
| **Security Dashboard** | Security Dashboard Screen | MISSING |
| **Reception Dashboard** | Reception Dashboard Screen | MISSING |
| **Manager Dashboard** | Manager Dashboard Screen | MISSING |
| **HR Dashboard** | HR Dashboard Screen | MISSING |
| **Executive Dashboard** | Executive Dashboard Screen | MISSING |
| **Visitor List** | Visitor List Screen | MISSING |
| **Visitor Detail** | Visitor Detail Screen | MISSING |
| **Visitor Create** | Visitor Create Screen | MISSING |
| **Visitor Edit** | Visitor Edit Screen | MISSING |
| **Visit Request List** | Visit Request List Screen | MISSING |
| **Visit Request Detail** | Visit Request Detail Screen | MISSING |
| **Visit Request Create** | Visit Request Create Screen | MISSING |
| **Visit Request Edit** | Visit Request Edit Screen | MISSING |
| **Employee List** | Employee List Screen | MISSING |
| **Employee Detail** | Employee Detail Screen | MISSING |
| **Department List** | Department List Screen | MISSING |
| **Gate List** | Gate List Screen | MISSING |
| **Notification List** | Notification List Screen | MISSING |
| **Notification Detail** | Notification Detail Screen | MISSING |
| **Reports** | Reports Screen | MISSING |
| **File Upload** | File Upload Screen | MISSING |
| **Badge Management** | Badge Management Screen | MISSING |
| **Visitor Logs** | Visitor Logs Screen | MISSING |

**Gap Severity:** MEDIUM
**Migration Effort:** MEDIUM - 25+ screens to implement

---

## 8. Deprecated APIs

### 8.1 Flutter Reference APIs to Deprecate

| API Endpoint | Replacement | Action |
|--------------|-------------|--------|
| POST /api/method/login | POST /api/v1/auth/login | DEPRECATE |
| GET /api/method/frappe.auth.get_logged_user | GET /api/v1/auth/me | DEPRECATE |
| GET /api/method/...get_csrf_token | Not needed (JWT) | DEPRECATE |
| GET /api/resource/User/{id} | GET /api/v1/auth/me | DEPRECATE |
| POST /api/method/logout | POST /api/v1/auth/logout | DEPRECATE |
| POST /api/method/visitor_management.mobile.resolve_scan_action | POST /api/v1/qr-operations/scans/resolve | DEPRECATE |
| POST /api/method/visitor_management.mobile.execute_scan_action | POST /api/v1/qr-operations/scans/execute | DEPRECATE |
| GET /api/method/visitor_management.visitor_management.api.get_visitor_by_qr | POST /api/v1/qr-operations/scans/resolve | DEPRECATE |
| GET /api/method/visitor_management.mobile.get_active_visitors | GET /api/v1/visitors (with filter) | DEPRECATE |
| GET /api/method/visitor_management.mobile.get_pending_approvals | GET /api/v1/approvals/tasks/pending | DEPRECATE |
| POST /api/method/visitor_management.mobile.submit_approval | POST /api/v1/approvals/tasks/{id}/approve or /reject | DEPRECATE |
| GET /api/method/visitor_management.mobile.get_recent_activity | GET /api/v1/qr-operations/visitor-logs | DEPRECATE |

**Gap Severity:** CRITICAL
**Migration Effort:** CRITICAL - All deprecated APIs must be replaced

---

## 9. Summary of Gaps

### 9.1 Critical Gaps (Must Fix)

1. **Authentication Mechanism** - Complete replacement from ERPNext session to JWT
2. **API Endpoints** - All 12+ API endpoints must be replaced
3. **Data Models** - All 20+ data models must be updated
4. **ERPNext Dependencies** - Complete removal required
5. **Permission System** - Implement granular permission checks

### 9.2 High Priority Gaps

1. **QR Workflow** - Adapt to backend security model
2. **Approval Workflow** - Implement full approval lifecycle
3. **RBAC Implementation** - Implement permission-based UI
4. **State Machine Validation** - Implement backend state transitions

### 9.3 Medium Priority Gaps

1. **Dashboard Implementation** - 5 dashboard types
2. **Missing Screens** - 25+ screens to implement
3. **Lookup Optimization** - Implement lookup endpoints
4. **Error Handling** - Implement centralized error handling

### 9.4 Low Priority Gaps

1. **UI/UX Adaptation** - Minor UI adjustments
2. **Dependency Updates** - Version updates
3. **Performance Optimization** - Post-migration optimization

---

## 10. Migration Complexity Assessment

### 10.1 Complexity Matrix

| Component | Complexity | Risk | Effort | Priority |
|-----------|------------|------|--------|----------|
| Authentication | HIGH | CRITICAL | HIGH | CRITICAL |
| API Client | HIGH | CRITICAL | HIGH | CRITICAL |
| Data Models | HIGH | CRITICAL | HIGH | CRITICAL |
| QR Workflow | MEDIUM | HIGH | HIGH | HIGH |
| Approval Workflow | MEDIUM | HIGH | HIGH | HIGH |
| RBAC/Permissions | MEDIUM | HIGH | MEDIUM | HIGH |
| Dashboard | MEDIUM | MEDIUM | MEDIUM | MEDIUM |
| Missing Screens | MEDIUM | MEDIUM | MEDIUM | MEDIUM |
| Lookup Services | LOW | LOW | LOW | MEDIUM |
| Error Handling | LOW | LOW | LOW | MEDIUM |

### 10.2 Estimated Effort

| Phase | Estimated Effort (Days) |
|-------|-------------------------|
| Phase D: Authentication Migration | 5-7 days |
| Phase E: API Client Migration | 3-5 days |
| Phase F: Model Mapping | 3-4 days |
| Phase G: QR Flow Migration | 4-5 days |
| Phase H: Approval Flow Migration | 4-5 days |
| Phase I: Dashboard Migration | 5-7 days |
| Phase J: Lookup Optimization | 2-3 days |
| Phase K: Error Contract | 2-3 days |
| Phase N: Testing | 5-7 days |
| Phase O: Performance Review | 2-3 days |
| **Total** | **35-49 days** |

---

## 11. Recommendations

### 11.1 Immediate Actions

1. **Start with Authentication (Phase D):** This is the critical blocker for all other work
2. **Create New API Client (Phase E):** Establish foundation for all API calls
3. **Update Data Models (Phase F):** Align with backend schemas

### 11.2 Migration Strategy

1. **Incremental Approach:** Migrate feature by feature to minimize risk
2. **Preserve UI/UX:** Reuse existing screens and widgets where possible
3. **Maintain Architecture:** Keep clean architecture from reference
4. **Test-Driven:** Write tests for each migrated component

### 11.3 Risk Mitigation

1. **Backend-First:** Ensure backend API is stable before Flutter implementation
2. **Mock Testing:** Use mock backend for Flutter testing
3. **Parallel Development:** Work on multiple features in parallel where possible
4. **Continuous Integration:** Set up CI/CD for automated testing

---

## 12. Next Steps

1. **Phase C - Implementation Plan:** Create detailed implementation plan with priorities
2. **Phase D - Authentication Migration:** Begin JWT authentication implementation
3. **Phase E - API Client Migration:** Create new API client layer
4. **Phase F - Model Mapping:** Update domain models

---

**Report Generated:** June 11, 2026
**Next Review:** After Phase C - Implementation Plan
