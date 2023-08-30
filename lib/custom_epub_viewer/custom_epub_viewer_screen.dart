import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:demo_ebooks_viewer/custom_epub_viewer/controller/custom_epub_controller.dart';
import 'package:demo_ebooks_viewer/custom_epub_viewer/read_book_screen.dart';
import 'package:demo_ebooks_viewer/custom_epub_viewer/read_book_screen_final.dart';
import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as image;
import 'package:shared_preferences/shared_preferences.dart';

class CustomEpubViewerScreen extends StatefulWidget {
  const CustomEpubViewerScreen({super.key});

  @override
  CustomEpubViewerScreenState createState() => CustomEpubViewerScreenState();
}

class CustomEpubViewerScreenState extends State<CustomEpubViewerScreen> {
  epubx.EpubBook? _epubBook;
  late Directory _imagesDir;

  @override
  void initState() {
    super.initState();
    loadEpubFile();
  }

  Future<void> loadEpubFile() async {
    // Copy EPUB file from assets to a readable file
    String epubFileName = "yathartha_geeta_epub.epub";
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String epubPath = '${appDocDir.path}/$epubFileName';

    if (!File(epubPath).existsSync()) {
      ByteData data = await rootBundle.load('assets/$epubFileName');
      List<int> bytes = data.buffer.asUint8List();
      await File(epubPath).writeAsBytes(bytes);
    }

    // Read the EPUB file into memory
    File epubFile = File(epubPath);
    List<int> bytes = await epubFile.readAsBytes();

    // Parse the EPUB book
    epubx.EpubBook epubBook = await epubx.EpubReader.readBook(bytes);

    // Extract and save images
    _imagesDir = await extractAndSaveImages(epubBook);

    setState(() {
      _epubBook = epubBook;
    });
  }

  Future<Directory> extractAndSaveImages(epubx.EpubBook epubBook) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagesDir = '${appDocDir.path}/epub_images';

    // Create the images directory if it doesn't exist
    if (!Directory(imagesDir).existsSync()) {
      Directory(imagesDir).createSync();
    }

    for (var imageEntry in epubBook.Content!.Images!.entries) {
      String imageName = imageEntry.key;
      String imagePath = '$imagesDir/$imageName';

      // print("MODIFIED IMAGE PATH TO CHECK = ${imagePath}");

      // Save the image
      // await File(imagePath).writeAsBytes(imageEntry.value.Content!);
    }

    return Directory(imagesDir); // Return the directory
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EPUB Reader'),
        centerTitle: true,
      ),
      body: Center(
        child: _epubBook == null
            ? CircularProgressIndicator()
            : EpubViewer(
                book: _epubBook!,
                imagesDir: _imagesDir, // Pass _imagesDir here
              ),
      ),
    );
  }
}

class EpubViewer extends StatefulWidget {
  final epubx.EpubBook book;
  final Directory imagesDir;

  const EpubViewer({super.key, required this.book, required this.imagesDir});

  @override
  State<EpubViewer> createState() => _EpubViewerState();
}

class _EpubViewerState extends State<EpubViewer> {
  // final customEpubController = Get.put(CustomEpubController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // customEpubController.loadLastReadPageIndex();

    //  SharedPreferences.getInstance().then((sharedPrefs) {
    //   customEpubController.prefs = sharedPrefs;
    //   customEpubController.loadLastReadPageIndex().then((value) {
    //     customEpubController.lastReadPageIndex = value - 1;
    //     // _pageController = PageController(initialPage: value);

    //     // print("current index vib= ${_lastReadPageIndex - 1}");
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final List<int>? coverImageBytes = book.CoverImage!.data;

    // var cover = book.CoverImage!.data;

    // Widget imageWidget;
    // try {
    //   if (coverImageBytes != null && coverImageBytes.isNotEmpty) {
    //     imageWidget = Image.memory(Uint8List.fromList(coverImageBytes));
    //   } else {
    //     imageWidget = const Text('No Cover Image');
    //   }
    // } catch (e) {
    //   imageWidget = const Text('Error loading cover image');
    // }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text(coverImageBytes.toString()),
          // Text(cover.toString()),
          // Image.memory(Uint8List.fromList((cover))),

          // for (String imageName in book.Content!.Images!.keys)
          //   Image.file(
          //     File('${imagesDir.path}/$imageName'),
          //     width: 200, // Adjust the width as needed
          //     height: 200, // Adjust the height as needed
          //   ),
          SizedBox(
            height: 400,
            child: Image.memory(
              Uint8List.fromList(
                widget.book.Content!
                    .Images![widget.book.Content!.Images!.keys.first]!.Content!,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Title: ${widget.book.Title ?? 'Unknown'}\n'
              'Author: ${widget.book.Author ?? 'Unknown'}',
              style: TextStyle(fontSize: 15),
            ),
          ),
          // Center(child: BookCoverImage(cover)),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) {
                    return ReadBookScreenFinal(
                      book: widget.book,
                      // intialIndex: customEpubController.lastReadPageIndex,
                    );
                  }),
                  // MaterialPageRoute(
                  //   builder: (context) => ReadBookScreen(
                  //     book: book,
                  //     // imagesDir: imagesDir,
                  //   ),
                  // ),
                );
              },
              child: Text('Read Book'),
            ),
          ),
          // Text(book.Content!.AllFiles.toString()),
          // Text(book.Content!.Images.toString()),
          // Text(book.Content!.Images!.keys.first.toString()),
          // Text(book.Content!.Images!.keys.first.toString()),
          // Load the first image from the Images map
        ],
      ),
    );
  }
}

// Uint8List convertUint32ListToUint8List(Uint32List uint32List) {
//   final uint8List = Uint8List(uint32List.length * 4);
//   for (int i = 0; i < uint32List.length; i++) {
//     uint8List[i * 4] = (uint32List[i] >> 24) & 0xFF;
//     uint8List[i * 4 + 1] = (uint32List[i] >> 16) & 0xFF;
//     uint8List[i * 4 + 2] = (uint32List[i] >> 8) & 0xFF;
//     uint8List[i * 4 + 3] = uint32List[i] & 0xFF;
//   }
//   return uint8List;
// }

// class BookCoverImage extends StatelessWidget {
//   final Uint32List cover;

//   BookCoverImage(this.cover);

//   @override
//   Widget build(BuildContext context) {
//     Uint8List uint8List = convertUint32ListToUint8List(cover);
//     return Image.memory(uint8List);
//   }
// }
