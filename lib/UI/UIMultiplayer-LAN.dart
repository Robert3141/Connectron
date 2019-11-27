import 'package:Connectron/globals.dart' as globals;
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