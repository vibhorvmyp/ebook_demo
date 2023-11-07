import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_rx/get_rx.dart';

class CssModel {
  String? after; //after
  Alignment? alignmemt; //align-item
  Color? backgroundColor;
  String? before;
  Border? border;
  Color? color;
  Map<String, int?>? counterIncrement;
  Map<String, int?>? counterReset;
  TextDirection? direction;
  Display? display;
  String? fontFamily;
  List<String>? fontFamilyFallback;
  List<FontFeature>? fontFeatureSettings;
  FontSize? fontSize;
  FontStyle? fontStyle;
  FontWeight? fontWeight;
  Height? height;
  double? letterSpacing;
  LineHeight? lineHeight;
  ListStyleImage? listStyleImage;
  ListStylePosition? listStylePosition;
  ListStyleType? listStyleType;
  Margins? margin;
  Marker? marker;
  int? maxLines;
  HtmlPaddings? padding;
  TextAlign? textAlign;
  TextDecoration? textDecoration;
  Color? textDecorationColor;
  TextDecorationStyle? textDecorationStyle;
  double? textDecorationThickness;
  TextOverflow? textOverflow;
  List<Shadow>? textShadow;
  TextTransform? textTransform;
  VerticalAlign? verticalAlign = VerticalAlign.baseline;
  WhiteSpace? whiteSpace;
  Width? width;
  double? wordSpacing;
  CssModel({
    this.after,
    this.alignmemt,
    this.backgroundColor,
    this.before,
    this.border,
    this.color,
    this.counterIncrement,
    this.counterReset,
    this.direction,
    this.display,
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontFeatureSettings,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.height,
    this.letterSpacing,
    this.lineHeight,
    this.listStyleImage,
    this.listStylePosition,
    this.listStyleType,
    this.margin,
    this.marker,
    this.maxLines,
    this.padding,
    this.textAlign,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    this.textDecorationThickness,
    this.textOverflow,
    this.textShadow,
    this.textTransform,
    this.verticalAlign,
    this.whiteSpace,
    this.width,
    this.wordSpacing,
  });

  CssModel copyWith({
    String? after,
    Alignment? alignmemt,
    Color? backgroundColor,
    String? before,
    Border? border,
    Color? color,
    Map<String, int?>? counterIncrement,
    Map<String, int?>? counterReset,
    TextDirection? direction,
    Display? display,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    List<FontFeature>? fontFeatureSettings,
    FontSize? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    Height? height,
    double? letterSpacing,
    LineHeight? lineHeight,
    ListStyleImage? listStyleImage,
    ListStylePosition? listStylePosition,
    ListStyleType? listStyleType,
    Margins? margin,
    Marker? marker,
    int? maxLines,
    HtmlPaddings? padding,
    TextAlign? textAlign,
    TextDecoration? textDecoration,
    Color? textDecorationColor,
    TextDecorationStyle? textDecorationStyle,
    double? textDecorationThickness,
    TextOverflow? textOverflow,
    List<Shadow>? textShadow,
    TextTransform? textTransform,
    VerticalAlign verticalAlign = VerticalAlign.baseline,
    WhiteSpace? whiteSpace,
    Width? width,
    double? wordSpacing,
  }) {
    return CssModel(
      after: after ?? this.after,
      alignmemt: alignmemt ?? this.alignmemt,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      before: before ?? this.before,
      border: border ?? this.border,
      color: color ?? this.color,
      counterIncrement: counterIncrement ?? this.counterIncrement,
      counterReset: counterReset ?? this.counterReset,
      direction: direction ?? this.direction,
      display: display ?? this.display,
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      fontFeatureSettings: fontFeatureSettings ?? this.fontFeatureSettings,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      fontWeight: fontWeight ?? this.fontWeight,
      height: height ?? this.height,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
      listStyleImage: listStyleImage ?? this.listStyleImage,
      listStylePosition: listStylePosition ?? this.listStylePosition,
      listStyleType: listStyleType ?? this.listStyleType,
      margin: margin ?? this.margin,
      marker: marker ?? this.marker,
      maxLines: maxLines ?? this.maxLines,
      padding: padding ?? this.padding,
      textAlign: textAlign ?? this.textAlign,
      textDecoration: textDecoration ?? this.textDecoration,
      textDecorationColor: textDecorationColor ?? this.textDecorationColor,
      textDecorationStyle: textDecorationStyle ?? this.textDecorationStyle,
      textDecorationThickness:
          textDecorationThickness ?? this.textDecorationThickness,
      textOverflow: textOverflow ?? this.textOverflow,
      textShadow: textShadow ?? this.textShadow,
      textTransform: textTransform ?? this.textTransform,
      verticalAlign: verticalAlign,
      whiteSpace: whiteSpace ?? this.whiteSpace,
      width: width ?? this.width,
      wordSpacing: wordSpacing ?? this.wordSpacing,
    );
  }

  Map<String, CssModel> mapCssToModel(
      Map<String, Map<String, String>> cssData) {
    Map<String, CssModel> resultMap = {};
    cssData.forEach((key1, value) {
      CssModel cssModel = CssModel();
      value.forEach((key, value) {
        if (key == "after") {
          cssModel.after = value;
        }
        if (key == "before") {
          cssModel.before = value;
        }
        if (key == "align-content") {
          if (value == "center") {
            cssModel.alignmemt = Alignment.center;
          }
          if (value == "flex-start") {
            cssModel.alignmemt = Alignment.centerLeft;
          }
          if (value == "flex-end") {
            cssModel.alignmemt = Alignment.centerRight;
          }
          if (value == "baseline") {
            cssModel.alignmemt = Alignment.bottomCenter;
          }
        }
        if (key == "background-color") {
          cssModel.backgroundColor = parseCssColor(value);
        }
        if (key == "border") {
          cssModel.border = parseCssBorder(value);
        }
        if (key == "color") {
          cssModel.color = parseCssColor(value);
        }
        if (key == "direction") {
          if (value == "ltr") {
            cssModel.direction = TextDirection.ltr;
          }
          if (value == "rtl") {
            cssModel.direction = TextDirection.rtl;
          }
        }
        if (key == "display") {
          if (value == "block") {
            cssModel.display = Display.block;
          }
          if (value == "inline") {
            cssModel.display = Display.inline;
          }
          if (value == "inline-block") {
            cssModel.display = Display.inlineBlock;
          }
          if (value == "list-item") {
            cssModel.display = Display.listItem;
          }
        }
        if (key == "font-size") {
          if (value == "medium") {
            cssModel.fontSize = FontSize.medium;
          }
          if (value == "xx-small") {
            cssModel.fontSize = FontSize.xxSmall;
          }
          if (value == "x-small") {
            cssModel.fontSize = FontSize.xSmall;
          }
          if (value == "small") {
            cssModel.fontSize = FontSize.small;
          }
          if (value == "large") {
            cssModel.fontSize = FontSize.large;
          }
          if (value == "x-large") {
            cssModel.fontSize = FontSize.xLarge;
          }
          if (value == "xx-large") {
            cssModel.fontSize = FontSize.xxLarge;
          }
          if (value == "larger") {
            cssModel.fontSize = FontSize.larger;
          }
          if (value == "smaller") {
            cssModel.fontSize = FontSize.smaller;
          }
          if (value.contains(RegExp(r'\d'))) {
            if (value.contains("%")) {
              double size =
                  double.tryParse(value.substring(0, value.length - 1)) ?? 10.5;
              cssModel.fontSize = FontSize(size);
            }
            if (value.contains("rem")) {
              double size =
                  double.tryParse(value.substring(0, value.length - 3)) ?? 10.5;
              cssModel.fontSize = FontSize(size);
            }
            String unit = value.substring(value.length - 2);
            double size =
                double.tryParse(value.substring(0, value.length - 2)) ?? 10.5;
            cssModel.fontSize = FontSize(
              size,
            );
          }
        }
        if (key == "font-style") {
          if (value == "normal") {
            cssModel.fontStyle = FontStyle.normal;
          } else if (value == "italic") {
            cssModel.fontStyle = FontStyle.italic;
          } else {
            cssModel.fontStyle = FontStyle.normal;
          }
        }
        if (key == "font-weight") {
          if (value == "normal") {
            cssModel.fontWeight = FontWeight.normal;
          }
          if (value == "bold") {
            cssModel.fontWeight = FontWeight.bold;
          }
          if (value == "bolder") {
            cssModel.fontWeight = FontWeight.w800;
          }
          if (value == "lighter") {
            cssModel.fontWeight = FontWeight.w300;
          }
          if (value.contains(RegExp(r'\d'))) {
            var weight = int.parse(value);
            if (weight == 100) {
              cssModel.fontWeight = FontWeight.w100;
            } else if (weight == 200) {
              cssModel.fontWeight = FontWeight.w200;
            } else if (weight == 300) {
              cssModel.fontWeight = FontWeight.w300;
            } else if (weight == 400) {
              cssModel.fontWeight = FontWeight.w400;
            } else if (weight == 500) {
              cssModel.fontWeight = FontWeight.w500;
            } else if (weight == 600) {
              cssModel.fontWeight = FontWeight.w600;
            } else if (weight == 700) {
              cssModel.fontWeight = FontWeight.w700;
            } else if (weight == 800) {
              cssModel.fontWeight = FontWeight.w800;
            } else if (weight == 900) {
              cssModel.fontWeight = FontWeight.w900;
            } else {
              cssModel.fontWeight = FontWeight.w500;
            }
          }
        }
        if (key == "height") {
          if (value == "auto") {
            cssModel.height = Height.auto();
          } else {
            if (value.contains(RegExp(r'\d'))) {
              if (value.contains("%")) {
                double size =
                    double.tryParse(value.substring(0, value.length - 1)) ??
                        10.5;
                cssModel.height = Height(size);
              }
              if (value.contains("rem")) {
                double size =
                    double.tryParse(value.substring(0, value.length - 3)) ??
                        10.5;
                cssModel.height = Height(size);
              }
              String unit = value.substring(value.length - 2);
              double size =
                  double.tryParse(value.substring(0, value.length - 2)) ?? 10.5;
              cssModel.height = Height(size);
            }
          }
        }
        if (key == "letter-spacing") {
          cssModel.letterSpacing = double.tryParse(
              value.substring(0, findFirstAlphabeticIndex(value)));
        }
        if (key.contains("margin")) {
          if (value.contains("%")) {
            double size =
                double.tryParse(value.substring(0, value.length - 1)) ?? 10.5;
            cssModel.margin = Margins.all(size);
          } else if (value.contains("rem")) {
            double size =
                double.tryParse(value.substring(0, value.length - 3)) ?? 10.5;
            cssModel.margin = Margins.all(size);
          } else {
            String unit = value.substring(value.length - 2);
            // print(value.substring(0, value.indexOf(RegExp(r'[a-zA-Z]'))));
            int doub = value.indexOf(RegExp(r'[a-zA-Z]'));
            double size =
                double.tryParse(value.substring(0, doub == -1 ? 0 : doub)) ??
                    10.5;
            cssModel.margin = Margins.all(size);
          }
        }
        if (key == "marker") {
          cssModel.marker = Marker(content: Content.normal);
        }
        if (key == "maxlines") {
          cssModel.maxLines = int.tryParse(value);
        }
        if (key == "padding") {
          if (value.contains("%")) {
            double size =
                double.tryParse(value.substring(0, value.length - 1)) ?? 10.5;
            cssModel.padding = HtmlPaddings.all(size);
          }
          if (value.contains("rem")) {
            double size =
                double.tryParse(value.substring(0, value.length - 3)) ?? 10.5;
            cssModel.padding = HtmlPaddings.all(size);
          }
          String unit = value.substring(value.length - 2);
          double size =
              double.tryParse(value.substring(0, value.length - 2)) ?? 10.5;
          cssModel.padding = HtmlPaddings.all(size);
        }
        if (key == "text-align") {
          if (value == "center") {
            cssModel.textAlign = TextAlign.center;
          }
          if (value == "justify") {
            cssModel.textAlign = TextAlign.justify;
          }
          if (value == "left") {
            cssModel.textAlign = TextAlign.left;
          }
          if (value == "right") {
            cssModel.textAlign = TextAlign.right;
          }
        }
        if (key == "text-decoration") {
          if (value == "none") {
            cssModel.textDecoration = TextDecoration.none;
          } else {
            cssModel.textDecoration = TextDecoration.underline;
          }
        }
        if (key == "text-decoration-color") {
          cssModel.textDecorationColor = parseCssColor(value);
        }
        if (key == "text-decoration-style") {
          if (value == "solid") {
            cssModel.textDecorationStyle = TextDecorationStyle.solid;
          }
          if (value == "double") {
            cssModel.textDecorationStyle = TextDecorationStyle.double;
          }
          if (value == "dotted") {
            cssModel.textDecorationStyle = TextDecorationStyle.dotted;
          }
          if (value == "wavy") {
            cssModel.textDecorationStyle = TextDecorationStyle.wavy;
          }
          if (value == "dashed") {
            cssModel.textDecorationStyle = TextDecorationStyle.dashed;
          }
        }
        if (key == "text-overflow") {
          if (value == "clip") {
            cssModel.textOverflow = TextOverflow.clip;
          } else if (value == "ellipsis") {
            cssModel.textOverflow = TextOverflow.ellipsis;
          } else {
            cssModel.textOverflow = TextOverflow.fade;
          }
        }
        if (key == "text-transform") {
          if (value == "capitalize") {
            cssModel.textTransform = TextTransform.capitalize;
          }
          if (value == "uppercase") {
            cssModel.textTransform = TextTransform.uppercase;
          }
          if (value == "lowercase") {
            cssModel.textTransform = TextTransform.lowercase;
          }
        }
        if (key == "vertical-align") {
          if (value == "sub") {
            cssModel.verticalAlign = VerticalAlign.sub;
          }
          if (value == "super") {
            cssModel.verticalAlign = VerticalAlign.sup;
          }
          if (value == "top") {
            cssModel.verticalAlign = VerticalAlign.top;
          }
          if (value == "text-top") {
            cssModel.verticalAlign = VerticalAlign.top;
          }
          if (value == "middle") {
            cssModel.verticalAlign = VerticalAlign.middle;
          }
          if (value == "baseline") {
            cssModel.verticalAlign = VerticalAlign.baseline;
          }
          if (value == "text-bottom") {
            cssModel.verticalAlign = VerticalAlign.bottom;
          }
        }
        if (key == "white-space") {
          if (value == "normal") {
            cssModel.whiteSpace = WhiteSpace.normal;
          }
          if (value == "pre") {
            cssModel.whiteSpace = WhiteSpace.pre;
          }
        }
        if (key == "width") {
          if (value == "auto") {
            cssModel.width = Width.auto();
          } else {
            if (value.contains(RegExp(r'\d'))) {
              if (value.contains("%")) {
                double size =
                    double.tryParse(value.substring(0, value.length - 1)) ??
                        10.5;
                cssModel.width = Width(size);
              }
              if (value.contains("rem")) {
                double size =
                    double.tryParse(value.substring(0, value.length - 3)) ??
                        10.5;
                cssModel.width = Width(size);
              }
              String unit = value.substring(value.length - 2);
              double size =
                  double.tryParse(value.substring(0, value.length - 2)) ?? 10.5;
              cssModel.width = Width(
                  size,
                  unit == "px"
                      ? Unit.px
                      : unit == "em"
                          ? Unit.em
                          : Unit.auto);
            }
          }
        }
        if (key == "word-spacing") {
          cssModel.wordSpacing = double.tryParse(value);
        }
      });
      resultMap.addAll({key1: cssModel});
    });
    return resultMap;
  }

  int findFirstAlphabeticIndex(String input) {
    for (int i = 0; i < input.length; i++) {
      if (isAlphabetic(input[i])) {
        return i;
      }
    }
    return -1; // No alphabetic character found
  }

  bool isAlphabetic(String character) {
    return RegExp(r'[a-zA-Z]').hasMatch(character);
  }

  Color parseCssColor(String cssColor) {
    cssColor = cssColor.trim();

    if (cssColor.startsWith('#')) {
      if (cssColor.length == 7) {
        return Color(int.parse(cssColor.substring(1), radix: 16) + 0xFF000000);
      } else if (cssColor.length == 9) {
        return Color(int.parse(cssColor.substring(1), radix: 16));
      }
    }

    if (cssColor.startsWith('rgb')) {
      final List<String> parts = cssColor
          .substring(cssColor.indexOf('(') + 1, cssColor.indexOf(')'))
          .split(',')
          .map((part) => part.trim())
          .toList();

      if (parts.length == 3 || parts.length == 4) {
        final int r = int.parse(parts[0]);
        final int g = int.parse(parts[1]);
        final int b = int.parse(parts[2]);
        final int a =
            parts.length == 4 ? (double.parse(parts[3]) * 255).toInt() : 255;

        return Color.fromARGB(a, r, g, b);
      }
    }

    return Colors.transparent;
  }

  Border parseCssBorder(String cssBorder) {
    final List<String> parts = cssBorder.split(' ');
    final BorderSide borderSide = BorderSide(
      color: parts.length >= 3 ? parseCssColor(parts[2]) : Colors.black,
      width: parts.length >= 2 ? double.tryParse(parts[1]) ?? 1.0 : 1.0,
      style: parts.isNotEmpty ? parseBorderStyle(parts[0]) : BorderStyle.solid,
    );

    return Border.all(
      color: borderSide.color,
      width: borderSide.width,
      style: borderSide.style,
    );
  }

  BorderStyle parseBorderStyle(String style) {
    switch (style) {
      case 'dotted':
        return BorderStyle.solid;
      case 'dashed':
        return BorderStyle.solid;
      case 'solid':
        return BorderStyle.solid;
      case 'double':
        return BorderStyle.none;
      default:
        return BorderStyle.none;
    }
  }

  Map<String, Style> mapToStyle(Map<String, CssModel> data) {
    Map<String, Style> resultMap = {};
    data.forEach((key, value) {
      if (key != "") {
        resultMap.addAll({
          key: Style(
              after: value.after,
              alignment: value.alignmemt,
              backgroundColor: value.backgroundColor,
              before: value.before,
              border: value.border,
              color: value.color,
              counterIncrement: value.counterIncrement,
              counterReset: value.counterReset,
              direction: value.direction,
              display: value.display,
              fontFamily: value.fontFamily,
              fontFamilyFallback: value.fontFamilyFallback,
              fontFeatureSettings: value.fontFeatureSettings,
              fontSize: value.fontSize,
              fontStyle: value.fontStyle,
              fontWeight: value.fontWeight,
              height: value.height,
              letterSpacing: value.letterSpacing,
              lineHeight: value.lineHeight,
              listStyleImage: value.listStyleImage,
              listStylePosition: value.listStylePosition,
              listStyleType: value.listStyleType,
              margin: value.margin,
              marker: value.marker,
              maxLines: value.maxLines,
              padding: value.padding,
              textAlign: value.textAlign,
              textDecoration: value.textDecoration,
              textDecorationColor: value.textDecorationColor,
              textDecorationStyle: value.textDecorationStyle,
              textDecorationThickness: value.textDecorationThickness,
              textOverflow: value.textOverflow,
              textShadow: value.textShadow,
              textTransform: value.textTransform,
              verticalAlign: value.verticalAlign ?? VerticalAlign.baseline,
              whiteSpace: value.whiteSpace,
              width: value.width,
              wordSpacing: value.wordSpacing)
        });
      }
    });
    return resultMap;
  }
}
