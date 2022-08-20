import 'package:flutter/material.dart';
import 'package:timekeeperv2/widget/export_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'business/time_slot.dart';
import 'widget/config_page.dart';
import 'widget/edit_page.dart';
import 'widget/main_page.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:hive_flutter/hive_flutter.dart';

class ViewRoute {
  static const String VIEW_ROUTE_DEFAULT = "/";
  static const String VIEW_ROUTE_ADD_EDIT = "/edit";
  static const String VIEW_ROUTE_CONFIG = "/config";
  static const String VIEW_ROUTE_EXPORT = "/export";
}

void main() async {
  await Hive.initFlutter("TimeKeeper");
  Hive.registerAdapter(TimeSlotAdapter());

  runApp(MaterialApp(
    title: 'Named Routes Demo',
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
  ));
}
