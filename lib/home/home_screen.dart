import 'package:demo_ebooks_viewer/screen_four/screen_four.dart';
import 'package:demo_ebooks_viewer/screen_three/screen_three.dart';
// import 'package:demo_ebooks_viewer/screen_two/screen_two.dart';
import 'package:flutter/material.dart';

import '../screen_one/screen_one.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ebook Viewer App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScreenOne();
                    },
                  ),
                );
              },
              child: const Text('Ebook Viewer 1'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return const ScreenTwo();
            //         },
            //       ),
            //     );
            //   },
            //   child: const Text('Ebook Viewer 2'),
            // ),
            //
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScreenThree();
                    },
                  ),
                );
              },
              child: const Text('Ebook Viewer 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScreenFour();
                    },
                  ),
                );
              },
              child: const Text('Ebook Viewer 3'),
            ),
          ],
        ),
      ),
    );
  }
}
