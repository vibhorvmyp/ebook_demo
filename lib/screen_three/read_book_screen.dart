import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ReadBookScreen extends StatefulWidget {
  final EpubBook book;

  const ReadBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  ReadBookScreenState createState() => ReadBookScreenState();
}

class ReadBookScreenState extends State<ReadBookScreen> {
  double _fontSize = 10.0; // Initial font size
  double _minFontSize = 6.0;
  double _maxFontSize = 30.0;
  int currentPageIndex = 1;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView.builder(
          itemCount: widget.book.Chapters?.length,
          itemBuilder: (context, index) {
            final chapter = widget.book.Chapters![index];
            return ListTile(
              title: Text(chapter.Title ?? 'Chapter $index'),
              onTap: () {
                // Calculate the page index for the selected chapter's first page
                int selectedPageIndex = 0;
                for (int i = 0; i < index; i++) {
                  selectedPageIndex += splitChapterIntoPages(
                          widget.book.Chapters![i].HtmlContent ?? '')
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
        title: Text(
          widget.book.Title.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Center(
          //     child: Text(
          //       'Page $currentPageIndex',
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close)),
        ],
      ),
      body: Column(
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
                final pages = splitChapterIntoPages(chapter.HtmlContent ?? '');

                if (pageIndex >= pages.length) {
                  return Container();
                }

                final pageContent = pages[pageIndex];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Html(
                    data: pageContent,
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
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.orange,
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
                              duration: Duration(milliseconds: 1),
                              curve: Curves.linear,
                            );
                          },
                          icon: Icon(Icons.arrow_back, size: 25),
                        ),
                        IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 1),
                              curve: Curves.linear,
                            );
                          },
                          icon: Icon(Icons.arrow_forward, size: 25),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.4)),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _fontSize = (_fontSize - 2.0)
                                    .clamp(_minFontSize, _maxFontSize);
                              });
                            },
                            icon: Icon(Icons.remove, size: 15),
                          ),
                          Text(
                            'Aa',
                            style: TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _fontSize = (_fontSize + 2.0)
                                    .clamp(_minFontSize, _maxFontSize);
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getTotalPages() {
    // Calculate and return the total number of pages in the book
    int totalPages = 0;
    for (final chapter in widget.book.Chapters ?? []) {
      totalPages += splitChapterIntoPages(chapter.HtmlContent ?? '').length;
    }
    return totalPages;
  }

  int getChapterIndex(int pageIndex) {
    // Calculate and return the index of the chapter that contains the given pageIndex
    int totalChapters = widget.book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = widget.book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '').length;
      if (currentPage + chapterPages > pageIndex) {
        return chapterIndex;
      }
      currentPage += chapterPages;
    }
    return totalChapters - 1; // Return the last chapter if pageIndex is invalid
  }

  int getPageIndex(int pageIndex) {
    // Calculate and return the index of the page within its chapter
    int totalChapters = widget.book.Chapters?.length ?? 0;
    int currentPage = 0;
    for (int chapterIndex = 0; chapterIndex < totalChapters; chapterIndex++) {
      final chapter = widget.book.Chapters![chapterIndex];
      final chapterPages =
          splitChapterIntoPages(chapter.HtmlContent ?? '').length;
      if (currentPage + chapterPages > pageIndex) {
        return pageIndex - currentPage;
      }
      currentPage += chapterPages;
    }
    return 0; // Return 0 if pageIndex is invalid
  }

  List<String> splitChapterIntoPages(String chapterContent) {
    const maxPageLength = 1400; // Adjust as needed
    List<String> pages = [];
    while (chapterContent.isNotEmpty) {
      if (chapterContent.length <= maxPageLength) {
        pages.add(chapterContent);
        chapterContent = '';
      } else {
        final page = chapterContent.substring(0, maxPageLength);
        pages.add(page);
        chapterContent = chapterContent.substring(maxPageLength);
      }
    }
    return pages;
  }
}
