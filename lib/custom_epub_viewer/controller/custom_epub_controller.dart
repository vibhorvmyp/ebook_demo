// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomEpubController extends GetxController {
//   late SharedPreferences prefs;
//   int lastReadPageIndex = 1;

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   loadLastReadPageIndex() async {
//     lastReadPageIndex = prefs.getInt('lastReadPageIndex') ?? 1;
//     // setState(() {
//     // currentPageIndex = _lastReadPageIndex;
//     return lastReadPageIndex - 1;
//     // });
//   }

//   Future<void> saveLastReadPageIndex(int pageIndex) async {
//     lastReadPageIndex = pageIndex;
//     await prefs.setInt('lastReadPageIndex', pageIndex);
//   }
// }
