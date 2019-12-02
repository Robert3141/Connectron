

import 'dart:ui';

import 'package:Connectron/UI/UIMultiplayer-LAN.dart';
import 'package:Connectron/UI/UIsettings.dart';
import 'package:Connectron/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppPage extends StatefulWidget {
  HomeAppPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeAppPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(globals.defaultPadding),
        child: ListView(
          children: [
            Container(
              width: 200,//TODO: set as global const
              height: 200,//TODO: set as global const
              alignment: Alignment.center,
              child: Image(image: AssetImage('assets/ic_launcher-web.png')),//TODO: set as global const
            ),

            RaisedButton(
              child: Text("Play Game"),//TODO: set as global const
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(title: globals.titleSettings),
                  )
                );
              },
            ),
            RaisedButton(
              child: Text("LAN Multiplayer"),//TODO: set as global const
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiPlayerPage(title: "Multiplayer"),//TODO: set as global const
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}