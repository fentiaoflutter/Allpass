import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllpassScreenUtil {

  static ScreenUtil _instance = ScreenUtil.getInstance();
  static double screenHighDp = ScreenUtil.screenHeightDp;

  static num setWidth(num width) {
    return _instance.setWidth(width);
  }

  static num setHeight(num height) {
    return _instance.setHeight(height);
  }
}