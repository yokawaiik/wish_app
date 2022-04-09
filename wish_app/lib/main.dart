import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wish_app/src/utils/environment.dart' as environment;
import 'package:wish_app/src/wish_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: environment.fileName);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANNON_KEY'],
    debug: true, // optional
  );

  runApp(WishApp());
}
