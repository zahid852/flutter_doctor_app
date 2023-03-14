import 'package:doctors_app/presentation/presentations.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      primaryColor: ColorManager.primery,
      primaryColorLight: ColorManager.primeryOpacity70,
      disabledColor: ColorManager.grey1,
      //ripple color
      splashColor: ColorManager.primeryOpacity70,

      // card theme
      cardTheme: CardTheme(
          color: ColorManager.white,
          shadowColor: ColorManager.grey,
          elevation: appSize.s4),

      // app bar theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primery,
          // shadowColor: ColorManager.primeryOpacity70,
          elevation: appSize.s4,
          titleTextStyle: getRegulerStyle(
            color: ColorManager.white,
            fontsize: 24,
          )),
      buttonTheme: ButtonThemeData(
          shape: StadiumBorder(),
          buttonColor: ColorManager.primery,
          splashColor: ColorManager.primeryOpacity70,
          disabledColor: ColorManager.grey1),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegulerStyle(color: ColorManager.white),
              primary: ColorManager.primery,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))),
      textTheme: TextTheme(
          headline1: getSemiBoldStyle(
              color: ColorManager.darkGrey, fontsize: FontSize.s16),
          subtitle1: getMediumStyle(color: ColorManager.lightGrey),
          caption: getRegulerStyle(color: ColorManager.grey1),
          bodyText1: getRegulerStyle(color: ColorManager.grey)));
}
