import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notification_permissions/notification_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<String>? permissionStatusFuture;
  String? _locale;

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  var somethingWrong = "somethingWrong";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // set up the notification permissions class
    // set up the future to fetch the notification data
    permissionStatusFuture = getCheckNotificationPermStatus();
  }

  /// When the application has a resumed status, check for the permission
  /// status
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }

  Future<void> initPlatformState() async {
    String? currentLocale;

    try {
      currentLocale = await Devicelocale.currentLocale;
      print((currentLocale != null)
          ? currentLocale
          : "Unable to get currentLocale");
    } on PlatformException {
      print("Error obtaining current locale");
    }

    if (!mounted) return;

    setState(() {
      _locale = currentLocale;
    });
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return somethingWrong;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('ja', ''), // Japanese, no country code
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Playground Flutter'),
        ),
        body: Center(
            child: Container(
          margin: EdgeInsets.all(20),
          child: FutureBuilder(
              future: permissionStatusFuture,
              builder: (context, snapshot) {
                // if we are waiting for data, show a progress indicator
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  var textWidget = Text(
                    "The permission status is ${snapshot.data}",
                    style: TextStyle(fontSize: 20),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  );

                  // else, we'll show a button to ask for the permissions
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("using devicelocale: ^0.4.2:"),
                      Text('$_locale'),
                      Text("using intl: ^0.17.0"),
                      Text(Intl.getCurrentLocale()),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      textWidget,
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: Text(
                            AppLocalizations.of(context)!.allowNotification),
                        onPressed: () {
                          // show the dialog/open settings screen
                          NotificationPermissions
                                  .requestNotificationPermissions(
                                      iosSettings:
                                          const NotificationSettingsIos(
                                              sound: true,
                                              badge: true,
                                              alert: true))
                              .then((_) {
                            // when finished, check the permission status
                            setState(() {
                              permissionStatusFuture =
                                  getCheckNotificationPermStatus();
                            });
                          });
                        },
                      )
                    ],
                  );
                }
                return Text("No permission status yet");
              }),
        )),
      ),
    );
  }
}
