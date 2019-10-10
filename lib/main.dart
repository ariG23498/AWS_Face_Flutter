import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/selfie.dart';
import 'pages/upload.dart';

void main() => runApp(MaterialApp(
      home: HomeApp(),
      title: "resizeIO",
      debugShowCheckedModeBanner: false,
    ));

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Selfie(),
    UploadBuffer(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color

      statusBarIconBrightness: Brightness.light, //top icon color
      systemNavigationBarIconBrightness: Brightness.light, //bottom icons color
    ));
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new PreferredSize(
        child: new Container(
          padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: new Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: new Text(
              'resizeIO',
              style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xFF00e4d0), Color(0xFF5983e8)]),
          ),
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text(
              "Selfie",
              style: TextStyle(
                  color:
                      _currentIndex == 0 ? Colors.blue : Colors.grey.shade800),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text(
              "Upload Buffer",
              style: TextStyle(
                  color:
                      _currentIndex == 1 ? Colors.blue : Colors.grey.shade800),
            ),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
