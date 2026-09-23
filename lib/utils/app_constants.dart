
import 'package:getdash/data/model/response/language_model.dart';

import 'images.dart';

class AppConstants {
  static const String appName = 'GetDash';
  static const double appVersion = 1.0;
  // static const String BASE_URL = 'https://ondemands.6am.one';

  // Shared Key
  static const String theme = 'getdash_theme';
  static const String countryCode = 'getdash_country_code';
  static const String languageCode = 'getdash_language_code';
  static const String localizationKey = 'X-localization';


  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.us, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabicTwo, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  ];
}
