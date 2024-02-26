import 'package:chat_app_with_myysql/util/font_manager.dart';
import 'package:flutter/material.dart';
// import 'package:streamup/presentation/resources/font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontweight, Color color,
    [Paint? foreground]) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
      foreground: foreground,
      fontWeight: fontweight);
}

//regular Style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.regular, color);
}

//light text style
TextStyle getLightStyle(
    {double fontSize = FontSize.s12, required Color color,}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.light, color);
}

//bold text style
TextStyle getBoldStyle({double fontSize = FontSize.s12, String fontFamily=FontConstants.fontFamily,  required Color color}) {
  return _getTextStyle(
      fontSize, fontFamily, FontWeightManager.bold, color);
}

//medium text style
TextStyle getMediumStyle(
    {double fontSize = FontSize.s12,String fontFamily=FontConstants.fontFamily, required Color color}) {
  return _getTextStyle(
      fontSize, fontFamily, FontWeightManager.medium, color);
}

//semibold text style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12,String fontFamily=FontConstants.fontFamily, required Color color}) {
  return _getTextStyle(
      fontSize, fontFamily, FontWeightManager.semiBold, color);
}

//semibold text gradient style
