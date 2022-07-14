import 'package:get/get.dart';
import 'package:wish_app/src/modules/settings/translations/languages/en_language.dart';
import '../translations/constants/translations_constants.dart'
    as settings_constants;

class WishAppTranslations extends Translations {
  final enLanguage = EnLanguage();

  @override
  Map<String, Map<String, String>> get keys => {
        settings_constants.localeEnUS.toString(): enLanguage.language,
      };
}
