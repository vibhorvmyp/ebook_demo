import 'package:demo_ebooks_viewer/pdf_viewer/pdf_viewer_screen.dart';
import 'package:demo_ebooks_viewer/screen_four/screen_four.dart';
import 'package:demo_ebooks_viewer/custom_epub_viewer/custom_epub_viewer_screen.dart';
// import 'package:demo_ebooks_viewer/screen_two/screen_two.dart';
import 'package:flutter/material.dart';

import '../screen_one/screen_one.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            //   child: const Text('Ebook Viewer Vocsy'),
            // ),

            ElevatedButton(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // return ScreenThree();
                      return const PdfViewerScreen(
                        pdfUrl: 'assets/yathartha_geeta_pdf.pdf',

                        // pdfUrl:
                        //     "https://github.com/vibhorvmyp/random/files/12472141/yathartha_geeta_pdf.pdf",
                      );
                    },
                  ),
                );
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  child: const Text('PDF Viewer')),
            ),
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
