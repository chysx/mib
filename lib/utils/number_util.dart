/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-09 17:05

class NumberUtil {
  static String get2Decimal(double d,[count = 2]) {
    return d.toStringAsFixed(count);
  }
}