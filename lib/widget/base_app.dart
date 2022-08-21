import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../business/time_slot.dart';
import '../utils/application.dart';
import 'base_page.dart';
import 'config_page.dart';
import 'edit_page.dart';
import 'export_page.dart';
import 'main_page.dart';

class BaseApp extends StatefulWidget {
  const BaseApp({Key? key}) : super(key: key);
  @override
  State<BaseApp> createState() => _BaseAppState();
  static _BaseAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BaseAppState>();
}

class ViewRoute {
  static const String VIEW_ROUTE_DEFAULT = "/";
  static const String VIEW_ROUTE_ADD_EDIT = "/edit";
  static const String VIEW_ROUTE_CONFIG = "/config";
  static const String VIEW_ROUTE_EXPORT = "/export";
}

class _BaseAppState extends State<BaseApp> {
  Locale? _locale;

  @override
  void initState() {
    //Do some shared init stuff here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = MaterialApp(
      title: 'Named Routes Demo',
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        _locale =
            deviceLocale; // here you make your app language similar to device language , but you should check whether the localization is supported by your app
      },
      locale: _locale,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: ViewRoute.VIEW_ROUTE_DEFAULT,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        ViewRoute.VIEW_ROUTE_DEFAULT: (context) => const MainPage(),
        ViewRoute.VIEW_ROUTE_ADD_EDIT: (context) => const EditPage(),
        ViewRoute.VIEW_ROUTE_CONFIG: (context) => const ConfigPage(),
        ViewRoute.VIEW_ROUTE_EXPORT: (context) => const ExportPage(),
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // 'en' is the language code. We could optionally provide a
        // a country code as the second param, e.g.
        // Locale('en', 'US'). If we do that, we may want to
        // provide an additional app_en_US.arb file for
        // region-specific translations.
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
    );

    setDefaultLocale();
    return result;
  }

  bool _defaultLocaleSet = false;
  void setDefaultLocale() {
    if (!_defaultLocaleSet) {
      Application.instance.getLocale(Locale("en")).then((value) {
        setState(() {
          _locale = value;
        });
      });
      _defaultLocaleSet = true;
    }
  }

  Locale getLocale() {
    return _locale ?? Locale("en");
  }

  void setLocale(Locale locale) {
    if (_locale == null) {
      setState(() {
        _locale = locale;
      });
      Application.instance.locale = locale;
    } else if (_locale!.languageCode != locale.languageCode) {
      setState(() {
        _locale = locale;
      });
      Application.instance.locale = locale;
    }
  }
}
