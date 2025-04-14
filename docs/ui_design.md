# UI Screens and Components Design

This document outlines the comprehensive UI design for the Smart Clinic Management App, including screen layouts, component descriptions, and navigation flows for Android, iOS, and Windows Desktop platforms.

## Design System

The app will follow Material Design 3 principles with support for:
- Light and dark themes
- Dynamic color theming (on Android 12+)
- RTL language support
- Responsive layouts for all screen sizes
- Platform-specific adaptations

### Color Palette

**Primary Colors:**
- Primary: `#0D47A1` (Deep Blue)
- Secondary: `#26A69A` (Teal)
- Accent: `#FF6E40` (Orange)

**Semantic Colors:**
- Success: `#4CAF50` (Green)
- Warning: `#FFC107` (Amber)
- Error: `#F44336` (Red)
- Info: `#2196F3` (Blue)

**Neutral Colors:**
- Background: `#FFFFFF` (Light) / `#121212` (Dark)
- Surface: `#F5F5F5` (Light) / `#1E1E1E` (Dark)
- On Background: `#212121` (Light) / `#E0E0E0` (Dark)
- On Surface: `#424242` (Light) / `#BDBDBD` (Dark)

### Typography

**Font Family:**
- Primary: Roboto (Android/Windows), San Francisco (iOS)
- Arabic: Cairo (for RTL support)

**Text Styles:**
- Heading 1: 24sp, Bold
- Heading 2: 20sp, Bold
- Heading 3: 18sp, Medium
- Subtitle: 16sp, Medium
- Body: 14sp, Regular
- Caption: 12sp, Regular
- Button: 14sp, Medium

### Iconography

- Outlined icons for navigation and actions
- Filled icons for selected states
- Custom icons for medical-specific functions

### Component Library

**Core Components:**
- AppBar with clinic switcher
- Bottom Navigation Bar (mobile)
- Navigation Rail (tablet/desktop)
- Floating Action Button
- Cards (Patient, Appointment, Prescription)
- Form Fields (with validation)
- Dialogs and Modals
- Snackbars and Toasts
- Loading Indicators
- Empty States
- Error States

**Custom Components:**
- Calendar View
- Timeline View (for medical history)
- Prescription Template
- Patient Summary Card
- Vital Signs Chart
- Analytics Dashboard Widgets
- Offline Indicator
- Sync Status Indicator

## Screen Layouts

### 1. Authentication Screens

#### 1.1 Login Screen

**Mobile Layout:**
```
┌─────────────────────────┐
│                         │
│         [Logo]          │
│                         │
│     Welcome Back to     │
│    Smart Clinic App     │
│                         │
│  ┌───────────────────┐  │
│  │    Email/Phone    │  │
│  └───────────────────┘  │
│                         │
│  ┌───────────────────┐  │
│  │     Password      │  │
│  └───────────────────┘  │
│                         │
│  [Forgot Password?]     │
│                         │
│  ┌───────────────────┐  │
│  │       Login       │  │
│  └───────────────────┘  │
│                         │
│  ── or continue with ── │
│                         │
│  [Google]  [Phone]      │
│                         │
│  New user? [Sign Up]    │
│                         │
└─────────────────────────┘
```

**Desktop Layout:**
```
┌───────────────────────────────────────────────────────┐
│                                                       │
│  ┌─────────────────────┐  ┌─────────────────────────┐ │
│  │                     │  │                         │ │
│  │                     │  │       Welcome to        │ │
│  │                     │  │    Smart Clinic App     │ │
│  │                     │  │                         │ │
│  │        [Logo]       │  │ ┌─────────────────────┐ │ │
│  │                     │  │ │    Email/Phone      │ │ │
│  │   Smart Clinic App  │  │ └─────────────────────┘ │ │
│  │                     │  │                         │ │
│  │                     │  │ ┌─────────────────────┐ │ │
│  │                     │  │ │     Password        │ │ │
│  │                     │  │ └─────────────────────┘ │ │
│  │                     │  │                         │ │
│  │                     │  │ [Forgot Password?]      │ │
│  │                     │  │                         │ │
│  │                     │  │ ┌─────────────────────┐ │ │
│  │                     │  │ │       Login         │ │ │
│  │                     │  │ └─────────────────────┘ │ │
│  │                     │  │                         │ │
│  │                     │  │ ── or continue with ──  │ │
│  │                     │  │                         │ │
│  │                     │  │ [Google]  [Phone]       │ │
│  │                     │  │                         │ │
│  │                     │  │ New user? [Sign Up]     │ │
│  │                     │  │                         │ │
│  └─────────────────────┘  └─────────────────────────┘ │
│                                                       │
└───────────────────────────────────────────────────────┘
```

#### 1.2 Registration Screen

Similar to login screen with additional fields:
- Full Name
- Email
- Phone Number
- Password
- Confirm Password
- Role Selection (Doctor, Nurse, etc.)
- Terms and Conditions Checkbox

#### 1.3 Forgot Password Screen

Simple form with:
- Email/Phone input
- Reset Password button
- Back to Login link

### 2. Dashboard Screens

#### 2.1 Doctor Dashboard

**Mobile Layout:**
```
┌─────────────────────────┐
│ [Clinic▼] [Dr. Name] [⚙]│
│─────────────────────────│
│                         │
│  Today's Appointments   │
│  ┌─────────────────┐    │
│  │ 9:00 John Smith │    │
│  │ Checkup         │    │
│  └─────────────────┘    │
│                         │
│  ┌─────────────────┐    │
│  │ 10:30 Jane Doe  │    │
│  │ Follow-up       │    │
│  └─────────────────┘    │
│                         │
│  Quick Stats            │
│  ┌───────┐ ┌───────┐    │
│  │ 12    │ │ 3     │    │
│  │ Total │ │ New   │    │
│  └───────┘ └───────┘    │
│  ┌───────┐ ┌───────┐    │
│  │ 2     │ │ 1     │    │
│  │ Urgent│ │ Cancel│    │
│  └───────┘ └───────┘    │
│                         │
│  Recent Patients        │
│  [Patient List...]      │
│                         │
├─────────────────────────┤
│ [👤] [📅] [💊] [📋] [📊] │
└─────────────────────────┘
```

**Desktop Layout:**
```
┌───────────────────────────────────────────────────────────────────┐
│ [Clinic▼]                                       [Dr. Name] [🔔] [⚙]│
├─────────┬─────────────────────────────────────────────────────────┤
│         │                                                         │
│         │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│         │  │ 12          │  │ 3           │  │ 2           │      │
│ [👤]     │  │ Appointments│  │ New Patients│  │ Urgent Cases│      │
│         │  └─────────────┘  └─────────────┘  └─────────────┘      │
│ [📅]     │                                                         │
│         │  Today's Schedule                                       │
│ [💊]     │  ┌─────────────────────────────────────────────────┐    │
│         │  │ 09:00 - 09:30  John Smith  Checkup     [Actions] │    │
│ [📋]     │  │ 10:30 - 11:00  Jane Doe   Follow-up   [Actions] │    │
│         │  │ 13:00 - 13:30  Bob Johnson Consultation [Actions]│    │
│ [📊]     │  └─────────────────────────────────────────────────┘    │
│         │                                                         │
│ [⚡]     │  Recent Patients                                        │
│         │  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐│
│         │  │ [Photo]       │  │ [Photo]       │  │ [Photo]       ││
│         │  │ John Smith    │  │ Jane Doe      │  │ Bob Johnson   ││
│         │  │ Last: Today   │  │ Last: Today   │  │ Last: Apr 10  ││
│         │  └───────────────┘  └───────────────┘  └───────────────┘│
│         │                                                         │
└─────────┴─────────────────────────────────────────────────────────┘
```

#### 2.2 Receptionist Dashboard

Similar to Doctor Dashboard but with:
- Focus on appointment management
- Patient check-in/check-out functionality
- Waiting room status
- Limited patient information access

#### 2.3 Nurse Dashboard

Similar to Doctor Dashboard but with:
- Focus on patient vitals
- Treatment follow-ups
- Limited prescription access

#### 2.4 Pharmacist Dashboard

Focused on:
- Pending prescriptions
- Fulfilled prescriptions
- Medication inventory

### 3. Appointment Management

#### 3.1 Appointment Calendar

**Mobile Layout:**
```
┌─────────────────────────┐
│ [Clinic▼] Appointments [⚙]│
│─────────────────────────│
│ [Month▼] [Week] [Day]   │
│                         │
│ April 2025              │
│ Mo Tu We Th Fr Sa Su    │
│  1  2  3  4  5  6  7    │
│  8  9 10 11 12 13 14    │
│ 15 16 17 18 19 20 21    │
│ 22 23 24 25 26 27 28    │
│ 29 30                   │
│                         │
│ Today (April 14)        │
│                         │
│ ┌─────────────────────┐ │
│ │ 9:00 - 9:30         │ │
│ │ John Smith          │ │
│ │ Checkup             │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ 10:30 - 11:00       │ │
│ │ Jane Doe            │ │
│ │ Follow-up           │ │
│ └─────────────────────┘ │
│                         │
│ [+] New Appointment     │
│                         │
├─────────────────────────┤
│ [👤] [📅] [💊] [📋] [📊] │
└─────────────────────────┘
```

**Desktop Layout:**
```
┌───────────────────────────────────────────────────────────────────┐
│ [Clinic▼] Appointments                           [Dr. Name] [🔔] [⚙]│
├─────────┬─────────────────────────────────────────────────────────┤
│         │ [Month▼] [Week] [Day]                  [+ New Appointment]│
│ [👤]     │                                                         │
│         │ ┌─────────────────────────────────────────────────────┐ │
│ [📅]     │ │     Monday     │    Tuesday    │   Wednesday   │...  │ │
│         │ │    April 14    │   April 15    │   April 16    │     │ │
│ [💊]     │ ├─────────────────────────────────────────────────────┤ │
│         │ │ 09:00 │ John Smith  │           │               │     │ │
│ [📋]     │ │      │ Checkup     │           │               │     │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│ [📊]     │ │ 10:00 │             │ Mary Brown │               │     │ │
│         │ │      │             │ New Patient │               │     │ │
│ [⚡]     │ ├─────────────────────────────────────────────────────┤ │
│         │ │ 11:00 │ Jane Doe    │           │ Tom Wilson   │     │ │
│         │ │      │ Follow-up    │           │ Consultation  │     │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│         │ │ 12:00 │             │           │               │     │ │
│         │ │      │             │           │               │     │ │
│         │ └─────────────────────────────────────────────────────┘ │
│         │                                                         │
└─────────┴─────────────────────────────────────────────────────────┘
```

#### 3.2 New/Edit Appointment

Form with fields:
- Patient (selector with search)
- Date and Time
- Duration
- Appointment Type
- Reason/Notes
- Recurring Options
- Reminder Settings
- Google Calendar Sync Option

#### 3.3 Appointment Details

Detailed view with:
- Patient information
- Appointment time and type
- Status controls (confirm, complete, cancel)
- Notes
- Action buttons (start consultation, reschedule, etc.)

### 4. Patient Management

#### 4.1 Patient List

**Mobile Layout:**
```
┌─────────────────────────┐
│ [Clinic▼]   Patients  [⚙]│
│─────────────────────────│
│ 🔍 Search patients...    │
│                         │
│ [All] [Recent] [Starred]│
│                         │
│ ┌─────────────────────┐ │
│ │ [Photo]             │ │
│ │ John Smith          │ │
│ │ 45M - #12345        │ │
│ │ Last visit: Today   │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ [Photo]             │ │
│ │ Jane Doe            │ │
│ │ 38F - #12346        │ │
│ │ Last visit: Today   │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ [Photo]             │ │
│ │ Bob Johnson         │ │
│ │ 52M - #12340        │ │
│ │ Last visit: Apr 10  │ │
│ └─────────────────────┘ │
│                         │
│ [+] New Patient         │
│                         │
├─────────────────────────┤
│ [👤] [📅] [💊] [📋] [📊] │
└─────────────────────────┘
```

**Desktop Layout:**
```
┌───────────────────────────────────────────────────────────────────┐
│ [Clinic▼] Patients                               [Dr. Name] [🔔] [⚙]│
├─────────┬─────────────────────────────────────────────────────────┤
│         │ 🔍 Search patients...                  [+ New Patient]   │
│ [👤]     │                                                         │
│         │ [All] [Recent] [Starred] [Filters▼]                     │
│ [📅]     │                                                         │
│         │ ┌─────────────────────────────────────────────────────┐ │
│ [💊]     │ │ ID     │ Patient Name  │ Age/Gender │ Last Visit  │ ... │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│ [📋]     │ │ #12345 │ John Smith    │ 45M        │ Today       │ ... │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│ [📊]     │ │ #12346 │ Jane Doe      │ 38F        │ Today       │ ... │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│ [⚡]     │ │ #12340 │ Bob Johnson   │ 52M        │ Apr 10      │ ... │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│         │ │ #12338 │ Mary Brown    │ 29F        │ Apr 8       │ ... │ │
│         │ ├─────────────────────────────────────────────────────┤ │
│         │ │ #12335 │ Tom Wilson    │ 61M        │ Apr 5       │ ... │ │
│         │ └─────────────────────────────────────────────────────┘ │
│         │                                                         │
└─────────┴─────────────────────────────────────────────────────────┘
```

#### 4.2 New/Edit Patient

Form with fields organized in tabs:
- Personal Information (name, DOB, gender, contact)
- Medical Information (allergies, blood type, chronic conditions)
- Insurance Details
- Emergency Contact
- Notes
- Attachments

#### 4.3 Patient Details

**Mobile Layout (Tabbed):**
```
┌─────────────────────────┐
│ [←] Patient Details  [⚙]│
│─────────────────────────│
│ [Photo]                 │
│ John Smith              │
│ 45M - #12345            │
│                         │
│ [Info] [History] [Rx] [Files]│
│─────────────────────────│
│                         │
│ Personal Information    │
│ Phone: +1 555-123-4567  │
│ Email: john@example.com │
│ Address: 123 Main St... │
│                         │
│ Medical Information     │
│ Blood: A+               │
│ Allergies: Penicillin   │
│ Conditions: Hypertension│
│                         │
│ Insurance               │
│ Provider: HealthPlus    │
│ Policy #: HP123456789   │
│                         │
│ [Edit Patient]          │
│                         │
├─────────────────────────┤
│ [👤] [📅] [💊] [📋] [📊] │
└─────────────────────────┘
```

**Desktop Layout (Side Panel):**
```
┌───────────────────────────────────────────────────────────────────┐
│ [Clinic▼] Patient: John Smith                   [Dr. Name] [🔔] [⚙]│
├─────────┬─────────────────────────────────────────────────────────┤
│         │ ┌─────────────┐                                         │
│ [👤]     │ │ [Photo]     │ John Smith                 [Edit Patient]│
│         │ │             │ 45M - #12345                            │
│ [📅]     │ └─────────────┘ Last Visit: Today                       │
│         │                                                         │
│ [💊]     │ [Info] [History] [Prescriptions] [Reports] [Files]      │
│         │                                                         │
│ [📋]     │ Personal Information                                    │
│         │ ┌─────────────────────────┐ ┌─────────────────────────┐ │
│ [📊]     │ │ Phone: +1 555-123-4567  │ │ Emergency Contact:      │ │
│         │ │ Email: john@example.com  │ │ Sarah Smith (Wife)      │ │
│ [⚡]     │ │ Address: 123 Main St...  │ │ Phone: +1 555-987-6543  │ │
│         │ └─────────────────────────┘ └─────────────────────────┘ │
│         │                                                         │
│         │ Medical Information                                     │
│         │ ┌─────────────────────────┐ ┌─────────────────────────┐ │
│         │ │ Blood Type: A+          │ │ Insurance:              │ │
│         │ │ Allergies: Penicillin   │ │ HealthPlus              │ │
│         │ │ Conditions: Hypertension│ │ Policy #: HP123456789   │ │
│         │ └─────────────────────────┘ └─────────────────────────┘ │
│         │                                                         │
└─────────┴─────────────────────────────────────────────────────────┘
```

#### 4.4 Medical History

Timeline view of patient's medical history:
- Chronological list of visits
- Expandable entries with details
- Filter options by visit type, date range
- Search functionality

### 5. Prescription Management

#### 5.1 Prescription List

List view of prescriptions with:
- Patient name
- Date issued
- Status (active, completed, cancelled)
- Medication count
- Actions (view, edit, print)

#### 5.2 New/Edit Prescription

Form with:
- Patient selector
- Medication selector with auto-complete
- Dosage, frequency, duration fields
- Special instructions
- Refill options
- Digital signature area
- Save as template option

#### 5.3 Prescription Details/Preview

Preview of prescription with:
- Clinic branding
- Doctor information
- Patient information
- Medication details
- Instructions
- Export/Print/Share options

### 6. Reports & Referrals

#### 6.1 Reports List

List of generated reports with:
- Patient name
- Report type
- Date generated
- Status
- Actions (view, edit, print)

#### 6.2 New/Edit Report

Template-based form with:
- Report type selector
- Patient selector
- Pre-filled fields based on template
- Custom fields
- Digital signature
- Save as template option

#### 6.3 Report Preview

Preview of report with:
- Clinic branding
- Doctor information
- Patient information
- Report content
- Export/Print/Share options

### 7. Analytics Dashboard

#### 7.1 Clinic Analytics

**Mobile Layout:**
```
┌─────────────────────────┐
│ [Clinic▼]  Analytics  [⚙]│
│─────────────────────────│
│ [Day] [Week] [Month] [Year]│
│                         │
│ Patient Volume          │
│ ┌─────────────────────┐ │
│ │                     │ │
│ │    [Bar Chart]      │ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
│ Common Diagnoses        │
│ ┌─────────────────────┐ │
│ │                     │ │
│ │    [Pie Chart]      │ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
│ Appointment Status      │
│ ┌─────────────────────┐ │
│ │                     │ │
│ │    [Donut Chart]    │ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
├─────────────────────────┤
│ [👤] [📅] [💊] [📋] [📊] │
└─────────────────────────┘
```

**Desktop Layout:**
```
┌───────────────────────────────────────────────────────────────────┐
│ [Clinic▼] Analytics                              [Dr. Name] [🔔] [⚙]│
├─────────┬─────────────────────────────────────────────────────────┤
│         │ [Day] [Week] [Month] [Year]    [Date Range Picker]      │
│ [👤]     │                                                         │
│         │ ┌─────────────────────┐ ┌─────────────────────┐         │
│ [📅]     │ │                     │ │                     │         │
│         │ │   Patient Volume    │ │  Appointment Status │         │
│ [💊]     │ │    [Line Chart]     │ │    [Donut Chart]    │         │
│         │ │                     │ │                     │         │
│ [📋]     │ └─────────────────────┘ └─────────────────────┘         │
│         │                                                         │
│ [📊]     │ ┌─────────────────────┐ ┌─────────────────────┐         │
│         │ │                     │ │                     │         │
│ [⚡]     │ │  Common Diagnoses   │ │ Prescription Trends │         │
│         │ │    [Pie Chart]      │ │    [Bar Chart]      │         │
│         │ │                     │ │                     │         │
│         │ └─────────────────────┘ └─────────────────────┘         │
│         │                                                         │
│         │ ┌─────────────────────────────────────────────────────┐ │
│         │ │                                                     │ │
│         │ │              Revenue by Service Type                │ │
│         │ │                   [Bar Chart]                       │ │
│         │ │                                                     │ │
│         │ └─────────────────────────────────────────────────────┘ │
│         │                                                         │
└─────────┴─────────────────────────────────────────────────────────┘
```

#### 7.2 Patient Analytics

Focused on individual patient:
- Visit frequency
- Condition trends
- Medication adherence
- Appointment attendance

### 8. Settings

#### 8.1 User Settings

Settings for user profile:
- Personal information
- Password change
- Notification preferences
- Theme preferences
- Language selection

#### 8.2 Clinic Settings

Settings for clinic management:
- Clinic information
- Business hours
- Appointment slots
- Staff management
- Branding settings

#### 8.3 App Settings

General app settings:
- Sync preferences
- Default views
- Export/Import data
- Backup settings
- Subscription management

### 9. Multi-Clinic Management

#### 9.1 Clinic Switcher

Dropdown/modal for switching between clinics:
- List of clinics with logos
- Quick clinic info
- Add new clinic option

#### 9.2 Clinic Management

Admin view for managing multiple clinics:
- Add/Edit/Remove clinics
- Staff assignment
- Resource allocation
- Cross-clinic settings

## Navigation Flows

### 1. Mobile Navigation

**Primary Navigation:**
- Bottom navigation bar with 5 main sections:
  - Patients
  - Appointments
  - Prescriptions
  - Reports
  - Analytics

**Secondary Navigation:**
- Tab bars within sections
- Back buttons for nested screens
- Floating action buttons for primary actions
- Clinic switcher in app bar

### 2. Desktop Navigation

**Primary Navigation:**
- Side navigation rail with 6 main sections:
  - Patients
  - Appointments
  - Prescriptions
  - Reports
  - Analytics
  - Quick Actions

**Secondary Navigation:**
- Tab bars within sections
- Breadcrumb navigation for nested screens
- Action buttons in toolbars
- Clinic switcher in app bar

## Responsive Design Strategy

### 1. Layout Breakpoints

- **Small** (< 600dp): Single column, bottom navigation
- **Medium** (600dp - 840dp): Two columns, bottom navigation
- **Large** (840dp - 1200dp): Multi-column, side navigation
- **Extra Large** (> 1200dp): Expanded multi-column, side navigation

### 2. Adaptive Components

- Cards that reflow based on available width
- Tables that convert to lists on small screens
- Expandable panels for dense information
- Modal dialogs on mobile, side panels on desktop

### 3. Touch vs. Mouse Optimization

- Larger touch targets on mobile
- Hover states on desktop
- Context menus optimized for each input method
- Keyboard shortcuts on desktop

## Accessibility Considerations

- High contrast mode support
- Screen reader compatibility
- Keyboard navigation
- Font scaling
- Color blindness considerations
- Voice input support

## Offline State UI

- Offline indicators
- Sync status badges on modified content
- Queued actions indicator
- Graceful degradation of features

## Loading States & Transitions

- Skeleton screens for initial loading
- Shimmer effects for content loading
- Pull-to-refresh on mobile
- Progress indicators for operations

## Error States

- Empty states with helpful guidance
- Error messages with recovery actions
- Offline error handling
- Validation error indicators

This UI design provides a comprehensive framework for building a responsive, accessible, and user-friendly Smart Clinic Management App across Android, iOS, and Windows Desktop platforms.
