import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Rigel';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    Bussiness: (data) => Bussiness.fromMap(data),
    Quiz: (data) => Quiz.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };

  // Firestore References for Writes
  static final Collection<Bussiness> bussinessRef =
      Collection<Bussiness>(path: 'bussiness');
  static final UserData<Report> reportRef =
      UserData<Report>(collection: 'customers');
}
