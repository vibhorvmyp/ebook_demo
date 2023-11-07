import 'package:epubx/src/ref_entities/epub_text_content_file_ref.dart';
import 'package:flutter/material.dart';

class CssToStyle {
  Future<String> processData(
      Map<String, EpubTextContentFileRef> cssObject) async {
    String data = "";
    for (EpubTextContentFileRef file in cssObject.values) {
      data += await file.ReadContentAsync();
    }
    // print(data);
    AsyncSnapshot.waiting();
    return data;
  }

  Map<String, Map<String, String>> parseCSSString(String cssString) {
    Map<String, Map<String, String>> result = {};

    List<String> lines = cssString.split('\n');
    String currentSelector = "";
    Map<String, String> currentProperties = {};

    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty) {
        if (line.endsWith('{')) {
          currentSelector = line.substring(0, line.length - 1).trim();
          currentProperties = {};
        } else if (line.endsWith('}')) {
          result[currentSelector] = currentProperties;
          currentSelector = "";
        } else {
          List<String> parts = line.split(':');
          if (parts.length == 2) {
            String property = parts[0].trim();
            String value = parts[1].trim();
            currentProperties[property] = value;
          }
        }
      }
    }
    return result;
  }
  
}
