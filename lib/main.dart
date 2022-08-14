import 'package:flutter/material.dart';
import 'package:timekeeperv2/widget/export_page.dart';

import 'widget/config_page.dart';
import 'widget/edit_page.dart';
import 'widget/main_page.dart';

class ViewRoute {
  static const String VIEW_ROUTE_DEFAULT = "/";
  static const String VIEW_ROUTE_ADD_EDIT = "/edit";
  static const String VIEW_ROUTE_CONFIG = "/config";
  static const String VIEW_ROUTE_EXPORT = "/export";
}

void main() {
  runApp(MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: ViewRoute.VIEW_ROUTE_DEFAULT,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        ViewRoute.VIEW_ROUTE_DEFAULT: (context) => MainPage(),
        ViewRoute.VIEW_ROUTE_ADD_EDIT: (context) => EditPage(),
        ViewRoute.VIEW_ROUTE_CONFIG: (context) => ConfigPage(),
        ViewRoute.VIEW_ROUTE_EXPORT: (context) => ExportPage(),
      }));
}
