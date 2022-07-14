import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:wish_app/src/modules/connection_manager/services/connection_manager_service.dart';
import 'package:wish_app/src/modules/global/utils/environment.dart'
    as environment;
import 'package:wish_app/src/wish_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/modules/global/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  runApp(WishApp());
}

Future<void> initServices() async {
  await dotenv.load(fileName: environment.fileName);
  await Get.putAsync(() => ConnectionManagerService().init());
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANNON_KEY'],
    debug: true,
  );
  await Get.putAsync(() => UserService().init());
}
