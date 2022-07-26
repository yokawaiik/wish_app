import 'package:flutter/material.dart';
import 'package:wish_app/src/wish_app.dart';

import './src/modules/settings/utils/settings_utils.dart' as settings_utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(const WishApp());
}

Future<void> _init() async {
  // ? info : it necessary to read saved settings to storage to set its when app starting
  await settings_utils.initStorage();
}
