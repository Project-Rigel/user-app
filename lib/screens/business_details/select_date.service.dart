import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

final HttpsCallable callableDays =
    CloudFunctions(app: FirebaseApp.instance, region: "europe-west1")
        .getHttpsCallable(
  functionName: 'getAvaliableDaysInMonth',
);
final HttpsCallable callableTimes =
    CloudFunctions(app: FirebaseApp.instance, region: "europe-west1")
        .getHttpsCallable(
  functionName: 'getAvaliableTimeIntervals',
);
final HttpsCallable callableBook =
    CloudFunctions(app: FirebaseApp.instance, region: "europe-west1")
        .getHttpsCallable(
  functionName: 'bookAppointment',
);

testDaysMethod() async {
  var response = await callableDays.call(<String, dynamic>{
    'month': DateTime.now().month,
    'agendaId': 'AZNVcZzTz5F9yLkxx96h',
    'businessId': 'gQc7A7w1GIATEz4vo65T',
    'productId': 'QzsxOW8f0vThRPwkaNEi'
  });
  if (response != null) {
    return response.data;
  }
  return null;
}

testTimesMethod(DateTime day) async {
  var response = await callableTimes.call(<String, dynamic>{
    'timestamp': day.toIso8601String(),
    'agendaId': 'AZNVcZzTz5F9yLkxx96h',
    'businessId': 'gQc7A7w1GIATEz4vo65T',
    'productId': 'QzsxOW8f0vThRPwkaNEi'
  });
  if (response != null) {
    print(response.data);
    return response.data;
  }
  return null;
}

testAppointmentMethod(DateTime day) async {
  var response = await callableBook.call(<String, dynamic>{
    'uid': "r4VNj2nR9gckExM1siUbM1bw6qV2",
    'timestamp': day.toUtc().toString(),
    'agendaId': 'AZNVcZzTz5F9yLkxx96h',
    'businessId': 'gQc7A7w1GIATEz4vo65T',
    'productId': 'QzsxOW8f0vThRPwkaNEi'
  });
  if (response != null) {
    print(response.data);
    return response.data;
  }
  return null;
}
