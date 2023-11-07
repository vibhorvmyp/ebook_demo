import 'package:demo_ebooks_viewer/CustomReader/custom_reader_controller.dart';
import 'package:demo_ebooks_viewer/CustomReader/custom_reader_screen.dart';
import 'package:demo_ebooks_viewer/converted_pdf_viewer/converted_pdf_viewer_screen.dart';
import 'package:demo_ebooks_viewer/pdf_viewer/pdf_viewer_screen.dart';
import 'package:demo_ebooks_viewer/screen_four/screen_four.dart';
import 'package:demo_ebooks_viewer/custom_epub_viewer/custom_epub_viewer_screen.dart';
import 'package:demo_ebooks_viewer/super_screen/super_screen.dart';
import 'package:epubx/epubx.dart';
// import 'package:demo_ebooks_viewer/screen_two/screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen_one/screen_one.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final customReaderController = Get.put(CustomReaderController());

  final String epubUrl =
      "http://skyonliners.com/demo/yatharthgeeta/storage/epub_file/337/accessible_epub_3.epub";

  final String epubUrl2 =
      "https://github.com/shoyabsiddique0/ott_platform/raw/main/yathartha_geeta_epub.epub";

  Future<EpubBookRef>? book;
  Future<EpubBook?>? loadedepubBook;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = customReaderController.fetchBook(epubUrl2);
    loadedepubBook = loadEpubBookFromServer(epubUrl2);
  }

  Future<EpubBook?> loadEpubBookFromServer(String epubUrl) async {
    EpubBook? epubBook;

    try {
      // Download the EPUB file from the server
      final response = await http.get(Uri.parse(epubUrl));

      if (response.statusCode == 200) {
        final epubContent = response.bodyBytes;

        // Load the EPUB book from the downloaded content
        epubBook = await EpubReader.readBook(epubContent);
      } else {
        print('Failed to download EPUB file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading EPUB book: $e');
    }

    return epubBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Ebook Viewer App",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return const ScreenOne();
            //         },
            //       ),
            //     );
            //   },
            //   child: Container(
            //       alignment: Alignment.center,
            //       width: 150,
            //       child: const Text('Ebook Viewer Vocsy')),
            // ),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  }
                  return Colors.grey.shade100;
                }),
                textStyle: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return size 40, otherwise 20
                  if (states.contains(MaterialState.pressed)) {
                    return TextStyle(fontSize: 18);
                  }
                  return TextStyle(fontSize: 15);
                }),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CustomEpubViewerScreen();
                    },
                  ),
                );
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  child: const Text('Ebook Viewer Custom')),
            ),

            ElevatedButton(
                onPressed: () {
                  // Get.to(const CustomReaderViewScreen(),
                  //     arguments: book);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SuperScreen(
                      book: loadedepubBook!,
                      refBook: book!,
                    );
                  }));
                },
                child: const Text("Read Now"))

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           // return ScreenThree();
            //           return const PdfViewerScreen(
            //             pdfUrl: 'assets/yathartha_geeta_pdf.pdf',

            //             // pdfUrl:
            //             //     "https://github.com/vibhorvmyp/random/files/12472141/yathartha_geeta_pdf.pdf",
            //           );
            //         },
            //       ),
            //     );
            //   },
            //   child: Container(
            //       alignment: Alignment.center,
            //       width: 150,
            //       child: const Text('PDF Viewer Converted')),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           // return ScreenThree();
            //           return const ConvertedPdfViewverScreen(
            //             pdfUrl: 'assets/converted_yg.pdf',

            //             // pdfUrl:
            //             //     "https://github.com/vibhorvmyp/random/files/12472141/yathartha_geeta_pdf.pdf",
            //           );
            //         },
            //       ),
            //     );
            //   },
            //   child: Container(
            //       alignment: Alignment.center,
            //       width: 150,
            //       child: const Text('PDF Viewer')),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return const ScreenFour();
            //         },
            //       ),
            //     );
            //   },
            //   child: const Text('Ebook Viewer Ebubx example'),
            // ),
          ],
        ),
      ),
    );
  }
}
