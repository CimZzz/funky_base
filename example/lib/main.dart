import 'package:flutter/material.dart';
import 'package:funky_base/funky_base.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/1234': (context) => Page2()
    },
    home: Page(),
  ));
}

class Page extends BasePage {
  Page() : super("/123");
  
  
  BasePageState createState() => PageState();
}

class PageState extends BasePageState<Page> {
  
  @override
  void onInit() {
  
  }
  
  @override
  Widget onBuildUI(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
//          PageManager.getInstance().pushTo((context) => Page2());
//          pageInterface.pushPage(Page2());
  

        },
        child: Container(
          color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
//                    FunkyBase.test(1).then((version) {
//                      print('1 $version');
//                    });
                  }),
              RaisedButton(
                  onPressed: () {
//                    FunkyBase.test(1).then((version) {
//                      print('2 $version');
//                    });
                  }),
              RaisedButton(
                  onPressed: () {
//                    FunkyBase.test(1).then((version) {
//                      print('3 $version');
//                    });
                  }),
              RaisedButton(
                  onPressed: () {
//                    FunkyBase.test(2).then((version) {
//                      print('4 $version');
//                    });
                  }),
              RaisedButton(
                  onPressed: () {
//                    FunkyBase.test(2).then((version) {
//                      print('5 $version');
//                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void onDestroy() {
  
  }
}


class Page2 extends BasePage {
  Page2() : super("/1234");
  
  
  BasePageState createState() => PageState2();
}

class PageState2 extends BasePageState<Page2> {
  
  @override
  void onInit() {
    
  }
  
  @override
  Widget onBuildUI(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          pageInterface.pushPage(Page3());
        },
        child: Container(
          color: Colors.green,
        ),
      ),
    );
  }
  
  @override
  void onDestroy() {
    
  }
}

class Page3 extends BasePage {
  Page3() : super("/12345");
  
  
  BasePageState createState() => PageState3();
}

class PageState3 extends BasePageState<Page3> {
  
  @override
  void onInit() {
    
  }
  
  @override
  Widget onBuildUI(BuildContext context) {
    return Scaffold(
      body: TextTest()
    );
  }
  
  @override
  void onDestroy() {
    
  }
}

class TextTest extends StatefulWidget {
  @override
  _TextTestState createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> with PageInterfaceChildMixin {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pageInterface.popupUntil('/1234');
      },
      child: Container(
        color: Colors.black,
      ),
    );
  }
}


//void main() => runApp(MyApp());
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  String _platformVersion = 'Unknown';
//
//  @override
//  void initState() {
//    super.initState();
//    initPlatformState();
//  }
//
//  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FunkyBase.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Plugin example app'),
//        ),
//        body: Center(
//          child: Text('Running on: $_platformVersion\n'),
//        ),
//      ),
//    );
//  }
//}
