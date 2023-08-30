import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  ScreenOneState createState() => ScreenOneState();
}

class ScreenOneState extends State<ScreenOne> {
  final platform = const MethodChannel('my_channel');
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  @override
  void initState() {
    // download();
    super.initState();
  }

  /// ANDROID VERSION
  // Future<void> fetchAndroidVersion() async {
  //   final String? version = await getAndroidVersion();
  //   if (version != null) {
  //     String? firstPart;
  //     if (version.toString().contains(".")) {
  //       int indexOfFirstDot = version.indexOf(".");
  //       firstPart = version.substring(0, indexOfFirstDot);
  //     } else {
  //       firstPart = version;
  //     }
  //     int intValue = int.parse(firstPart);
  //     if (intValue >= 13) {
  //       await startDownload();
  //     } else {
  //       final PermissionStatus status = await Permission.storage.request();
  //       if (status == PermissionStatus.granted) {
  //         await startDownload();
  //       } else {
  //         await Permission.storage.request();
  //       }
  //     }
  //     print("ANDROID VERSION: $intValue");
  //   }
  // }

  // Future<String?> getAndroidVersion() async {
  //   try {
  //     final String version = await platform.invokeMethod('getAndroidVersion');
  //     return version;
  //   } on PlatformException catch (e) {
  //     print("FAILED TO GET ANDROID VERSION: ${e.message}");
  //     return null;
  //   }
  // }

  // download() async {
  //   if (Platform.isIOS) {
  //     final PermissionStatus status = await Permission.storage.request();
  //     if (status == PermissionStatus.granted) {
  //       await startDownload();
  //     } else {
  //       await Permission.storage.request();
  //     }
  //   } else if (Platform.isAndroid) {
  //     await fetchAndroidVersion();
  //   } else {
  //     PlatformException(code: '500');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBook Library'),
      ),
      body: Center(
        child: loading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Downloading.... E-pub'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     print("=====filePath======$filePath");
                  //     if (filePath == "") {
                  //       // download();
                  //     } else {
                  //       VocsyEpub.setConfig(
                  //         themeColor: Theme.of(context).primaryColor,
                  //         identifier: "iosBook",
                  //         scrollDirection: EpubScrollDirection.HORIZONTAL,
                  //         allowSharing: true,
                  //         enableTts: true,
                  //         nightMode: true,
                  //       );

                  //       // get current locator
                  //       VocsyEpub.locatorStream.listen((locator) {
                  //         print('LOCATOR: $locator');
                  //       });

                  //       VocsyEpub.open(
                  //         filePath,
                  //         lastLocation: EpubLocator.fromJson({
                  //           "bookId": "2239",
                  //           "href": "/OEBPS/ch06.xhtml",
                  //           "created": 1539934158390,
                  //           "locations": {
                  //             "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                  //           }
                  //         }),
                  //       );
                  //     }
                  //   },
                  //   child: Text('Open Online E-pub'),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      VocsyEpub.setConfig(
                        themeColor: Theme.of(context).primaryColor,
                        identifier: "iosBook",
                        scrollDirection: EpubScrollDirection.HORIZONTAL,
                        allowSharing: true,
                        enableTts: true,
                        nightMode: false,
                      );
                      // get current locator
                      VocsyEpub.locatorStream.listen((locator) {
                        debugPrint('LOCATOR: $locator');
                      });
                      await VocsyEpub.openAsset(
                        'assets/yathartha_geeta_epub.epub',
                        lastLocation: EpubLocator.fromJson({
                          "bookId": "2239",
                          "href": "/OEBPS/ch06.xhtml",
                          "created": 1539934158390,
                          "locations": {
                            "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                          }
                        }),
                      );
                    },
                    child: const Text('Open Sample Book'),
                  ),
                ],
              ),
      ),
    );
  }

  // startDownload() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   Directory? appDocDir = Platform.isAndroid
  //       ? await getExternalStorageDirectory()
  //       : await getApplicationDocumentsDirectory();

  //   String path = appDocDir!.path + '/sample.epub';
  //   File file = File(path);

  //   if (!File(path).existsSync()) {
  //     await file.create();
  //     await dio.download(
  //       "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
  //       path,
  //       deleteOnError: true,
  //       onReceiveProgress: (receivedBytes, totalBytes) {
  //         print('Download --- ${(receivedBytes / totalBytes) * 100}');
  //         setState(() {
  //           loading = true;
  //         });
  //       },
  //     ).whenComplete(() {
  //       setState(() {
  //         loading = false;
  //         filePath = path;
  //       });
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //       filePath = path;
  //     });
  //   }
  // }
}
