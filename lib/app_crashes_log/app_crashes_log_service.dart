import 'dart:convert';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_parameters.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

class AppCrashesLogService {
  void appCrashesLogNavigateToWebView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppCrashesLogWebViewWidget(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> appCrashesLogInitializeOneSignal() async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.Location.setShared(false);
    OneSignal.initialize(appCrashesLogOneSignalString);
    appCrashesLogExternalId = Uuid().v1();
  }

  Future<void> appCrashesLogRequestPermissionOneSignal() async {
    await OneSignal.Notifications.requestPermission(true);
    appCrashesLogExternalId = Uuid().v1();
    try {
      OneSignal.login(appCrashesLogExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  void appCrashesLogSendRequiestToBack() {
    try {
      OneSignal.login(appCrashesLogExternalId!);
      OneSignal.User.pushSubscription.addObserver((state) {});
    } catch (_) {}
  }

  Future appCrashesLogNavigateToSplash(BuildContext context) async {
    appCrashesLogSharedPreferences.setBool("sendedAnalytics", true);
    appCrashesLogOpenStandartAppLogic(context);
  }

  Future<bool> isSystemPermissionGranted() async {
    if (!Platform.isIOS) return false;
    try {
      final status = await OneSignal.Notifications.permissionNative();
      return status == OSNotificationPermission.authorized ||
          status == OSNotificationPermission.provisional ||
          status == OSNotificationPermission.ephemeral;
    } catch (_) {
      return false;
    }
  }

  AppsFlyerOptions appCrashesLogCreateAppsFlyerOptions() {
    return AppsFlyerOptions(
      afDevKey: (appCrashesLogAfDevKey1 + appCrashesLogAfDevKey2),
      appId: appCrashesLogDevKeypndAppId,
      timeToWaitForATTUserAuthorization: 7,
      showDebug: true,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    );
  }

  Future<void> appCrashesLogRequestTrackingPermission() async {
    if (Platform.isIOS) {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(seconds: 2));
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        appCrashesLogTrackingPermissionStatus = status.toString();

        if (status == TrackingStatus.authorized) {
          appCrashesLogGetAdvertisingId();
        }
        if (status == TrackingStatus.notDetermined) {
          final status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          appCrashesLogTrackingPermissionStatus = status.toString();

          if (status == TrackingStatus.authorized) {
            appCrashesLogGetAdvertisingId();
          }
        }
      }
    }
  }

  Future<void> appCrashesLogGetAdvertisingId() async {
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

      final requestBody = {appCrashesLogStandartWord: base64Parameters};

      final response = await http.post(
        Uri.parse(appCrashesLogUrl),
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

