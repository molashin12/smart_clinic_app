# Firestore Database Schema for Smart Clinic Management App

This document outlines the comprehensive database schema for the Smart Clinic Management App using Firebase Firestore. The schema is designed to support multi-clinic management, role-based access control, offline-first capabilities, and real-time synchronization across platforms.

## Database Collections Overview

The database is structured with the following main collections:

1. `users` - User accounts and authentication information
2. `clinics` - Clinic information and settings
3. `patients` - Patient profiles and basic information
4. `appointments` - Appointment scheduling and management
5. `medical_records` - Patient medical history and visit records
6. `prescriptions` - Medication prescriptions and treatment plans
7. `reports` - Generated medical reports and referrals
8. `medications` - Common medications database
9. `settings` - Application settings and configurations
10. `analytics` - Usage statistics and reporting data

## Detailed Collection Structures

### 1. Users Collection

```
users/{userId}
```

**Fields:**
- `uid`: String - Firebase Auth UID
- `email`: String - User email address
- `phoneNumber`: String - User phone number
- `displayName`: String - Full name
- `photoURL`: String - Profile picture URL
- `role`: String - "doctor", "nurse", "receptionist", "pharmacist"
- `createdAt`: Timestamp - Account creation date
- `lastLogin`: Timestamp - Last login timestamp
- `isActive`: Boolean - Account status
- `subscriptionTier`: String - "free", "pro", "enterprise"
- `subscriptionExpiryDate`: Timestamp - When subscription expires
- `preferredLanguage`: String - "en", "ar", etc.
- `notificationSettings`: Map
  - `email`: Boolean
  - `sms`: Boolean
  - `push`: Boolean
- `clinicAccess`: Array<String> - IDs of clinics user has access to
- `fcmTokens`: Map - Device tokens for push notifications
  - `{deviceId}`: String - FCM token

**Sub-collections:**
- `users/{userId}/devices` - User's registered devices for sync

### 2. Clinics Collection

```
clinics/{clinicId}
```

**Fields:**
- `name`: String - Clinic name
- `address`: Map
  - `street`: String
  - `city`: String
  - `state`: String
  - `country`: String
  - `postalCode`: String
  - `coordinates`: GeoPoint - For location-based features
- `contactInfo`: Map
  - `phone`: String
  - `email`: String
  - `website`: String
- `ownerId`: String - Doctor/admin user ID who owns this clinic
- `logo`: String - Logo image URL
- `businessHours`: Map
  - `monday`: Map - `{start: "09:00", end: "17:00", closed: false}`
  - `tuesday`: Map - `{start: "09:00", end: "17:00", closed: false}`
  - ... (for all days)
- `appointmentSettings`: Map
  - `defaultDuration`: Number - Default appointment length in minutes
  - `bufferTime`: Number - Buffer time between appointments
  - `maxDailyAppointments`: Number - Optional limit
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `isActive`: Boolean
- `timezone`: String - e.g., "America/New_York"
- `currency`: String - e.g., "USD"
- `branding`: Map - Colors, fonts for reports/prescriptions

**Sub-collections:**
- `clinics/{clinicId}/staff` - Staff members associated with this clinic
- `clinics/{clinicId}/appointmentSlots` - Custom appointment slot configurations

### 3. Patients Collection

```
patients/{patientId}
```

**Fields:**
- `firstName`: String
- `lastName`: String
- `dateOfBirth`: Timestamp
- `gender`: String - "male", "female", "other"
- `contactInfo`: Map
  - `phone`: String
  - `email`: String
  - `alternatePhone`: String
- `address`: Map - Similar to clinic address structure
- `emergencyContact`: Map
  - `name`: String
  - `relationship`: String
  - `phone`: String
- `insuranceInfo`: Map
  - `provider`: String
  - `policyNumber`: String
  - `expiryDate`: Timestamp
- `allergies`: Array<String>
- `bloodType`: String
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `primaryDoctorId`: String - Reference to primary doctor
- `primaryClinicId`: String - Reference to primary clinic
- `profilePhoto`: String - URL to profile photo
- `notes`: String - General notes about patient
- `isActive`: Boolean

**Sub-collections:**
- `patients/{patientId}/medicalHistory` - Detailed medical history records
- `patients/{patientId}/attachments` - Documents, images, and other files
- `patients/{patientId}/visits` - Record of all visits across all clinics

### 4. Appointments Collection

```
appointments/{appointmentId}
```

**Fields:**
- `patientId`: String - Reference to patient
- `doctorId`: String - Reference to doctor
- `clinicId`: String - Reference to clinic
- `startTime`: Timestamp
- `endTime`: Timestamp
- `status`: String - "scheduled", "confirmed", "completed", "cancelled", "no-show"
- `type`: String - "regular", "follow-up", "emergency", "consultation"
- `reason`: String - Purpose of visit
- `notes`: String - Pre-appointment notes
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `createdBy`: String - User ID who created appointment
- `updatedBy`: String - User ID who last updated appointment
- `reminderSent`: Boolean
- `isRecurring`: Boolean
- `recurringPattern`: Map - For recurring appointments
  - `frequency`: String - "daily", "weekly", "monthly"
  - `interval`: Number - Every X days/weeks/months
  - `endDate`: Timestamp - When recurring appointments end
- `googleCalendarEventId`: String - For calendar sync
- `color`: String - For color-coding in calendar view

### 5. Medical Records Collection

```
medical_records/{recordId}
```

**Fields:**
- `patientId`: String - Reference to patient
- `doctorId`: String - Reference to doctor
- `clinicId`: String - Reference to clinic
- `appointmentId`: String - Reference to appointment (if applicable)
- `visitDate`: Timestamp
- `chiefComplaint`: String
- `diagnosis`: Array<String>
- `symptoms`: Array<String>
- `vitalSigns`: Map
  - `temperature`: Number
  - `bloodPressureSystolic`: Number
  - `bloodPressureDiastolic`: Number
  - `heartRate`: Number
  - `respiratoryRate`: Number
  - `oxygenSaturation`: Number
  - `weight`: Number
  - `height`: Number
  - `bmi`: Number
- `notes`: String - Detailed examination notes
- `treatmentPlan`: String
- `followUpInstructions`: String
- `followUpDate`: Timestamp
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `createdBy`: String - User ID who created record
- `updatedBy`: String - User ID who last updated record

**Sub-collections:**
- `medical_records/{recordId}/attachments` - Related documents, images, test results

### 6. Prescriptions Collection

```
prescriptions/{prescriptionId}
```

**Fields:**
- `patientId`: String - Reference to patient
- `doctorId`: String - Reference to doctor
- `clinicId`: String - Reference to clinic
- `recordId`: String - Reference to medical record
- `issueDate`: Timestamp
- `expiryDate`: Timestamp
- `status`: String - "active", "completed", "cancelled"
- `medications`: Array<Map>
  - `name`: String
  - `dosage`: String
  - `frequency`: String
  - `duration`: String
  - `instructions`: String
  - `quantity`: Number
  - `refills`: Number
- `notes`: String - Additional instructions
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `createdBy`: String - User ID who created prescription
- `updatedBy`: String - User ID who last updated prescription
- `pharmacistId`: String - Pharmacist who fulfilled prescription
- `fulfilledDate`: Timestamp - When prescription was fulfilled

### 7. Reports Collection

```
reports/{reportId}
```

**Fields:**
- `patientId`: String - Reference to patient
- `doctorId`: String - Reference to doctor
- `clinicId`: String - Reference to clinic
- `recordId`: String - Reference to medical record
- `type`: String - "referral", "sick_note", "discharge_summary", "lab_request"
- `title`: String
- `content`: String - Report content
- `generatedDate`: Timestamp
- `validUntil`: Timestamp - For time-limited documents
- `status`: String - "draft", "final", "sent"
- `recipientInfo`: Map - For referrals
  - `name`: String
  - `specialty`: String
  - `contactInfo`: String
- `fileUrl`: String - URL to generated PDF
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `createdBy`: String - User ID who created report
- `updatedBy`: String - User ID who last updated report

### 8. Medications Collection

```
medications/{medicationId}
```

**Fields:**
- `name`: String - Medication name
- `genericName`: String
- `category`: String - Medication category
- `form`: String - "tablet", "capsule", "liquid", "injection"
- `strengths`: Array<String> - Available strengths
- `usageInstructions`: String - General usage guidelines
- `sideEffects`: Array<String>
- `contraindications`: Array<String>
- `interactions`: Array<String> - Known drug interactions
- `isActive`: Boolean
- `createdAt`: Timestamp
- `updatedAt`: Timestamp
- `createdBy`: String - User ID who added medication
- `updatedBy`: String - User ID who last updated medication

### 9. Settings Collection

```
settings/{settingId}
```

**Fields:**
- `type`: String - "global", "user", "clinic"
- `ownerId`: String - User ID or clinic ID this setting belongs to
- `preferences`: Map - Various app settings
- `templates`: Map - Templates for reports, prescriptions
- `customFields`: Array<Map> - Custom fields for patient records
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

### 10. Analytics Collection

```
analytics/{analyticsId}
```

**Fields:**
- `clinicId`: String - Reference to clinic
- `doctorId`: String - Reference to doctor
- `period`: String - "daily", "weekly", "monthly"
- `date`: Timestamp - Period start date
- `metrics`: Map
  - `patientCount`: Number
  - `appointmentCount`: Number
  - `completedAppointments`: Number
  - `cancelledAppointments`: Number
  - `noShowAppointments`: Number
  - `newPatients`: Number
  - `returnPatients`: Number
  - `averageVisitDuration`: Number
  - `commonDiagnoses`: Map<String, Number>
  - `commonMedications`: Map<String, Number>
  - `revenue`: Number - If payment tracking is enabled
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

## Security Rules Structure

The Firestore security rules will implement the following access patterns:

1. **Role-Based Access Control**:
   - Doctors can access all data for their clinics
   - Receptionists can only access appointments and basic patient info
   - Nurses can access patient records but not modify prescriptions
   - Pharmacists can only access prescriptions assigned to them

2. **Multi-Clinic Data Isolation**:
   - Users can only access data for clinics they are authorized for
   - Cross-clinic patient data is only accessible to authorized doctors

3. **Data Validation**:
   - Enforce required fields and data types
   - Validate relationships between collections
   - Prevent unauthorized modifications

## Indexes

The following composite indexes will be required:

1. `appointments` collection:
   - `clinicId`, `startTime` (ascending) - For clinic daily schedule
   - `patientId`, `startTime` (descending) - For patient appointment history
   - `doctorId`, `startTime` (ascending) - For doctor's schedule
   - `status`, `startTime` (ascending) - For filtering by status

2. `medical_records` collection:
   - `patientId`, `visitDate` (descending) - For patient medical history
   - `doctorId`, `visitDate` (descending) - For doctor's recent records

3. `prescriptions` collection:
   - `patientId`, `issueDate` (descending) - For patient prescription history
   - `status`, `expiryDate` (ascending) - For active prescriptions

## Offline Support Considerations

For offline support, the schema includes:

1. **Timestamp Fields**:
   - All documents include `createdAt` and `updatedAt` fields for conflict resolution

2. **Version Control**:
   - Consider adding `version` field to critical collections for optimistic concurrency control

3. **Sync Status**:
   - Client-side will maintain sync status for each document

## Data Relationships Diagram

```
users (1) --< clinics (N) -- staff (M) >-- users (1)
                |
                v
patients (N) -- visits (M) -- appointments (1)
    |               |
    |               v
    |         medical_records (1) -- attachments (N)
    |               |
    v               v
attachments (N)  prescriptions (N) -- medications (N)
                    |
                    v
                  reports (N)
```

This schema provides a solid foundation for building the Smart Clinic Management App with all the required features while maintaining flexibility for future enhancements.
