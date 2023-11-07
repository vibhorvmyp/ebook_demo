import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

//YE SHOYAB KI FINAL SCREEN H: 7 NOV 2023

class CustomReaderViewScreen extends StatefulWidget {
  const CustomReaderViewScreen({Key? key}) : super(key: key);

  @override
  State<CustomReaderViewScreen> createState() => _CustomReaderViewScreenState();
}

class _CustomReaderViewScreenState extends State<CustomReaderViewScreen> {
  @override
  Widget build(BuildContext context) {
    var data = Get.arguments! as Future<EpubBookRef>;
    double dyanmicFont = 15.sp;
    PageController controller = PageController();
    PageController controller1 = PageController();
    double panDetails = 0;
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder(
                    future: snapshot.data!.getChapters(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index].Title.toString()),
                              onTap: () => controller.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.bounceIn),
                              // subtitle: Column(
                              //   children: snapshot.data![index].SubChapters!
                              //       .map((e) => ListTile(
                              //             title: Text(e.Title.toString()),
                              //           ))
                              //       .toList(),
                              // )
                            );
                          });
                    });
              }
              return const Text("");
            }),
      ),
      appBar: AppBar(
        title: FutureBuilder(
          future: data,
          // initialData: InitialData,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Text(snapshot.data!.Title!)
                : SizedBox.shrink();
          },
        ),
      ),
      body: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: snapshot.data?.getChapters().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data!;
                    return snapshot.hasData
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            // physics: const NeverScrollableScrollPhysics(),
                            controller: controller,
                            // itemCount: data.length,
                            children: data.map((e) {
                              return FutureBuilder<String>(
                                  future: e.readHtmlContent(),
                                  builder: (context, snapshot1) {
                                    // print(snapshot1.data);
                                    return SingleChildScrollView(
                                      child: GestureDetector(
                                        child: Center(
                                          child: SizedBox(
                                            height: 600.h,
                                            width: 300.w,
                                            child: PageView.builder(
                                                controller: controller1,
                                                // physics:
                                                //     const NeverScrollableScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: splitString(
                                                        500.w,
                                                        600.h,
                                                        dyanmicFont.toInt(),
                                                        snapshot1.hasData
                                                            ? snapshot1.data!
                                                            : "")
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  List data = splitString(
                                                      500,
                                                      600,
                                                      dyanmicFont.toInt(),
                                                      snapshot1.hasData
                                                          ? snapshot1.data!
                                                          : "");
                                                  return Html(
                                                    data: data[index],
                                                    style: {
                                                      "body": Style(
                                                        fontSize: FontSize(
                                                            dyanmicFont),
                                                      ),
                                                      "h1": Style(
                                                          color: Colors.blue,
                                                          fontSize: FontSize(
                                                              dyanmicFont)),
                                                      "h2": Style(
                                                          color: Colors.amber,
                                                          fontSize: FontSize(
                                                              dyanmicFont))
                                                    },
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }).toList())
                        : const Text("Data");
                  }
                  return const Text("");
                });
          }),
    );
  }

  List<String> splitString(
      double width, double height, int fontSize, String text) {
    int maxCharacters;
    List<String> listData = [];
    if (width > 0 && height > 0 && fontSize > 0) {
      double maxWidthPerLine = width / fontSize;
      double maxHeight = height / fontSize;
      maxCharacters = (maxWidthPerLine * maxHeight).floor();
      for (int i = 0, j = 1; i <= text.length; j++) {
        if (i + maxCharacters > text.length) {
          String data = text.substring(i, text.length).trim();
          // print(data.lastIndexOf("</"));
          // print(data.lastIndexOf("<([A-Za-z])"));
          listData.add(text.substring(i, text.length).trim());
          i += maxCharacters;
        } else {
          int index = text.substring(i, i + maxCharacters).lastIndexOf(" ");
          print("--->$j $index");
          // print()
          String data = text.substring(i, i + index).trim();
          if (data.length < index) {
            int rem = index - data.length;
            // data += text.substring();
          }
          listData.add(text.substring(i, i + index));
          i += index;
        }
      }
    } else {
      maxCharacters = 0;
    }
    // print(listData);
    return listData;
  }
}
