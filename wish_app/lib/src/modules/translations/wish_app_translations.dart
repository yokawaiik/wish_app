import 'package:get/get.dart';

import 'languages/en_language.dart';

class WishAppTranslations extends Translations {
  final enLanguage = EnLanguage();

  @override
  Map<String, Map<String, String>> get keys => {
        enLanguage.language: enLanguage.translations,
      };
}
