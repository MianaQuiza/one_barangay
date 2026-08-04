import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/model.dart';

/// Wraps every Firestore read/write the app needs behind one class.
/// Screens should never call FirebaseFirestore.instance directly —
/// go through here so collection names/queries live in exactly one place.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------- Collections ----------------
  CollectionReference<Map<String, dynamic>> get _announcements => _db.collection('announcements');
  CollectionReference<Map<String, dynamic>> get _schedules => _db.collection('collection_schedules');
  CollectionReference<Map<String, dynamic>> get _trucks => _db.collection('garbage_trucks');
  CollectionReference<Map<String, dynamic>> get _incidents => _db.collection('incident_reports');
  CollectionReference<Map<String, dynamic>> get _lostFound => _db.collection('lost_found_items');
  CollectionReference<Map<String, dynamic>> get _volunteerActivities => _db.collection('volunteer_activities');
  CollectionReference<Map<String, dynamic>> get _calendarEvents => _db.collection('calendar_events');
  CollectionReference<Map<String, dynamic>> get _seniorPosts => _db.collection('senior_citizen_posts');
  CollectionReference<Map<String, dynamic>> get _pwdPosts => _db.collection('pwd_posts');
  CollectionReference<Map<String, dynamic>> get _healthPosts => _db.collection('health_center_posts');
  CollectionReference<Map<String, dynamic>> get _emergencyAlerts => _db.collection('emergency_alerts');
  CollectionReference<Map<String, dynamic>> get _residents => _db.collection('residents');

  CollectionReference<Map<String, dynamic>> notificationsFor(String uid) =>
      _db.collection('residents').doc(uid).collection('notifications');

  // ---------------- Announcements ----------------
  Stream<List<Announcement>> announcementsStream({String? purokZone}) {
    return _announcements.orderBy('createdAt', descending: true).snapshots().map(
          (s) => s.docs
              .map(Announcement.fromDoc)
              .where((a) => a.purokZone == null || a.purokZone == purokZone)
              .toList(),
        );
  }

  Future<void> postAnnouncement(Announcement a) => _announcements.add(a.toMap());

  // ---------------- Waste Collection ----------------
  Stream<List<CollectionSchedule>> collectionSchedulesStream({String? area}) {
    Query<Map<String, dynamic>> q = _schedules;
    if (area != null) q = q.where('area', isEqualTo: area);
    return q.snapshots().map((s) => s.docs.map(CollectionSchedule.fromDoc).toList());
  }

  Stream<List<GarbageTruckStatus>> activeTrucksStream() {
    return _trucks.where('status', isNotEqualTo: 'completed').snapshots().map(
          (s) => s.docs.map(GarbageTruckStatus.fromDoc).toList(),
        );
  }

  Future<void> updateTruckStatus(String truckId, GeoPoint location, String status, String area) {
    return _trucks.doc(truckId).set({
      'location': location,
      'status': status,
      'currentArea': area,
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // ---------------- Community Assistance ----------------
  Stream<List<IncidentReport>> incidentReportsStream({String? reportedByUid}) {
    Query<Map<String, dynamic>> q = _incidents.orderBy('createdAt', descending: true);
    if (reportedByUid != null) q = q.where('reportedByUid', isEqualTo: reportedByUid);
    return q.snapshots().map((s) => s.docs.map(IncidentReport.fromDoc).toList());
  }

  Future<void> submitIncidentReport(IncidentReport report) => _incidents.add(report.toMap());

  Future<void> updateIncidentStatus(String id, ReportStatus status) =>
      _incidents.doc(id).update({'status': reportStatusToString(status)});

  // ---------------- Lost and Found ----------------
  Stream<List<LostFoundItem>> lostFoundStream({LostFoundKind? kind}) {
    Query<Map<String, dynamic>> q = _lostFound.orderBy('createdAt', descending: true);
    if (kind != null) q = q.where('kind', isEqualTo: kind.name);
    return q.snapshots().map((s) => s.docs.map(LostFoundItem.fromDoc).toList());
  }

  Future<void> submitLostFoundItem(LostFoundItem item) => _lostFound.add(item.toMap());

  // ---------------- Volunteer Program ----------------
  Stream<List<VolunteerActivity>> volunteerActivitiesStream() {
    return _volunteerActivities
        .orderBy('dateTime')
        .snapshots()
        .map((s) => s.docs.map(VolunteerActivity.fromDoc).toList());
  }

  Future<void> joinActivity(String activityId, String uid) {
    return _volunteerActivities.doc(activityId).update({
      'joinedUids': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> leaveActivity(String activityId, String uid) {
    return _volunteerActivities.doc(activityId).update({
      'joinedUids': FieldValue.arrayRemove([uid]),
    });
  }

  // ---------------- Community Calendar ----------------
  Stream<List<CalendarEvent>> calendarEventsStream() {
    return _calendarEvents.orderBy('dateTime').snapshots().map(
          (s) => s.docs.map(CalendarEvent.fromDoc).toList(),
        );
  }

  // ---------------- Senior Citizen / PWD / Health Center ----------------
  // Same shape (InfoPost), different collections - kept generic on purpose.
  Stream<List<InfoPost>> seniorCitizenPostsStream() =>
      _seniorPosts.orderBy('scheduleDate', descending: false).snapshots().map(
            (s) => s.docs.map(InfoPost.fromDoc).toList(),
          );

  Stream<List<InfoPost>> pwdPostsStream() =>
      _pwdPosts.orderBy('scheduleDate', descending: false).snapshots().map(
            (s) => s.docs.map(InfoPost.fromDoc).toList(),
          );

  Stream<List<InfoPost>> healthCenterPostsStream() =>
      _healthPosts.orderBy('scheduleDate', descending: false).snapshots().map(
            (s) => s.docs.map(InfoPost.fromDoc).toList(),
          );

  // ---------------- Emergency Alerts ----------------
  Stream<List<EmergencyAlert>> emergencyAlertsStream() {
    return _emergencyAlerts.orderBy('issuedAt', descending: true).snapshots().map(
          (s) => s.docs.map(EmergencyAlert.fromDoc).toList(),
        );
  }

  // ---------------- Notifications ----------------
  Stream<List<AppNotification>> notificationsStream(String uid) {
    return notificationsFor(uid).orderBy('createdAt', descending: true).snapshots().map(
          (s) => s.docs.map(AppNotification.fromDoc).toList(),
        );
  }

  Future<void> markNotificationRead(String uid, String notifId) =>
      notificationsFor(uid).doc(notifId).update({'read': true});

  // ---------------- Residents ----------------
  Future<void> upsertResidentProfile(ResidentProfile profile) =>
      _residents.doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));

  Future<ResidentProfile?> getResidentProfile(String uid) async {
    final doc = await _residents.doc(uid).get();
    if (!doc.exists) return null;
    return ResidentProfile.fromDoc(doc);
  }
}