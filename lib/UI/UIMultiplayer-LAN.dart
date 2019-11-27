import 'package:Connectron/globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MultiPlayerPage extends StatefulWidget {
  MultiPlayerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MultiPlayerState createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.brightness_3),
            onPressed: () {
              DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              //TODO: Add main page help
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(globals.defaultPadding),
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}