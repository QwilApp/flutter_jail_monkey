import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_jail_monkey/flutter_jail_monkey.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isJailBroken;
  bool _canMockLocation;
  bool _isOnExternalStorage;

  @override
  initState() {
    super.initState();
    initMonkeyState();
  }

  initMonkeyState() async {
    setState(() {
      _isJailBroken = null;
      _canMockLocation = null;
      _isOnExternalStorage = null;
    });
    await new Future.delayed(const Duration(milliseconds: 300), () {});

    _isJailBroken = await FlutterJailMonkey.isJailBroken;
    _canMockLocation = await FlutterJailMonkey.canMockLocation;
    _isOnExternalStorage = await FlutterJailMonkey.isOnExternalStorage;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: _isJailBroken == null
              ? const CircularProgressIndicator()
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('JailBroken: $_isJailBroken'),
                    new Text('Mock location: $_canMockLocation'),
                    new Text('External storage: $_isOnExternalStorage(Android only)'),
                  ],
                ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: initMonkeyState,
          child: new Icon(Icons.refresh),
        ),
      ),
    );
  }
}
