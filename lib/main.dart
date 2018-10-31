import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController textEditingController = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  String urlString = 'https://google.com';
  String oldUrl = 'https://google.com';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text = urlString;
  }

  openUrl() {
    setState(() {
      oldUrl = urlString;
      urlString = textEditingController.text;
      if (urlString.contains(' ')) {
        urlString = urlString.replaceAll(' ', '');
        textEditingController.text = urlString;
      }
      if (urlString.contains('http://') || urlString.contains('https://')) {
        if (urlString.endsWith('google.com')) {
          urlString = 'https://google.com';
          flutterWebviewPlugin.reloadUrl(urlString);
        } else
          flutterWebviewPlugin.reloadUrl(urlString);
      } else {
        urlString = 'http://' + urlString;
        flutterWebviewPlugin.reloadUrl(urlString);
      }
      flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
        print(wvs.type);
      });
      flutterWebviewPlugin.onHttpError.listen((WebViewHttpError wve) {
        print(wve.code);
      });
      flutterWebviewPlugin.onUrlChanged.listen((String url) {
        print(url);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                flutterWebviewPlugin.reloadUrl(oldUrl);
                textEditingController.text = oldUrl;
                urlString = oldUrl;
              });
            }),
        title: TextField(
          autofocus: false,
          controller: textEditingController,
          cursorColor: Colors.lightGreenAccent,
          cursorWidth: .9,
          textInputAction: TextInputAction.go,
          onSubmitted: (url) => openUrl(),
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter url here',
              hintStyle: TextStyle(color: Colors.blueGrey)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.navigate_next), onPressed: () => openUrl()),
        ],
      ),
      url: urlString,
      withZoom: true,
    );
  }
}
