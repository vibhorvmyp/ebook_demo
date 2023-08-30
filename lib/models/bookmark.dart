class Bookmark {
  int chapterIndex;
  int pageIndex;
  bool isBookmarked;
  String chapterTitle;

  Bookmark(
      this.chapterIndex, this.pageIndex, this.isBookmarked, this.chapterTitle);

  Map<String, dynamic> toJson() {
    return {
      'chapterIndex': chapterIndex,
      'pageIndex': pageIndex,
      'isBookmarked': isBookmarked,
      'chapterTitle': chapterTitle,
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      json['chapterIndex'],
      json['pageIndex'],
      json['isBookmarked'],
      json['chapterTitle'],
    );
  }
}
