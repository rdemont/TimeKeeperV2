import 'package:flutter/material.dart';
import 'package:timekeeperv2/widget/base_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

@optionalTypeArgs
abstract class BaseState<T extends BasePage> extends State {
  @override
  void initState() {
    //Do some shared init stuff here
    super.initState();
    //setDefaultLocale();
  }

  void setLocale(Locale value) {
    BaseApp.of(context)!.setLocale(value);
  }

  Locale? getLocale() {
    return BaseApp.of(context)!.getLocale();
  }
}
