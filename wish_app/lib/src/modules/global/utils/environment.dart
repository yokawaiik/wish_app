import 'package:flutter/foundation.dart';

String get fileName {
  if (!kReleaseMode) {
    return '.env.production';
  } else {
    return '.env.development';
  }
}
