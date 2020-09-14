import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

testDaysMethod() async {
  var response = await callableDays.call(<String, dynamic>{
    'month': DateTime.now().month,
    'agendaId': 'AZNVcZzTz5F9yLkxx96h',
    'businessId': 'gpVwyDZEsgmVWyaBuwKx',
    'productId': '5C3ymeILXBSH7ncaryTU'
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
    'businessId': 'gpVwyDZEsgmVWyaBuwKx',
    'productId': '5C3ymeILXBSH7ncaryTU'
  });
  if (response != null) {
    print(response.data);
    return response.data;
  }
  return null;
}
