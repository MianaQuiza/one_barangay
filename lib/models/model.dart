import 'package:cloud_firestore/cloud_firestore.dart';

/// All Firestore-backed data models for the app live in this file so
/// screens/services can import a single source of truth: `models.dart`.

enum ReportStatus { pending, inProgress, resolved }

ReportStatus reportStatusFromString(String value) {
  switch (value) {
    case 'inProgress':
      return ReportStatus.inProgress;
    case 'resolved':
      return ReportStatus.resolved;
    default:
      return ReportStatus.pending;
  }
}

String reportStatusToString(ReportStatus status) => status.name;

/// ---------------- Announcement ----------------
class Announcement {
  final String id;
  final String title;
  final String body;
  final String category; // Ordinance, Advisory, Holiday, Office Schedule, Road Closure, Utility Interruption
  final String? purokZone; // null = barangay-wide
  final DateTime createdAt;
  final String postedBy;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.purokZone,
    required this.createdAt,
    required this.postedBy,
  });

  factory Announcement.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Announcement(
      id: doc.id,
      title: d['title'] ?? '',
      body: d['body'] ?? '',
      category: d['category'] ?? 'General',
      purokZone: d['purokZone'],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      postedBy: d['postedBy'] ?? 'Barangay Office',
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'category': category,
        'purokZone': purokZone,
        'createdAt': Timestamp.fromDate(createdAt),
        'postedBy': postedBy,
      };
}

/// ---------------- Waste Collection ----------------
class CollectionSchedule {
  final String id;
  final String area; // Purok/Zone or street
  final String dayOfWeek; // Monday..Sunday
  final String timeWindow; // e.g. "6:00 AM - 9:00 AM"
  final String wasteType; // Biodegradable, Non-biodegradable, Recyclable

  CollectionSchedule({
    required this.id,
    required this.area,
    required this.dayOfWeek,
    required this.timeWindow,
    required this.wasteType,
  });

  factory CollectionSchedule.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CollectionSchedule(
      id: doc.id,
      area: d['area'] ?? '',
      dayOfWeek: d['dayOfWeek'] ?? '',
      timeWindow: d['timeWindow'] ?? '',
      wasteType: d['wasteType'] ?? '',
    );
  }
}

class GarbageTruckStatus {
  final String truckId;
  final GeoPoint location;
  final String status; // en_route, collecting, completed
  final DateTime updatedAt;
  final String currentArea;

  GarbageTruckStatus({
    required this.truckId,
    required this.location,
    required this.status,
    required this.updatedAt,
    required this.currentArea,
  });

  factory GarbageTruckStatus.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return GarbageTruckStatus(
      truckId: doc.id,
      location: d['location'] ?? const GeoPoint(0, 0),
      status: d['status'] ?? 'en_route',
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      currentArea: d['currentArea'] ?? '',
    );
  }
}

/// ---------------- Community Assistance (Incident Reports) ----------------
enum IncidentType { illegalDumping, brokenStreetlight, pothole, flooding, cloggedDrainage, noiseComplaint, fallenTree, other }

class IncidentReport {
  final String id;
  final IncidentType type;
  final String description;
  final String? photoUrl;
  final GeoPoint location;
  final ReportStatus status;
  final DateTime createdAt;
  final String reportedByUid;

  IncidentReport({
    required this.id,
    required this.type,
    required this.description,
    this.photoUrl,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.reportedByUid,
  });

  factory IncidentReport.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return IncidentReport(
      id: doc.id,
      type: IncidentType.values.firstWhere(
        (t) => t.name == d['type'],
        orElse: () => IncidentType.other,
      ),
      description: d['description'] ?? '',
      photoUrl: d['photoUrl'],
      location: d['location'] ?? const GeoPoint(0, 0),
      status: reportStatusFromString(d['status'] ?? 'pending'),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reportedByUid: d['reportedByUid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'description': description,
        'photoUrl': photoUrl,
        'location': location,
        'status': reportStatusToString(status),
        'createdAt': Timestamp.fromDate(createdAt),
        'reportedByUid': reportedByUid,
      };
}

/// ---------------- Lost and Found ----------------
enum LostFoundKind { lost, found }

class LostFoundItem {
  final String id;
  final LostFoundKind kind;
  final String itemName;
  final String description;
  final String? photoUrl;
  final String location;
  final ReportStatus status;
  final DateTime createdAt;
  final String reportedByUid;

  LostFoundItem({
    required this.id,
    required this.kind,
    required this.itemName,
    required this.description,
    this.photoUrl,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.reportedByUid,
  });

  factory LostFoundItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LostFoundItem(
      id: doc.id,
      kind: d['kind'] == 'found' ? LostFoundKind.found : LostFoundKind.lost,
      itemName: d['itemName'] ?? '',
      description: d['description'] ?? '',
      photoUrl: d['photoUrl'],
      location: d['location'] ?? '',
      status: reportStatusFromString(d['status'] ?? 'pending'),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reportedByUid: d['reportedByUid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'kind': kind.name,
        'itemName': itemName,
        'description': description,
        'photoUrl': photoUrl,
        'location': location,
        'status': reportStatusToString(status),
        'createdAt': Timestamp.fromDate(createdAt),
        'reportedByUid': reportedByUid,
      };
}

/// ---------------- Volunteer Program ----------------
class VolunteerActivity {
  final String id;
  final String title;
  final String description;
  final String category; // Clean-up, Tree Planting, Canal Cleaning, Feeding Program, Disaster Response
  final DateTime dateTime;
  final String location;
  final int slots;
  final List<String> joinedUids;

  VolunteerActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.slots,
    required this.joinedUids,
  });

  factory VolunteerActivity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return VolunteerActivity(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      category: d['category'] ?? '',
      dateTime: (d['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: d['location'] ?? '',
      slots: d['slots'] ?? 0,
      joinedUids: List<String>.from(d['joinedUids'] ?? []),
    );
  }
}

/// ---------------- Community Calendar ----------------
class CalendarEvent {
  final String id;
  final String title;
  final String category; // Assembly, Medical Mission, Vaccination, Senior, PWD, Sports, Livelihood, Clean-up
  final DateTime dateTime;
  final String location;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.location,
  });

  factory CalendarEvent.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CalendarEvent(
      id: doc.id,
      title: d['title'] ?? '',
      category: d['category'] ?? '',
      dateTime: (d['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      location: d['location'] ?? '',
    );
  }
}

/// ---------------- Generic Info Post ----------------
/// Reused for Senior Citizen, PWD, and Health Center modules since they
/// are all "structured info feed" screens with a title/body/category/date.
class InfoPost {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime? scheduleDate;

  InfoPost({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.scheduleDate,
  });

  factory InfoPost.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return InfoPost(
      id: doc.id,
      title: d['title'] ?? '',
      body: d['body'] ?? '',
      category: d['category'] ?? '',
      scheduleDate: (d['scheduleDate'] as Timestamp?)?.toDate(),
    );
  }
}

/// ---------------- Emergency Alerts ----------------
class EmergencyAlert {
  final String id;
  final String title;
  final String type; // Typhoon, Flood, Fire, Earthquake
  final String message;
  final String severity; // advisory, warning, critical
  final DateTime issuedAt;

  EmergencyAlert({
    required this.id,
    required this.title,
    required this.type,
    required this.message,
    required this.severity,
    required this.issuedAt,
  });

  factory EmergencyAlert.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return EmergencyAlert(
      id: doc.id,
      title: d['title'] ?? '',
      type: d['type'] ?? '',
      message: d['message'] ?? '',
      severity: d['severity'] ?? 'advisory',
      issuedAt: (d['issuedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// ---------------- Notifications ----------------
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    required this.read,
  });

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return AppNotification(
      id: doc.id,
      title: d['title'] ?? '',
      body: d['body'] ?? '',
      category: d['category'] ?? 'General',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: d['read'] ?? false,
    );
  }
}

/// ---------------- Resident Profile ----------------
class ResidentProfile {
  final String uid;
  final String fullName;
  final String purokZone;
  final String contactNumber;
  final String? role; // resident, garbage_collector, official

  ResidentProfile({
    required this.uid,
    required this.fullName,
    required this.purokZone,
    required this.contactNumber,
    this.role,
  });

  factory ResidentProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return ResidentProfile(
      uid: doc.id,
      fullName: d['fullName'] ?? '',
      purokZone: d['purokZone'] ?? '',
      contactNumber: d['contactNumber'] ?? '',
      role: d['role'] ?? 'resident',
    );
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'purokZone': purokZone,
        'contactNumber': contactNumber,
        'role': role ?? 'resident',
      };
}