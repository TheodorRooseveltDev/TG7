import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_parameters.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_service.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_splash.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic appCrashesLogConversionData;
String? appCrashesLogTrackingStatus;
String? appCrashesLogAdvertisingId;
String? appCrashesLogLink;

String? appCrashesLogAppsflyerId;
String? appCrashesLogExternalId;

late SharedPreferences appCrashesLogCheckSharedPreferences;

class AppCrashesLogCheck extends StatefulWidget {
  const AppCrashesLogCheck({super.key});

  @override
  State<AppCrashesLogCheck> createState() => _AppCrashesLogCheckState();
}

class _AppCrashesLogCheckState extends State<AppCrashesLogCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      appCrashesLogCheckSharedPreferences =
          await SharedPreferences.getInstance();
      await Future.delayed(const Duration(milliseconds: 500));

      initAll();
    });
  }

  initAll() async {
    await Future.delayed(Duration(milliseconds: 10));
    bool appCrashesLogSent =
        appCrashesLogCheckSharedPreferences.getBool("appCrashesLogSent") ??
        false;
    appCrashesLogLink = appCrashesLogCheckSharedPreferences.getString("link");

    if (appCrashesLogLink != null &&
        appCrashesLogLink != "" &&
        !appCrashesLogSent) {
      AppCrashesLogService().navigateToAppCrashesLogWebView(context);
    } else {
      if (appCrashesLogSent) {
        AppCrashesLogService().navigateToAppCrashesLogSplash(context);
      } else {
        initializeMainPart();
      }
    }
  }

  void initializeMainPart() async {
    await AppCrashesLogService().requestUserSafeTrackingPermission();
    await AppCrashesLogService().initializeOneSignal();
    await takeAppCrashesLogParams();
  }

  Future<void> createAppCrashesLogLink() async {
    Map<dynamic, dynamic> parameters = appCrashesLogConversionData;

    parameters.addAll({
      "track_status": appCrashesLogTrackingStatus,
      "${appCrashesLogParameter}_id": appCrashesLogAdvertisingId,
      "appsflyer_id": appCrashesLogAppsflyerId,
      "external_id": appCrashesLogExternalId,
    });

    String? link = await AppCrashesLogService().sendAppCrashesLogRequest(
      parameters,
    );

    appCrashesLogLink = link;

    if (appCrashesLogLink == "" || appCrashesLogLink == null) {
      AppCrashesLogService().navigateToAppCrashesLogSplash(context);
    } else {
      appCrashesLogCheckSharedPreferences.setString(
        "link",
        appCrashesLogLink.toString(),
      );
      appCrashesLogCheckSharedPreferences.setBool("success", true);
      AppCrashesLogService().navigateToAppCrashesLogWebView(context);
    }
  }

  Future<void> takeAppCrashesLogParams() async {
    final appsFlyerOptions = AppCrashesLogService()
        .createAppCrashesLogAppsFlyerOptions();
    AppsflyerSdk appsFlyerSdk = AppsflyerSdk(appsFlyerOptions);
    appCrashesLogAppsflyerId = await appsFlyerSdk.getAppsFlyerUID();
    await appsFlyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    appsFlyerSdk.onInstallConversionData((res) async {
      appCrashesLogConversionData = res;
      await createAppCrashesLogLink();
    });

    appsFlyerSdk.startSDK(
      onError: (errorCode, errorMessage) {
        AppCrashesLogService().navigateToAppCrashesLogSplash(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppCrashesLogSplash();
  }
}
