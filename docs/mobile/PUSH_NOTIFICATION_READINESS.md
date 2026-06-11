# Push Notification Readiness

## Overview
This document evaluates the readiness of the migrated Flutter VMS application for push notification integration and provides recommendations for implementation.

---

## Current State

### Legacy Implementation (mobilevms_sa/reference)
The legacy Flutter reference implementation does NOT include push notification functionality:
- **Status**: Not implemented
- **Dependencies**: None
- **Backend Integration**: None

### New Implementation (mobilevms_sa)
The new production Flutter app currently does NOT include push notification functionality:
- **Status**: Not implemented
- **Dependencies**: None
- **Backend Integration**: None

---

## Business Requirements

### Use Cases for Push Notifications

#### Use Case 1: Approval Notifications
**Description**: Notify approvers when a visit request requires their approval.

**Trigger**: New approval task assigned to user
**Priority**: High
**Frequency**: As needed

**Content**:
- Visitor name
- Visit purpose
- Scheduled time
- Action: Approve/Reject

#### Use Case 2: Check-in Notifications
**Description**: Notify hosts when their visitor has checked in.

**Trigger**: Visitor check-in completed
**Priority**: Medium
**Frequency**: As needed

**Content**:
- Visitor name
- Check-in time
- Location/Gate

#### Use Case 3: Check-out Notifications
**Description**: Notify hosts when their visitor has checked out.

**Trigger**: Visitor check-out completed
**Priority**: Low
**Frequency**: As needed

**Content**:
- Visitor name
- Check-out time
- Visit duration

#### Use Case 4: Approval Decision Notifications
**Description**: Notify requesters when their visit request is approved or rejected.

**Trigger**: Approval decision made
**Priority**: High
**Frequency**: As needed

**Content**:
- Decision (Approved/Rejected)
- Reason (if rejected)
- Next steps

#### Use Case 5: Security Alerts
**Description**: Notify security personnel of security events.

**Trigger**: Security event detected
**Priority**: High
**Frequency**: As needed

**Content**:
- Event type
- Location
- Time
- Action required

---

## Technical Architecture

### Push Notification Providers

#### Option 1: Firebase Cloud Messaging (FCM)
**Description**: Google's push notification service for Android and iOS.

**Pros**:
- Free tier available
- Well-documented
- Cross-platform support
- Rich notification support
- Good delivery reliability

**Cons**:
- Requires Firebase project setup
- Google dependency
- Requires APNs setup for iOS
- Configuration complexity

**Effort**: Medium (1-2 weeks)
**Recommendation**: Recommended for production

#### Option 2: OneSignal
**Description**: Third-party push notification service.

**Pros**:
- Easy to implement
- Cross-platform support
- Rich analytics
- Segmentation support
- Good documentation

**Cons**:
- Cost for high volume
- Third-party dependency
- Limited free tier
- Data privacy concerns

**Effort**: Low (1 week)
**Recommendation**: Alternative option

#### Option 3: AWS SNS
**Description**: Amazon's push notification service.

**Pros**:
- Scalable
- AWS ecosystem integration
- Cost-effective at scale
- Multi-platform support

**Cons**:
- Complex setup
- AWS dependency
- Steeper learning curve
- Less developer-friendly

**Effort**: High (2-3 weeks)
**Recommendation**: For enterprise deployments

### Recommended Architecture: Firebase Cloud Messaging

#### Flutter Client
```
firebase_messaging
├── Initialize FCM
├── Request permissions
├── Handle foreground messages
├── Handle background messages
├── Token management
└── Notification display
```

#### Backend Integration
```
vms_sa Backend
├── FCM server SDK
├── Device token storage
├── Notification service
├── Notification templates
└── Delivery tracking
```

---

## Implementation Plan

### Phase 1: Client-Side Setup (1 week)

#### Tasks
1. **Add Dependencies**
   - `firebase_core` for Firebase initialization
   - `firebase_messaging` for push notifications
   - `flutter_local_notifications` for local notification display

2. **Firebase Configuration**
   - Create Firebase project
   - Add Android app to Firebase
   - Add iOS app to Firebase
   - Download configuration files (google-services.json, GoogleService-Info.plist)
   - Configure FCM in Firebase console

3. **Flutter Implementation**
   - Initialize Firebase in main.dart
   - Request notification permissions
   - Get FCM token
   - Handle foreground messages
   - Handle background messages
   - Display local notifications
   - Send token to backend

#### Code Structure
```dart
lib/core/notifications/
├── notification_service.dart
├── fcm_service.dart
└── local_notification_service.dart
```

### Phase 2: Backend Integration (1-2 weeks)

#### Tasks
1. **Add Dependencies**
   - Firebase Admin SDK for Python
   - Database schema for device tokens

2. **Database Schema**
```sql
CREATE TABLE device_tokens (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    token TEXT NOT NULL UNIQUE,
    platform TEXT NOT NULL,
    app_version TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

3. **Backend Implementation**
   - Device token registration endpoint
   - Device token management (CRUD)
   - Notification service
   - Notification templates
   - Delivery tracking

#### API Endpoints
```
POST /api/v1/notifications/register-device
PUT /api/v1/notifications/device-tokens/{id}
DELETE /api/v1/notifications/device-tokens/{id}
GET /api/v1/notifications/device-tokens
```

### Phase 3: Notification Triggers (1 week)

#### Tasks
1. **Approval Assignment**
   - Trigger when approval task is created
   - Send notification to approver
   - Include visit details

2. **Approval Decision**
   - Trigger when decision is made
   - Send notification to requester
   - Include decision and reason

3. **Check-in Event**
   - Trigger when visitor checks in
   - Send notification to host
   - Include visitor and location details

4. **Check-out Event**
   - Trigger when visitor checks out
   - Send notification to host
   - Include visitor and duration

5. **Security Alerts**
   - Trigger on security events
   - Send notification to security personnel
   - Include event details

### Phase 4: Testing (1 week)

#### Tasks
1. **Unit Tests**
   - Test notification service
   - Test FCM token management
   - Test local notification display

2. **Integration Tests**
   - Test end-to-end notification flow
   - Test backend notification sending
   - Test client notification receiving

3. **Manual Tests**
   - Test on Android device
   - Test on iOS device
   - Test foreground notifications
   - Test background notifications
   - Test notification tap handling

---

## Security Considerations

### Token Security
- Device tokens should be stored securely
- Tokens should be transmitted over HTTPS
- Tokens should be validated on the backend
- Old tokens should be removed

### Data Privacy
- Notification content should not contain sensitive PII
- User consent should be obtained before enabling notifications
- Users should be able to opt-out
- Notification logs should be retained according to policy

### Authentication
- Notification should not bypass authentication
- Sensitive actions should require re-authentication
- Notification payload should be validated
- Deep links should be protected

---

## User Experience

### Permission Request
- Request permission at appropriate time (e.g., after login)
- Explain why notifications are needed
- Allow user to decline
- Provide option to enable later in settings

### Notification Content
- Clear and concise
- Actionable information
- Relevant to user role
- Not overwhelming

### Notification Settings
- Allow users to customize notification preferences
- Allow users to opt-out of specific notification types
- Allow users to set quiet hours
- Allow users to manage notification channels

### Notification Handling
- Tap should navigate to relevant screen
- Dismiss should clear notification
- Swipe actions (approve/reject) where appropriate
- Group similar notifications

---

## Backend Requirements

### Database Changes
```sql
-- Device tokens table
CREATE TABLE device_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT NOT NULL, -- 'ios', 'android'
    app_version TEXT,
    device_info JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, token)
);

-- Index for lookups
CREATE INDEX idx_device_tokens_user_id ON device_tokens(user_id);
CREATE INDEX idx_device_tokens_token ON device_tokens(token);
CREATE INDEX idx_device_tokens_active ON device_tokens(is_active) WHERE is_active = TRUE;

-- Notification logs table (optional)
CREATE TABLE notification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    notification_type TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB,
    sent_at TIMESTAMP DEFAULT NOW(),
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    status TEXT DEFAULT 'pending'
);
```

### Python Dependencies
```python
firebase-admin==6.3.0
pydantic==2.5.0
```

### Service Implementation
```python
# app/services/notification_service.py
class NotificationService:
    def __init__(self, firebase_app):
        self.messaging = firebase_messaging.Client(firebase_app)
    
    async def send_notification(
        self,
        token: str,
        title: str,
        body: str,
        data: dict = None,
    ):
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=token,
            data=data,
        )
        await self.messaging.send(message)
```

---

## Flutter Implementation Details

### Dependencies
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^16.3.0
```

### Configuration

#### Android (android/app/build.gradle)
```gradle
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

### Service Implementation
```dart
// lib/core/notifications/fcm_service.dart
class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    // Send token to backend
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Display local notification
  }

  void _handleMessageOpened(RemoteMessage message) {
    // Navigate to relevant screen
  }
}
```

---

## Testing Strategy

### Unit Tests
- Test FCM service initialization
- Test token management
- Test local notification display
- Test notification parsing

### Integration Tests
- Test notification registration
- Test notification sending from backend
- Test notification receiving on client
- Test notification tap handling

### Manual Tests
- Test on real Android device
- Test on real iOS device
- Test with app in foreground
- Test with app in background
- Test with app terminated
- Test notification permissions
- Test notification settings

---

## Monitoring and Analytics

### Metrics to Track
- Notification delivery rate
- Notification open rate
- Notification click-through rate
- Notification errors
- Device token registration rate
- Opt-out rate

### Logging
- Log all notification sends
- Log notification delivery status
- Log notification opens
- Log errors with context

### Alerts
- Alert on high notification failure rate
- Alert on high error rate
- Alert on unusual opt-out patterns

---

## Recommendations

### Short Term (MVP)
**Recommendation**: Do not implement push notifications for MVP

**Rationale**:
- MVP focuses on core functionality
- Push notifications add complexity
- Backend changes required
- Testing overhead
- Can be added in Phase 2

### Medium Term (Phase 2)
**Recommendation**: Implement FCM for critical notifications

**Rationale**:
- Approval notifications are high value
- Security alerts are important
- Improves user engagement
- Competitive advantage

**Priority Notifications**:
1. Approval assignments
2. Approval decisions
3. Security alerts

**Effort**: 3-4 weeks

### Long Term (Phase 3)
**Recommendation**: Full notification suite with customization

**Rationale**:
- Complete user experience
- User control over notifications
- Advanced features (scheduled, grouped)

**Additional Features**:
- Check-in/check-out notifications
- Notification preferences
- Notification history
- Rich notifications with images
- Notification analytics dashboard

**Effort**: 2-3 weeks

---

## Conclusion

### Current Readiness
The Flutter app is **not ready** for push notifications. Significant implementation is required on both client and backend.

### Recommended Approach
For MVP, push notifications should be **deferred** to Phase 2. The focus should be on core functionality (authentication, QR scanning, approvals).

### Implementation Readiness Checklist
- [ ] Firebase project created
- [ ] Firebase configuration files added
- [ ] Flutter dependencies added
- [ ] Firebase initialized in app
- [ ] Permission handling implemented
- [ ] FCM token management implemented
- [ ] Local notification display implemented
- [ ] Backend Firebase Admin SDK added
- [ ] Device token storage implemented
- [ ] Notification service implemented
- [ ] Notification triggers implemented
- [ ] Testing completed
- [ ] Monitoring implemented

---

## Appendix

### A. Related Documents
- [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md)
- [AUDIT_REPORT.md](./AUDIT_REPORT.md)
- [GAP_ANALYSIS.md](./GAP_ANALYSIS.md)

### B. Firebase Setup Guide
1. Go to Firebase Console (console.firebase.google.com)
2. Create new project
3. Add Android app
   - Download google-services.json
   - Place in android/app/
4. Add iOS app
   - Download GoogleService-Info.plist
   - Place in ios/Runner/
5. Enable Cloud Messaging
6. Get server key for backend

### C. Notification Templates
```json
{
  "approval_assigned": {
    "title": "New Approval Required",
    "body": "Visitor {visitor_name} requires approval for {purpose}",
    "data": {
      "type": "approval",
      "visit_request_id": "{id}"
    }
  },
  "approval_approved": {
    "title": "Visit Approved",
    "body": "Your visit request for {visitor_name} has been approved",
    "data": {
      "type": "approval_decision",
      "decision": "approved",
      "visit_request_id": "{id}"
    }
  },
  "approval_rejected": {
    "title": "Visit Rejected",
    "body": "Your visit request for {visitor_name} was rejected: {reason}",
    "data": {
      "type": "approval_decision",
      "decision": "rejected",
      "visit_request_id": "{id}"
    }
  }
}
```
