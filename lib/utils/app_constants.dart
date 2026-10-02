import 'package:getdash/data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String appName = 'LegalTech';
  static const double appVersion = 1.0;

  // Claves de Almacenamiento Local (SharedPreferences)
  static const String theme = 'legaltech_theme';
  static const String countryCode = 'legaltech_country_code';
  static const String languageCode = 'legaltech_language_code';
  static const String localizationKey = 'X-localization';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.us, languageName: 'Español', countryCode: 'EC', languageCode: 'es'),
    LanguageModel(imageUrl: Images.us, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}
