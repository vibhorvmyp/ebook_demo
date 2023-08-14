import 'dart:async';
import 'dart:io';

import 'package:demo_ebooks_viewer/screen_three/read_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';

class ScreenThree extends StatefulWidget {
  const ScreenThree({super.key});

  @override
  ScreenThreeState createState() => ScreenThreeState();
}

class ScreenThreeState extends State<ScreenThree> {
  EpubBook? _epubBook;

  @override
  void initState() {
    super.initState();
    loadEpubFile();
  }

  Future<void> loadEpubFile() async {
    // Copy EPUB file from assets to a readable file
    String epubFileName = "sample.epub";
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
    EpubBook epubBook = await EpubReader.readBook(bytes);

    setState(() {
      _epubBook = epubBook;
    });
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
              ),
      ),
    );
  }
}

class EpubViewer extends StatelessWidget {
  final EpubBook book;

  const EpubViewer({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Display book title and author
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Title: ${book.Title ?? 'Unknown'}\n'
              'Author: ${book.Author ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          // Display chapters
          // for (var chapter in book.Chapters ?? [])
          //   ListTile(
          //     title: Text(chapter.Title ?? 'Chapter'),
          //     onTap: () {
          //       // Navigate to chapter content
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChapterViewer(
          //             chapter: chapter,
          //             // book: book,
          //           ), // Pass the book object
          //         ),
          //       );
          //     },
          //   ),

          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to read book screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadBookScreen(
                        book:
                            book), // Create a new screen to display the entire book
                  ),
                );
              },
              child: Text('Read Book'),
            ),
          ),
        ],
      ),
    );
  }
}

// class ChapterViewer extends StatelessWidget {
//   final EpubChapter chapter;
//   // final EpubBook book; // Add this line

//   const ChapterViewer({
//     super.key,
//     required this.chapter,
//     // required this.book,
//   }); // Add the book parameter

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(chapter.Title ?? 'Chapter'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Html(data: chapter.HtmlContent ?? ''),
//       ),
//     );
//   }
// }
