import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ConvertedPdfViewverScreen extends StatelessWidget {
  final String pdfUrl;

  const ConvertedPdfViewverScreen({Key? key, required this.pdfUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        // title: Text(
        //   'PDF Viewer',
        // ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.all(mediaQuery.height * 0.015),
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.orange,
              ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.orange,
          ),
        ),
        child: Container(
          color: Colors.white,
          child: SfPdfViewerTheme(
            data: SfPdfViewerThemeData(
              backgroundColor: Colors.white,
            ),
            child: SfPdfViewer.asset('assets/converted_yg.pdf',
                canShowPaginationDialog: true,
                scrollDirection: PdfScrollDirection.vertical,
                pageLayoutMode: PdfPageLayoutMode.single),
          ),
        ),
        // child: SfPdfViewer.network(
        //   pdfUrl,
        //   canShowPaginationDialog: true,
        // ),
      ),
    );
  }
}
