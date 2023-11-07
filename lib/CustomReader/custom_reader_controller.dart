import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:epubx/epubx.dart' as epub;

class CustomReaderController extends GetxController {
  StreamController<int> dyanmicFont = StreamController.broadcast();
  PageController controller = PageController();
  PageController controller1 = PageController();
  double panDetails = 0;
  Future<epub.EpubBookRef>? book;
  Future<epub.EpubBookRef> fetchBook(String url) async {
    // Hard coded to Alice Adventures In Wonderland in Project Gutenberb
    final response = await http.get(Uri.parse(url));

    print("here");

    if (response.statusCode == 200) {
      print("here1");

      // If server returns an OK response, parse the EPUB
      // book = epub.EpubReader.openBook(response.bodyBytes);
      book = epub.EpubReader.openBook(response.bodyBytes);

      print("Book value = ${book}");

      return book!;
    } else {
      // If that response was not OK, throw an error.
      print("here3");
      throw Exception('Failed to load epub');
    }
  }

  @override
  void onInit() {
    dyanmicFont.add(5);
    book = fetchBook(
        "https://cloudflare-ipfs.com/ipfs/bafykbzacec4gybnws52vho7fusjxzbv4f7e6m7yscaqy2altvg4wp7beqqsqw?filename=%28Hindi%20Novel%29%20%E0%A4%A7%E0%A4%B0%E0%A5%8D%E0%A4%AE%E0%A4%B5%E0%A5%80%E0%A4%B0%20%E0%A4%AD%E0%A4%BE%E0%A4%B0%E0%A4%A4%E0%A5%80%2C%20Dharmaveer%20Bharti%20-%20%E0%A4%97%E0%A5%81%E0%A4%A8%E0%A4%BE%E0%A4%B9%E0%A5%8B%E0%A4%82%20%E0%A4%95%E0%A4%BE%20%E0%A4%A6%E0%A5%87%E0%A4%B5%E0%A4%A4%E0%A4%BE%20_%20Gunahon%20Ka%20Devta-Bhartiya%20Sahitya%20Inc.%20%282013%29.epub");
    AsyncSnapshot.waiting();
    fetchBook(
            "https://cloudflare-ipfs.com/ipfs/bafykbzacec4gybnws52vho7fusjxzbv4f7e6m7yscaqy2altvg4wp7beqqsqw?filename=%28Hindi%20Novel%29%20%E0%A4%A7%E0%A4%B0%E0%A5%8D%E0%A4%AE%E0%A4%B5%E0%A5%80%E0%A4%B0%20%E0%A4%AD%E0%A4%BE%E0%A4%B0%E0%A4%A4%E0%A5%80%2C%20Dharmaveer%20Bharti%20-%20%E0%A4%97%E0%A5%81%E0%A4%A8%E0%A4%BE%E0%A4%B9%E0%A5%8B%E0%A4%82%20%E0%A4%95%E0%A4%BE%20%E0%A4%A6%E0%A5%87%E0%A4%B5%E0%A4%A4%E0%A4%BE%20_%20Gunahon%20Ka%20Devta-Bhartiya%20Sahitya%20Inc.%20%282013%29.epub")
        .asStream()
        .isEmpty
        .then((value) => print(value));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
