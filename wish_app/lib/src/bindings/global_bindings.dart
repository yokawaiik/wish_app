import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wish_app/src/modules/auth/controllers/auth_controller.dart';
import 'package:wish_app/src/services/user_service.dart';
import 'package:wish_app/src/utils/environment.dart' as environment;

import '../modules/connection_manager/services/connection_manager_service.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() async {}
}
