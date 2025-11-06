import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_check.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_parameters.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

class AppCrashesLogService {
  Future<void> initializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(appCrashesLogOneSignalString);
    await Future.delayed(const Duration(seconds: 1));
    await OneSignal.Notifications.requestPermission(true);
    appCrashesLogExternalId = Uuid().v1();
    try {
      OneSignal.login(appCrashesLogExternalId!);
    } catch (_) {}
  }

  Future navigateToAppCrashesLogSplash(BuildContext context) async {
    appCrashesLogCheckSharedPreferences.setBool("appCrashesLogSent", true);
    openStandartAppLogic(context);
  }

  void navigateToAppCrashesLogWebView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppCrashesLogWebView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  AppsFlyerOptions createAppCrashesLogAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (afDevKey1 + afDevKey2),
      appId: devKeypndAppId,
      timeToWaitForATTUserAuthorization: 7,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> requestUserSafeTrackingPermission() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 2));
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        appCrashesLogTrackingStatus = status.toString();

        if (status == TrackingStatus.authorized) {
          getAppCrashesLogAdvertisingId();
        }
        if (status == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          appCrashesLogTrackingStatus = status.toString();

          if (status == TrackingStatus.authorized) {
            getAppCrashesLogAdvertisingId();
          }
        }
      }
    }
  }

  Future<void> getAppCrashesLogAdvertisingId() async {
    try {
      appCrashesLogAdvertisingId = await AdvertisingId.id(true);
    } catch (_) {}
  }

  Future<String?> sendAppCrashesLogRequest(
    Map<dynamic, dynamic> parameters,
  ) async {
    try {
      final jsonString = json.encode(parameters);
      final base64Parameters = base64.encode(utf8.encode(jsonString));

      final requestBody = {appCrashesLogParameter: base64Parameters};

      final response = await http.post(
        Uri.parse(urlAppCrashesLogLink),
        body: requestBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
