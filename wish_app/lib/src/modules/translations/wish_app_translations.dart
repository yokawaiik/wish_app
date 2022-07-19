import 'package:get/get.dart';

import 'languages/en_language.dart';
import 'languages/ru_language.dart';

class WishAppTranslations extends Translations {
  final enLanguage = EnLanguage();
  final ruLanguage = RuLanguage();

  @override
  Map<String, Map<String, String>> get keys => {
        enLanguage.language: enLanguage.translations,
        ruLanguage.language: ruLanguage.translations,
      };
}
