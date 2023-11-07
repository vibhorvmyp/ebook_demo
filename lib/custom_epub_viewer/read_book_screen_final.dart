import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';
import 'package:html/parser.dart' show parse;

// YE SCREEN FINAL H STATIC EPUB K LIYE: 07 NOV 2023

class ReadBookScreenFinal extends StatefulWidget {
  final EpubBook book;
  // final Directory? imagesDir;

  const ReadBookScreenFinal({
    Key? key,
    required this.book,
    // required this.imagesDir,
  }) : super(key: key);

  @override
  ReadBookScreenFinalState createState() => ReadBookScreenFinalState();
}

class ReadBookScreenFinalState extends State<ReadBookScreenFinal> {
  // late PageController _pageController;
  late Future<PageController> _pageControllerFuture;
  late SharedPreferences _prefs;
  int _lastReadPageIndex = 1;

  // String epubContent = '';

  @override
  void initState() {
    super.initState();
    _isBookmarkVisible = false;

    // SharedPreferences.getInstance().then((prefs) {
    //   _prefs = prefs;
    //   _loadLastReadPageIndex().then((value) {
    //     _pageController = PageController(initialPage: value);
    //     setState(() {});

    //     print("current index vib= ${_lastReadPageIndex - 1}");
    //   });
    // });
    // _initializePageController();
    _pageControllerFuture = _initializePageController();

    // loadEpubContent();

    loadBookmarks().then((_) {
      // maxPageLength = getMaxPageLength(
      //     context, _zoomFactor); // Calculate the max page length
      setState(() {});
    });
  }

  // Future<void> loadEpubContent() async {
  //   final String content =
  //       await readEpubFile('assets/yathartha_geeta_epub.epub');
  //   setState(() {
  //     epubContent = content;
  //   });
  // }

  Future<PageController> _initializePageController() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;

    final lastReadPageIndex = await _loadLastReadPageIndex();
    final _pageController = PageController(initialPage: lastReadPageIndex);

    print("current index vib= ${lastReadPageIndex - 1}");

    return _pageController;
  }
  // void recreatePageController(int initialPage) {
  //   _pageController.dispose();
  //   _pageController = PageController(initialPage: initialPage);
  //   setState(() {});
  // }

  _loadLastReadPageIndex() async {
    _lastReadPageIndex = _prefs.getInt('lastReadPageIndex') ?? 1;
    // setState(() {
    currentPageIndex = _lastReadPageIndex;
    return currentPageIndex - 1;
    // });
  }

  Future<void> _saveLastReadPageIndex(int pageIndex) async {
    _lastReadPageIndex = pageIndex;
    await _prefs.setInt('lastReadPageIndex', pageIndex);
  }

  // int maxPageLength = 0;

  // int calculateTotalPages() {
  //   int totalPages = 0;
  //   for (final chapter in widget.book.Chapters ?? []) {
  //     final chapterPages =
  //         splitChapterIntoPages(chapter.HtmlContent ?? '', context, _zoomFactor)
  //             .length;
  //     print('Chapter: ${chapter.Title}, Pages: $chapterPages');
  //     totalPages += chapterPages;
  //   }
  //   print('Total Pages: $totalPages');
  //   return totalPages;
  // }

  double _fontSize = 12.0;
  final double _minFontSize = 6.0;
  final double _maxFontSize = 30.0;
  double _zoomFactor = 1.0;
  int currentPageIndex = 1;

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
        // log("HINDI book content css ${widget.book.Content!.Css![contentFile.FileName.toString()]!.Content.toString()}");
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
    return FutureBuilder<PageController>(
        future: _pageControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or any loading widget
          }

          final _pageController = snapshot.data;
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
                      _pageController!.jumpToPage(selectedPageIndex);
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
              title: Row(
                children: [
                  Text(
                    widget.book.Title.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
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
                Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          itemCount: getTotalPages(),
                          controller: _pageController,
                          onPageChanged: (pageIndex) {
                            setState(() {
                              currentPageIndex = pageIndex + 1;
                            });
                            _saveLastReadPageIndex(currentPageIndex);
                          },

                          // child: PageView.builder(
                          //   itemCount:
                          //       1, // Display the entire ePub content as one page
                          //   controller: _pageController,
                          //   onPageChanged: (pageIndex) {
                          //     setState(() {
                          //       currentPageIndex = pageIndex + 1;
                          //     });
                          //     _saveLastReadPageIndex(currentPageIndex);
                          //   },

                          // itemBuilder: (context, index) {
                          //   return SingleChildScrollView(
                          //     padding: const EdgeInsets.all(16.0),
                          //     child: Html(
                          //       data:
                          // epubContent, // Display the entire ePub content
                          //       style: {
                          //         "body": Style(fontSize: FontSize(_fontSize)),
                          //       },
                          //     ),
                          //   );
                          // },
                          itemBuilder: (context, index) {
                            final chapterIndex = getChapterIndex(index);
                            final pageIndex = getPageIndex(index);
                            final chapter = widget.book.Chapters![chapterIndex];
                            final pages = splitChapterIntoPages(
                                chapter.HtmlContent ?? '',
                                context,
                                _zoomFactor);

                            if (pageIndex >= pages.length) {
                              return Container();
                            }

                            var pageContent = pages[pageIndex];

                            print('MODIFIED Page Content = ${pageContent}');

                            final cssContent = concatenateAndCleanCss(
                                widget.book.Content?.AllFiles?.values);

                            final modifiedHtmlContent =
                                modifyHtmlWithImagePaths(
                              pageContent,
                              cssContent,
                              widget.book,
                              // widget.imagesDir!,
                            );

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Html(
                                data: modifiedHtmlContent,
                                style: {
                                  "body": Style(fontSize: FontSize(_fontSize)),
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                                        _pageController!.previousPage(
                                          duration:
                                              const Duration(milliseconds: 1),
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
                                        _pageController!.nextPage(
                                          duration:
                                              const Duration(milliseconds: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white.withOpacity(0.2)),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _fontSize = (_fontSize - 2.0)
                                                    .clamp(_minFontSize,
                                                        _maxFontSize);
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
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _fontSize = (_fontSize + 2.0)
                                                    .clamp(_minFontSize,
                                                        _maxFontSize);
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      child: Text(
                                        '$currentPageIndex/${getTotalPages()}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
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
        });
  }

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

  // Future<String> readEpubFile(String filePath) async {
  //   // File _epubFile = File(filePath);
  //   // final contents = await _epubFile.readAsBytes();

  //   final ByteData bytes =
  //       await rootBundle.load('assets/yathartha_geeta_epub.epub');
  //   final List<int> epubBytes = bytes.buffer.asUint8List();

  //   EpubBookRef epub = await EpubReader.openBook(epubBytes.toList());
  //   var cont = await EpubReader.readTextContentFiles(epub.Content!.Html!);
  //   List<String> htmlList = [];
  //   for (var value in cont.values) {
  //     htmlList.add(value.Content!);
  //   }
  //   var doc = parse(htmlList.join());
  //   final String parsedString = parse(doc.body!.text).documentElement!.text;

  //   return parsedString;
  // }

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
