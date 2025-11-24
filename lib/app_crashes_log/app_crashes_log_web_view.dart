import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_consent_prompt.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_service.dart';
import 'package:casino_companion/app_crashes_log/app_crashes_log_splash.dart';

class AppCrashesLogWebViewWidget extends StatefulWidget {
  const AppCrashesLogWebViewWidget({super.key});

  @override
  State<AppCrashesLogWebViewWidget> createState() =>
      _AppCrashesLogWebViewWidgetState();
}

class _AppCrashesLogWebViewWidgetState extends State<AppCrashesLogWebViewWidget>
    with WidgetsBindingObserver {
  late InAppWebViewController appCrashesLogWebViewController;

  bool appCrashesLogShowLoading = true;
  bool appCrashesLogShowConsentPrompt = false;

  bool appCrashesLogWasOpenNotification =
      appCrashesLogSharedPreferences.getBool("wasOpenNotification") ?? false;

  final bool savePermission =
      appCrashesLogSharedPreferences.getBool("savePermission") ?? false;

  bool waitingForSettingsReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      if (waitingForSettingsReturn) {
        waitingForSettingsReturn = false;
        Future.delayed(const Duration(milliseconds: 450), () {
          if (mounted) {
            appCrashesLogAfterSetting();
          }
        });
      }
    }
  }

  Future<void> appCrashesLogAfterSetting() async {
    final deviceState = OneSignal.User.pushSubscription;

    bool havePermission = deviceState.optedIn ?? false;
    final bool systemNotificationsEnabled = await AppCrashesLogService()
        .isSystemPermissionGranted();

    if (havePermission || systemNotificationsEnabled) {
      appCrashesLogSharedPreferences.setBool("wasOpenNotification", true);
      appCrashesLogWasOpenNotification = true;
      AppCrashesLogService().appCrashesLogSendRequiestToBack();
    }

    appCrashesLogShowConsentPrompt = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: appCrashesLogShowLoading ? 0 : 1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      onCreateWindow:
                          (
                            controller,
                            CreateWindowAction createWindowRequest,
                          ) async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                final dialogSize = MediaQuery.of(
                                  dialogContext,
                                ).size;

                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SizedBox(
                                        width: dialogSize.width,
                                        height: dialogSize.height * 0.8,
                                        child: InAppWebView(
                                          windowId:
                                              createWindowRequest.windowId,
                                          initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: true,
                                          ),
                                          onCloseWindow: (controller) {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: -18,
                                        right: -18,
                                        child: Material(
                                          color: Colors.black.withOpacity(0.7),
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            return true;
                          },
                      initialUrlRequest: URLRequest(
                        url: WebUri(appCrashesLogLink!),
                      ),
                      initialSettings: InAppWebViewSettings(
                        allowsBackForwardNavigationGestures: false,
                        javaScriptEnabled: true,
                        allowsInlineMediaPlayback: true,
                        mediaPlaybackRequiresUserGesture: false,
                        supportMultipleWindows: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      ),
                      onWebViewCreated: (controller) {
                        appCrashesLogWebViewController = controller;
                      },
                      onLoadStop: (controller, url) async {
                        appCrashesLogShowLoading = false;
                        setState(() {});
                        if (appCrashesLogWasOpenNotification) return;

                        final bool systemNotificationsEnabled =
                            await AppCrashesLogService()
                                .isSystemPermissionGranted();

                        await Future.delayed(Duration(milliseconds: 3000));

                        if (systemNotificationsEnabled) {
                          appCrashesLogSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                          appCrashesLogWasOpenNotification = true;
                        }

                        if (!systemNotificationsEnabled) {
                          appCrashesLogShowConsentPrompt = true;
                          appCrashesLogWasOpenNotification = true;
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return appCrashesLogBuildWebBottomBar(orientation);
              },
            ),
          ),
        ),
        if (appCrashesLogShowLoading) const AppCrashesLogSplash(),
        if (!appCrashesLogShowLoading)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            reverseDuration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: appCrashesLogShowConsentPrompt
                ? AppCrashesLogConsentPromptPage(
                    key: const ValueKey('consent_prompt'),
                    onYes: () async {
                      if (savePermission == true) {
                        waitingForSettingsReturn = true;
                        await AppSettings.openAppSettings(
                          type: AppSettingsType.settings,
                        );
                      } else {
                        await AppCrashesLogService()
                            .appCrashesLogRequestPermissionOneSignal();

                        final bool systemNotificationsEnabled =
                            await AppCrashesLogService()
                                .isSystemPermissionGranted();

                        if (systemNotificationsEnabled) {
                          appCrashesLogSharedPreferences.setBool(
                            "wasOpenNotification",
                            true,
                          );
                        } else {
                          appCrashesLogSharedPreferences.setBool(
                            "savePermission",
                            true,
                          );
                        }
                        appCrashesLogWasOpenNotification = true;
                        appCrashesLogShowConsentPrompt = false;
                        setState(() {});
                      }
                    },
                    onNo: () {
                      setState(() {
                        appCrashesLogWasOpenNotification = true;
                        appCrashesLogShowConsentPrompt = false;
                      });
                    },
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
      ],
    );
  }

  Widget appCrashesLogBuildWebBottomBar(Orientation orientation) {
    return Container(
      color: Colors.black,
      height: orientation == Orientation.portrait ? 25 : 30,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await appCrashesLogWebViewController.canGoBack()) {
                appCrashesLogWebViewController.goBack();
              }
            },
          ),
          const SizedBox.shrink(),
          IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await appCrashesLogWebViewController.canGoForward()) {
                appCrashesLogWebViewController.goForward();
              }
            },
          ),
        ],
      ),
    );
  }
}

