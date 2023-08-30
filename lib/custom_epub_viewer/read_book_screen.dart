import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bookmark.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:html/parser.dart' show parse, parseFragment;
import 'dart:convert';

class ReadBookScreen extends StatefulWidget {
  final EpubBook book;
  // final Directory? imagesDir;

  const ReadBookScreen({
    Key? key,
    required this.book,
    // required this.imagesDir,
  }) : super(key: key);

  @override
  ReadBookScreenState createState() => ReadBookScreenState();
}

class ReadBookScreenState extends State<ReadBookScreen> {
  @override
  void initState() {
    super.initState();
    _isBookmarkVisible = false;
    loadBookmarks().then((_) {
      setState(() {});
    });
  }

  double _fontSize = 12.0;
  final double _minFontSize = 6.0;
  final double _maxFontSize = 30.0;
  double _zoomFactor = 1.0;
  int currentPageIndex = 1;
  final PageController _pageController = PageController();

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson =
        bookmarks.map((bookmark) => bookmark.toJson()).toList();
    await prefs.setString('bookmarks', json.encode(bookmarksJson));
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString('bookmarks');
    if (bookmarksJson != null) {
      final List<dynamic> bookmarkList = json.decode(bookmarksJson);
      bookmarks = bookmarkList.map((json) => Bookmark.fromJson(json)).toList();
    }
  }

  bool _isBookmarkVisible = false;

  void toggleBookmarkVisibility() {
    setState(() {
      _isBookmarkVisible = !_isBookmarkVisible;
    });
  }

  List<Bookmark> bookmarks = [];

  bool _isCurrentPageBookmarked() {
    if (bookmarks.isEmpty) {
      return false;
    }

    final currentChapterIndex = getChapterIndex(currentPageIndex - 1);
    final currentPageIndexInChapter = getPageIndex(currentPageIndex - 1);
    final currentChapterTitle =
        widget.book.Chapters![currentChapterIndex].Title ?? '';

    return bookmarks.any(
      (bookmark) =>
          bookmark.chapterIndex == currentChapterIndex &&
          bookmark.pageIndex == currentPageIndexInChapter &&
          bookmark.chapterTitle == currentChapterTitle,
    );
  }

  int calculatePageIndex(Bookmark bookmark) {
    int pageIndex = 0;
    for (int i = 0; i < bookmark.chapterIndex; i++) {
      pageIndex += splitChapterIntoPages(
              widget.book.Chapters![i].HtmlContent ?? '', context, _zoomFactor)
          .length;
    }
    return pageIndex + bookmark.pageIndex;
  }

  //Color pciker functionlaity
  bool _isColorPickerVisible = false;

  Color _selectedBackgroundColor = Colors.white;

  concatenateAndCleanCss(contentFiles) {
    String concatenatedCss = '';

    print('contentFiles = ${contentFiles.length}');
    print('contentFiles2 = ${widget.book.Content?.AllFiles?.values}');

    for (EpubContentFile contentFile in contentFiles) {
      if (contentFile.FileName!.endsWith('.css')) {
        print(contentFile.FileName);
        log("HINDI book content css ${widget.book.Content!.Css![contentFile.FileName.toString()]!.Content.toString()}");
        concatenatedCss = widget
            .book.Content!.Css![contentFile.FileName.toString()]!.Content
            .toString();
      }
    }

    final cleanedCssContent = concatenatedCss.replaceAllMapped(
      RegExp(
        r':nth-of-type\([^)]+\)',
      ),
      (match) => '',
    );

    return cleanedCssContent;
  }

  @override
  Widget build(BuildContext context) {
    // log("boom schema package ${widget.book.Schema!.Package.toString()}");
    // log("book content all files ${widget.book.Content!.AllFiles.toString()}");
    // log("book content html ${widget.book.Content!.Html.toString()}");
    // log("ENGLISH book content css ${widget.book.Content!.Css!['css/epub.css']!.Content.toString()}");
    // log("HINDI book content css ${widget.book.Content!.Css!['stylesheet.css']?.Content.toString()}");

    return Scaffold(
      backgroundColor: _selectedBackgroundColor,
      drawer: Drawer(
        backgroundColor: _selectedBackgroundColor == Colors.black
            ? Colors.black
            : _selectedBackgroundColor == Colors.grey.shade800
                ? Colors.grey.shade800
                : Colors.white,
        child: ListView.separated(
          itemCount: widget.book.Chapters!.length,
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.orange,
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            final chapter = widget.book.Chapters![index];
            return ListTile(
              title: Text(
                chapter.Title ?? 'Chapter $index',
                style: TextStyle(
                  color: _selectedBackgroundColor == Colors.black
                      ? Colors.white
                      : _selectedBackgroundColor == Colors.grey.shade800
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              onTap: () {
                int selectedPageIndex = 0;
                for (int i = 0; i < index; i++) {
                  selectedPageIndex += splitChapterIntoPages(
                          widget.book.Chapters![i].HtmlContent ?? '',
                          context,
                          _zoomFactor)
                      .length;
                }
                _pageController.jumpToPage(selectedPageIndex);
                setState(() {
                  currentPageIndex = selectedPageIndex + 1;
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: _selectedBackgroundColor == Colors.black
            ? Colors.grey.shade800
            : _selectedBackgroundColor == Colors.grey.shade800
                ? Colors.black
                : Colors.orange,
        title: Text(
          widget.book.Title.toString(),
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     // showBookmarks();
          //     // setState(() {
          //     toggleBookmarkVisibility();
          //     // });
          //   },
          //   icon: Container(
          //     height: 20,
          //     width: 20,
          //     child: img.Image.asset(
          //       'assets/images/bookmark_list.png',
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // if (!_isBookmarkVisible)
          //   IconButton(
          //     onPressed: () {
          //       setState(() {
          //         final currentChapterIndex =
          //             getChapterIndex(currentPageIndex - 1);
          //         final currentPageIndexInChapter =
          //             getPageIndex(currentPageIndex - 1);

          //         final existingBookmark = bookmarks.firstWhere(
          //           (bookmark) =>
          //               bookmark.chapterIndex == currentChapterIndex &&
          //               bookmark.pageIndex == currentPageIndexInChapter,
          //           orElse: () =>
          //               Bookmark(-1, -1, false, ''), //empty placeholder
          //         );

          //         if (existingBookmark.isBookmarked) {
          //           // Page is already bookmarked, remove it
          //           bookmarks.remove(existingBookmark);
          //           saveBookmarks();
          //         } else {
          //           // Page is not bookmarked, add it
          //           final chapterTitle =
          //               widget.book.Chapters![currentChapterIndex].Title ?? '';
          //           final bookmark = Bookmark(currentChapterIndex,
          //               currentPageIndexInChapter, true, chapterTitle);
          //           bookmarks.add(bookmark);
          //           saveBookmarks();
          //         }
          //       });
          //     },
          //     icon: _isCurrentPageBookmarked()
          //         ? const Icon(
          //             Icons.bookmark,
          //             color: Colors.white,
          //           )
          //         : const Icon(
          //             Icons.bookmark_border,
          //             color: Colors.white,
          //           ),
          //   ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // if (!_isBookmarkVisible)
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: getTotalPages(),
                  controller: _pageController,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      currentPageIndex = pageIndex + 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    final chapterIndex = getChapterIndex(index);
                    final pageIndex = getPageIndex(index);
                    final chapter = widget.book.Chapters![chapterIndex];
                    final pages = splitChapterIntoPages(
                        chapter.HtmlContent ?? '', context, _zoomFactor);

                    if (pageIndex >= pages.length) {
                      return Container();
                    }

                    var pageContent = pages[pageIndex];

                    // Add image paths to the page content
                    // for (var imageName in widget.book.Content!.Images!.keys) {
                    //   pageContent = pageContent.replaceAll('src="$imageName"',
                    //       'src="${widget.imagesDir!.path}/$imageName"');
                    // }

                    print('MODIFIED Page Content = ${pageContent}');

                    final cssContent = concatenateAndCleanCss(
                        widget.book.Content?.AllFiles?.values);

                    // final htmlContent =
                    //     generateHtmlContent(cssContent, pageContent);

                    //     print("MODIFIED htmlContent = $htmlContent");

                    // Modify the image src paths in the HTML content

                    final modifiedHtmlContent = modifyHtmlWithImagePaths(
                      pageContent,
                      cssContent,
                      widget.book,
                      // widget.imagesDir!,
                    );

                    // final processedHtmlContent = processHtmlImages(
                    //   modifiedHtmlContent,
                    //   widget.book,
                    //   widget.imagesDir!,
                    // );

                    // log("processedHtmlContent${processedHtmlContent}");

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Html(
                        data: modifiedHtmlContent,
                        style: {
                          "body": Style(fontSize: FontSize(_fontSize)),
                        },
                      ),
                    );

                    // return SingleChildScrollView(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: HtmlWidget(
                    //     modifiedHtmlContent,
                    //     customWidgetBuilder: (element) {
                    //       if (element.localName == "img") {
                    //         for (var i in element.attributes.entries) {
                    //           if (i.key == "src") {
                    //             final imagePath = Uri.decodeFull(i.value);
                    //             final imageFile = File(
                    //                 '${widget.imagesDir!.path}/$imagePath');
                    //             if (imageFile.existsSync()) {
                    //               return FutureBuilder(
                    //                 future: imageFile.readAsBytes(),
                    //                 builder: (context, snapshot) {
                    //                   if (snapshot.connectionState ==
                    //                           ConnectionState.done &&
                    //                       snapshot.hasData) {
                    //                     return img.Image.memory(
                    //                         Uint8List.fromList(snapshot.data!));
                    //                   } else {
                    //                     return SizedBox.shrink();
                    //                   }
                    //                 },
                    //               );
                    //             }
                    //           }
                    //         }
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // );
                  },
                ),
              ),
            ],
          ),

          // Bookmarks List
          if (_isBookmarkVisible)
            Scaffold(
              backgroundColor: _selectedBackgroundColor,
              body: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    _selectedBackgroundColor == Colors.black ||
                                            _selectedBackgroundColor ==
                                                Colors.grey.shade800
                                        ? Colors.grey
                                        : Colors.orange.shade200,
                              ),
                              padding: const EdgeInsets.only(
                                  left: 30, top: 10, bottom: 15),
                              child: Text(
                                'Bookmarks',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: _selectedBackgroundColor ==
                                                Colors.black ||
                                            _selectedBackgroundColor ==
                                                Colors.grey.shade800
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    _selectedBackgroundColor == Colors.black ||
                                            _selectedBackgroundColor ==
                                                Colors.grey.shade800
                                        ? Colors.grey
                                        : Colors.orange.shade200,
                              ),
                              child: const Divider(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: bookmarks.map((bookmark) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    bookmark.chapterTitle,
                                    style: TextStyle(
                                        color: _selectedBackgroundColor ==
                                                    Colors.black ||
                                                _selectedBackgroundColor ==
                                                    Colors.grey.shade800
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  subtitle: Text(
                                    'Page ${bookmark.pageIndex + 1}',
                                    style: TextStyle(
                                        color: _selectedBackgroundColor ==
                                                    Colors.black ||
                                                _selectedBackgroundColor ==
                                                    Colors.grey.shade800
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  leading: IconButton(
                                    icon: Icon(
                                      bookmark.isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: bookmark.isBookmarked
                                          ? _selectedBackgroundColor ==
                                                  Colors.black
                                              ? Colors.grey
                                              : Colors.black54
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (bookmark.isBookmarked) {
                                          bookmarks.remove(bookmark);
                                          saveBookmarks();
                                        } else {
                                          bookmarks.add(bookmark);
                                          saveBookmarks();
                                        }
                                        bookmark.isBookmarked =
                                            !bookmark.isBookmarked;
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      toggleBookmarkVisibility();
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      _pageController.jumpToPage(
                                          calculatePageIndex(bookmark));
                                    });
                                  },
                                ),
                                const Divider(
                                  color: Colors.orange,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

          //This should slide up and down
          // if (!_isBookmarkVisible)
          //   AnimatedPositioned(
          //     duration: const Duration(milliseconds: 300), // Animation duration
          //     curve: Curves.easeInOut,
          //     bottom: _isColorPickerVisible ? 0 : -100,
          //     right: 52,
          //     child: Container(
          //       height: 100,
          //       width: 30,
          //       color: Colors.black54,
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 2),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             GestureDetector(
          //               onTap: () {
          //                 // Handle color selection
          //                 setState(() {
          //                   _selectedBackgroundColor = Colors.white;

          //                   _isColorPickerVisible = !_isColorPickerVisible;
          //                 });
          //               },
          //               child: Container(
          //                 width: 20,
          //                 height: 20,
          //                 decoration: const BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors.white, // Customize the circle color
          //                 ),
          //               ),
          //             ),
          //             // SizedBox(height: 10),
          //             GestureDetector(
          //               onTap: () {
          //                 // Handle color selection
          //                 setState(() {
          //                   _selectedBackgroundColor = Colors.amber.shade50;
          //                   _isColorPickerVisible = !_isColorPickerVisible;
          //                 });
          //               },
          //               child: Container(
          //                 width: 20,
          //                 height: 20,
          //                 decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors
          //                       .amber.shade50, // Customize the circle color
          //                 ),
          //               ),
          //             ),
          //             // SizedBox(height: 10),
          //             GestureDetector(
          //               onTap: () {
          //                 // Handle color selection
          //                 setState(() {
          //                   _selectedBackgroundColor = Colors.grey.shade800;
          //                   _isColorPickerVisible = !_isColorPickerVisible;
          //                 });
          //               },
          //               child: Container(
          //                 width: 20,
          //                 height: 20,
          //                 decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors
          //                       .grey.shade800, // Customize the circle color
          //                 ),
          //               ),
          //             ),
          //             // SizedBox(height: 10),
          //             GestureDetector(
          //               onTap: () {
          //                 // Handle color selection
          //                 setState(() {
          //                   _selectedBackgroundColor = Colors.black;
          //                   _isColorPickerVisible = !_isColorPickerVisible;
          //                 });
          //               },
          //               child: Container(
          //                 width: 20,
          //                 height: 20,
          //                 decoration: const BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors.black,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
      bottomNavigationBar: (!_isBookmarkVisible)
          ? Container(
              height: 50,
              color: _selectedBackgroundColor == Colors.black
                  ? Colors.grey.shade800
                  : _selectedBackgroundColor == Colors.grey.shade800
                      ? Colors.black
                      : Colors.orange,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 1),
                                    curve: Curves.linear,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 1),
                                    curve: Curves.linear,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.2)),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _fontSize = (_fontSize - 2.0).clamp(
                                              _minFontSize, _maxFontSize);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: const Text(
                                        'Aa',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _fontSize = (_fontSize + 2.0).clamp(
                                              _minFontSize, _maxFontSize);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              //color picker
                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       _isColorPickerVisible =
                              //           !_isColorPickerVisible; // Toggle visibility
                              //     });
                              //   },
                              //   child: Stack(
                              //     children: [
                              //       Container(
                              //         decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             border: Border.all(
                              //                 color: Colors.black54)),
                              //         child: Icon(
                              //           Icons.circle,
                              //           color: _selectedBackgroundColor,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              const SizedBox(
                                width: 10,
                              ),

                              //Restore back to the original size
                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       _fontSize = 12.0;
                              //       _zoomFactor = 1.0;
                              //     });
                              //   },
                              //   child: const Icon(
                              //     Icons.restore,
                              //     color: Colors.white,
                              //   ),
                              // ),

                              // const SizedBox(
                              //   width: 20,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  // String processHtmlImages(
  //     String htmlContent, EpubBook book, Directory imagesDir) {
  //   final document = parse(htmlContent);

  //   print('Number of img elements: ${document.querySelectorAll('img').length}');

  //   document.querySelectorAll('img').forEach((imgElement) {
  //     final srcAttribute = imgElement.attributes['src'];
  //     if (srcAttribute != null) {
  //       final imagePath = Uri.decodeFull(srcAttribute);
  //       final imageFile = File('${imagesDir.path}/$imagePath');
  //       print('Image Path: $imagePath');
  //       print('Image File Path: ${imageFile.path}');
  //       if (imageFile.existsSync()) {
  //         final imageBytes = imageFile.readAsBytesSync();
  //         final imgTagReplacement =
  //             '<img src="data:image;base64,${base64Encode(imageBytes)}">';
  //         imgElement.replaceWith(parseFragment(imgTagReplacement));
  //       }
  //       print('imgTagReplacement: ${imageFile.path}');
  //     }
  //   });

  //   print("outerhtml ${document.outerHtml}");

  //   return document.outerHtml;
  // }

  int getTotalPages() {
    int totalPages = 0;
    for (final chapter in widget.book.Chapters ?? []) {
      totalPages +=
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
    }
    return totalPages;
  }

  int getChapterIndex(int pageIndex) {
    int totalChapters = widget.book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = widget.book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
      if (currentPage + chapterPages > pageIndex) {
        return chapterIndex;
      }
      currentPage += chapterPages;
    }
    return totalChapters - 1;
  }

  int getPageIndex(int pageIndex) {
    int totalChapters = widget.book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = widget.book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
              .length;
      if (currentPage + chapterPages > pageIndex) {
        return pageIndex - currentPage;
      }
      currentPage += chapterPages;
    }
    return 0;
  }

  List<String> splitChapterIntoPages(
      String chapterContent, BuildContext context, double zoomFactor) {
    int maxPageLength = getMaxPageLength(context, zoomFactor);
    List<String> pages = [];

    List<String> lines = chapterContent.split('\n');

    String currentPage = '';
    for (String line in lines) {
      // List<String> words = line.split(' ');

      if ('$currentPage ${line.trim()}'.length <= maxPageLength) {
        currentPage = '$currentPage ${line.trim()}';
      } else {
        pages.add(currentPage);

        currentPage = line.trim();
      }
    }
    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  int getMaxPageLength(BuildContext context, double zoomFactor) {
    double availableHeight = MediaQuery.of(context).size.height - 70;
    int maxLines = (availableHeight / (_fontSize * 1.5 * zoomFactor)).floor();
    double averageCharWidth = 8.0;
    int maxCharsPerLine =
        (MediaQuery.of(context).size.width / averageCharWidth).floor();
    int maxPageLength = maxLines * maxCharsPerLine;
    return maxPageLength;
  }

  String modifyHtmlWithImagePaths(
    String bodyContent,
    String cssContent,
    EpubBook book,
    // Directory imagesDir,
  ) {
    return '''
    <html>
      <head>
        <style>
          $cssContent
        </style>
      </head>
      <body>
        $bodyContent
      </body>
    </html>
  ''';
  }
}

//   String generateHtmlContent(String cssContent, String bodyContent) {
//     return '''
//       <html>
//         <head>
//           <style>
//             $cssContent
//           </style>
//         </head>
//         <body>
//           $bodyContent
//         </body>
//       </html>
//     ''';
//   }
// }

  // List<String> splitChapterIntoPages(
  //     String chapterContent, BuildContext context, double zoomFactor) {
  //   int maxPageLength = getMaxPageLength(context, zoomFactor);
  //   List<String> pages = [];
  //   while (chapterContent.isNotEmpty) {
  //     if (chapterContent.length <= maxPageLength) {
  //       pages.add(chapterContent);
  //       chapterContent = '';
  //     } else {
  //       final page = chapterContent.substring(0, maxPageLength);
  //       pages.add(page);
  //       chapterContent = chapterContent.substring(maxPageLength);
  //     }
  //   }
  //   return pages;
  // }




                    // String concatenateAndCleanCss() {
                    //   String concatenatedCss = '';

                    //   if (widget.book.Content != null &&
                    //       widget.book.Content!.AllFiles != null) {
                    //     for (var contentFile
                    //         in widget.book.Content!.AllFiles!.values) {
                    //       if (contentFile.FileName!.endsWith('.css')) {
                    //         concatenatedCss += contentFile.Content + '\n';
                    //       }
                    //     }
                    //   }

                    //   // Remove the :nth-of-type selector from the concatenated CSS content
                    //   final cleanedCssContent =
                    //       concatenatedCss.replaceAllMapped(
                    //     RegExp(
                    //       r':nth-of-type\([^)]+\)', // Regular expression to match :nth-of-type selector
                    //     ),
                    //     (match) => '', // Replace the match with an empty string
                    //   );

                    //   return cleanedCssContent;
                    // }

                    // final cssContent = concatenateAndCleanCss(
                    //     widget.book.Content?.AllFiles?.values);

                    //ENGLISH BOOK CONTENT
                    // final cssContent =
                    //     widget.book.Content!.Css!['css/epub.css']!.Content;
                    //  final cssContentMimeType = widget
                    //     .book.Content!.Css!['css/epub.css']!.ContentMimeType;
                    // final cssContentType =
                    //     widget.book.Content!.Css!['css/epub.css']!.ContentType;

                    // log("HINDI book content css ${widget.book.Content!.Css!['stylesheet.css']!.Content.toString()}");

                    // final cssContent =
                    //     widget.book.Content!.Css!['stylesheet.css']!.Content;

                    //  final cssContent =
                    //     widget.book.Content!.Css!['css/epub.css']!.Content;

                    // final cssContent =
                    //     widget.book.Content!.Css!['css/epub.css']!.Content;
                    // final cleanedCssContent = cssContent?.replaceAllMapped(
                    //   RegExp(
                    //       r':nth-of-type\([^)]+\)'), // Regular expression to match :nth-of-type selector
                    //   (match) => '', // Replace the match with an empty string
                    // );

                    // print("css content = $cssContent");
                    // print("css cssContentMimeType = $cssContentMimeType");
                    // print("css cssContentType = $cssContentType");

                    // final htmlContent =
                    //     generateHtmlContent(cssContent, pageContent);

                    // final completeHtmlContent = '''
                    //   <html>
                    //     <head>
                    //       <style>
                    //         /* CSS rules*/
                    //         ${widget.book.Content!.Css!['css/epub.css']!.Content}
                    //       </style>
                    //     </head>
                    //     <body>
                    //       ${pageContent}
                    //     </body>
                    //   </html>
                    // ''';

