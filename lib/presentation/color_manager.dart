import 'package:flutter/material.dart';

class ColorManager {
  static Color primery = HexColor.fromHex("0B2D89");
  static Color white = Colors.white;
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color primeryOpacity70 = HexColor.fromHex("#B30B2D89");
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = "FF" + hexString;
    }
    return Color(int.parse(hexString, radix: 16));
  }
}
