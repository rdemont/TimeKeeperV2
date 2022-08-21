import 'package:flutter/material.dart';

import 'business/time_slot.dart';
import 'widget/base_app.dart';

//import 'package:hive/hive.dart';
//import 'package:path_provider/path_provider.dart' as path;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter("TimeKeeper");
  Hive.registerAdapter(TimeSlotAdapter());
  runApp(const BaseApp());
}
