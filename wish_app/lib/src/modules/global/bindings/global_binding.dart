import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/connection_manager/services/connection_manager_service.dart';
import 'package:wish_app/src/modules/navigator/views/navigator_view.dart';

import '../../global/services/user_service.dart';

import '../../settings/utils/settings_utils.dart' as settings_utils;
import 'package:wish_app/src/modules/global/utils/environment.dart'
    as environment;

// ? info : sets global configs and app state
class GlobalBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    await dotenv.load(fileName: environment.fileName);

    await Future.wait([
      Get.putAsync<ConnectionManagerService>(
        () async => await ConnectionManagerService().init(),
        permanent: true,
      ),
      Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'],
        anonKey: dotenv.env['SUPABASE_ANNON_KEY'],
        // debug: true,
      ),
    ]);

    await Get.putAsync(
      () async => await UserService().init(),
      permanent: true,
    );
    await Get.offAndToNamed(NavigatorView.routeName);
  }
}
