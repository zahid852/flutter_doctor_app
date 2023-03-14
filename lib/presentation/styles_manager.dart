import 'package:doctors_app/presentation/presentations.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
  double fontsize,
  String fontfamily,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
      fontSize: fontsize,
      fontFamily: fontfamily,
      fontWeight: fontWeight,
      color: color);
}

TextStyle getRegulerStyle({double fontsize = 12, required Color color}) {
  return _getTextStyle(
    fontsize,
    FontConstants.fontFamily,
    FontWeightManager.reguler,
    color,
  );
}

TextStyle getLightStyle({double fontsize = 12, required Color color}) {
  return _getTextStyle(
    fontsize,
    FontConstants.fontFamily,
    FontWeightManager.light,
    color,
  );
}

TextStyle getBoldStyle({double fontsize = 12, required Color color}) {
  return _getTextStyle(
    fontsize,
    FontConstants.fontFamily,
    FontWeightManager.Bold,
    color,
  );
}

TextStyle getSemiBoldStyle({double fontsize = 12, required Color color}) {
  return _getTextStyle(
    fontsize,
    FontConstants.fontFamily,
    FontWeightManager.semiBold,
    color,
  );
}

TextStyle getMediumStyle({double fontsize = 12, required Color color}) {
  return _getTextStyle(
    fontsize,
    FontConstants.fontFamily,
    FontWeightManager.medium,
    color,
  );
}
