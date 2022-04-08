import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wish_app/src/utils/environment.dart' as environment;
import 'package:wish_app/src/wish_app.dart';

void main() async {
  await dotenv.load(fileName: environment.fileName);

  runApp(WishApp());
}
