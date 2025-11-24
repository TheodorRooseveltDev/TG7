import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_splash.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_service.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_parameters.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences appCrashesLogSharedPreferences;

dynamic appCrashesLogConversionData;
String? appCrashesLogTrackingPermissionStatus;
String? appCrashesLogAdvertisingId;
String? appCrashesLogLink;

String? appCrashesLogAppsflyerId;
String? appCrashesLogExternalId;

String? appCrashesLogPushConsentMsg;

class AppCrashesLog extends StatefulWidget {
  const AppCrashesLog({super.key});

  @override
  State<AppCrashesLog> createState() => _AppCrashesLogState();
}

class _AppCrashesLogState extends State<AppCrashesLog> {
  @override
  void initState() {
    super.initState();
    appCrashesLogInitAll();
  }

  appCrashesLogInitAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    appCrashesLogSharedPreferences = await SharedPreferences.getInstance();
    bool sendedAnalytics =
        appCrashesLogSharedPreferences.getBool("sendedAnalytics") ?? false;
    appCrashesLogLink = appCrashesLogSharedPreferences.getString("link");

    appCrashesLogPushConsentMsg = appCrashesLogSharedPreferences.getString(
      "pushconsentmsg",
    );

    if (appCrashesLogLink != null &&
        appCrashesLogLink != "" &&
        !sendedAnalytics) {
      AppCrashesLogService().appCrashesLogNavigateToWebView(context);
    } else {
      if (sendedAnalytics) {
        AppCrashesLogService().appCrashesLogNavigateToSplash(context);
      } else {
        appCrashesLogInitializeMainPart();
      }
    }
  }

  void appCrashesLogInitializeMainPart() async {
    await AppCrashesLogService().appCrashesLogRequestTrackingPermission();
    await AppCrashesLogService().appCrashesLogInitializeOneSignal();
    await appCrashesLogTakeParams();
  }

  String? appCrashesLogGetPushConsentMsgValue(String link) {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;

      return params['pushconsentmsg'];
    } catch (e) {
      return null;
    }
  }

  Future<void> appCrashesLogCreateLink() async {
    Map<dynamic, dynamic> parameters = appCrashesLogConversionData;

    parameters.addAll({
      "tracking_status": appCrashesLogTrackingPermissionStatus,
      "${appCrashesLogStandartWord}_id": appCrashesLogAdvertisingId,
      "external_id": appCrashesLogExternalId,
      "appsflyer_id": appCrashesLogAppsflyerId,
    });

    String? link = await AppCrashesLogService().sendAppCrashesLogRequest(
      parameters,
    );

    appCrashesLogLink = link;

    if (appCrashesLogLink == "" || appCrashesLogLink == null) {
      AppCrashesLogService().appCrashesLogNavigateToSplash(context);
    } else {
      appCrashesLogPushConsentMsg = appCrashesLogGetPushConsentMsgValue(
        appCrashesLogLink!,
      );
      if (appCrashesLogPushConsentMsg != null) {
        appCrashesLogSharedPreferences.setString(
          "pushconsentmsg",
          appCrashesLogPushConsentMsg!,
        );
      }
      appCrashesLogSharedPreferences.setString(
        "link",
        appCrashesLogLink.toString(),
      );
      appCrashesLogSharedPreferences.setBool("success", true);
      AppCrashesLogService().appCrashesLogNavigateToWebView(context);
    }
  }

  Future<void> appCrashesLogTakeParams() async {
    final appsFlyerOptions = AppCrashesLogService()
        .appCrashesLogCreateAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);

    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appCrashesLogAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();

    appsFlyerSdk.onInstallConversionData((res) async {
      appCrashesLogConversionData = res;
      await appCrashesLogCreateLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        AppCrashesLogService().appCrashesLogNavigateToSplash(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppCrashesLogSplash();
  }
}

