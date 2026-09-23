import 'package:get/get.dart';

class Dimensions {
  static double get fontSizeExtraSmall => (Get.context != null && Get.context!.width >= 1300) ? 14 : 12;
  static double get fontSizeSmall => (Get.context != null && Get.context!.width >= 1300) ? 16 : 12;
  static double get fontSizeDefault => (Get.context != null && Get.context!.width >= 1300) ? 18 : 14;
  static double get fontSizeLarge => (Get.context != null && Get.context!.width >= 1300) ? 20 : 16;
  static double get fontSizeExtraLarge => (Get.context != null && Get.context!.width >= 1300) ? 20 : 18;
  static double get fontSizeOverLarge => (Get.context != null && Get.context!.width >= 1300) ? 28 : 24;
  static double get fontSizeForReview => (Get.context != null && Get.context!.width >= 1300) ? 36 : 36;

  static const double paddingSizeMint = 2.0;
  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeRadius = 8.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeLargeThirty = 30.0;
  static const double paddingSizeExtraMoreLarge = 40.0;
  static const double paddingSizeExtraMoreMoreLarge = 45.0;
  static const double paddingSizeDoubleExtraLarge = 50.0;
  static const double paddingSizeDoubleDoubleExtraLarge = 60.0;


  static const double statusButtonHeight = 30.0;
  static const double statusButtonWeight = 75.0;
  static const double imageSize = 50.0;
  static const double editIconSize = 20.0;
  static const double uploadFileSize = 140.0;
  static const double buttonSize = 50.0;
  static const double radiusSmall = 5.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;
  static const double radiusExtraMoreLarge = 50.0;
  static const double webMaxWidth = 1170;
  static const double iconSize = 40;
  static const double iconSizeMedium = 30;
  static const double iconSizeSmall = 18;
  static const double iconSizeDefault = 24;
  static const double textFieldSize = 50;
  static const double headerRowHeight =45;
  static const double containerHeight =80;
  static const double tableImageSize =40;

}