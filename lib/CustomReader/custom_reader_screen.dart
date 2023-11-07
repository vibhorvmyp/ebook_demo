import 'dart:typed_data';
import 'package:demo_ebooks_viewer/CustomReader/custom_reader_controller.dart';
import 'package:demo_ebooks_viewer/CustomReader/custom_reader_view_screen.dart';
import 'package:demo_ebooks_viewer/css_to_style.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:image/image.dart' as image;

class CustomReaderScreen extends StatefulWidget {
  const CustomReaderScreen({Key? key}) : super(key: key);

  @override
  State<CustomReaderScreen> createState() => _CustomReaderScreenState();
}

class _CustomReaderScreenState extends State<CustomReaderScreen> {
  Future<EpubBookRef>? book;
  @override
  @override
  Widget build(BuildContext context) {
    CustomReaderController controller = Get.put(CustomReaderController());
    setState(() {
      book = controller.fetchBook(
          "https://github.com/shoyabsiddique0/ott_platform/raw/main/yathartha_geeta_epub.epub");
    });
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: book,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var chapters = snapshot.data?.getChapters();
              var css = snapshot.data?.Content!.Css;
              var imagesList = snapshot.data?.Content!.Images;
              CssToStyle obj = CssToStyle();
              // obj.processData(css!);
              // var html = snapshot.data?.Content!.Html;
              print(chapters);
              var cover = snapshot.data?.readCover();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: cover,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 250.h,
                            width: 200.w,
                            child: widgets.Image.memory(Uint8List.fromList(
                                image.encodePng(snapshot.data!))),
                          );
                        }
                        return Container(
                          width: 200.w,
                          height: 250.h,
                          color: Colors.grey,
                          child: const Text(
                            "No Image Found",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    ),
                    Text(
                      snapshot.data!.Title!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      snapshot.data!.Author!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "All CSS",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: css!.entries
                          .map((value) => FutureBuilder<String>(
                              future: value.value.ReadContentAsync(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? Text(snapshot.data!)
                                    : const Text("");
                              }))
                          .toList(),
                    ),
                    Text(
                      "All Images",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: imagesList!.entries
                          .map((e) => FutureBuilder(
                              future: e.value.readContentAsBytes(),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? widgets.Image.memory(
                                        Uint8List.fromList(snapshot.data!))
                                    : const SizedBox.shrink();
                              }))
                          .toList(),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.to(const CustomReaderViewScreen(),
                              arguments: book);
                        },
                        child: const Text("Go to Book"))
                    // Text(
                    //   "All Files",
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.w600),
                    //   textAlign: TextAlign.center,
                    // ),
                    // Column(
                    //   children: html!.entries
                    //       .map((e) => FutureBuilder(
                    //           future: e.value.readContentAsText(),
                    //           builder: (context, snapshot) {
                    //             return snapshot.hasData
                    //                 ? Text(snapshot.data!)
                    //                 : SizedBox.shrink();
                    //           }))
                    //       .toList(),
                    // )
                  ],
                ),
              );
            }
            return Container(
              width: 200.w,
              height: 250.h,
              color: Colors.grey,
              child: const Text(
                "No Image Found",
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
      ),
    );
  }
}
