// import 'package:flutter/material.dart';
// import 'package:starlight_epub_viewer/starlight_epub_viewer.dart';

// class ScreenTwo extends StatefulWidget {
//   const ScreenTwo({super.key});

//   @override
//   State<ScreenTwo> createState() => _ScreenTwoState();
// }

// class _ScreenTwoState extends State<ScreenTwo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber.shade50,
//       body: SafeArea(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 StarlightEpubViewer.setConfig(
//                   ///for viewer color
//                   themeColor: Colors.blue,

//                   ///night mode for viewer
//                   nightMode: false,

//                   ///scroll direction for viewer
//                   scrollDirection:
//                       StarlightEpubViewerScrollDirection.ALLDIRECTIONS,

//                   ///if you want to share your epub file
//                   allowSharing: true,

//                   ///enable the inbuilt Text-to-Speech
//                   enableTts: true,

//                   ///if you want to show remaining
//                   setShowRemainingIndicator: true,
//                 );
//                 // get current locator
//                 // VocsyEpub.locatorStream.listen((locator) {
//                 //   print('LOCATOR: $locator');
//                 // });
//                 // await VocsyEpub.openAsset(
//                 //   'assets/sample.epub',
//                 //   lastLocation: EpubLocator.fromJson({
//                 //     "bookId": "2239",
//                 //     "href": "/OEBPS/ch06.xhtml",
//                 //     "created": 1539934158390,
//                 //     "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
//                 //   }),
//                 // );
//                 await StarlightEpubViewer.openAsset(
//                   "assets/sample.epub",
//                 );
//               },
//               child: Text('Open Assets E-pub'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
