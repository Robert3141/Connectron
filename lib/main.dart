import 'package:Connectron/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:Connectron/UI/UIsettings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //await DesktopWindow.setMaxWindowSize(Size.infinite);
    await DesktopWindow.setMinWindowSize(Size(400, 500));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.red,
        primaryColor: globals.playerColors[1],
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: globals.titleGame,
          theme: theme,
          darkTheme: new ThemeData(
            primarySwatch: Colors.red,
            primaryColor: globals.playerColors[1],
            brightness: Brightness.dark,
          ),
          home: SettingsPage(title: globals.titleSettings),
        );
      },
    );
    /*
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //primarySwatch: Colors.red,
        primaryColor: globals.playerColors[1],
      ),
      home: SettingsPage(title: globals.titleSettings),
    );*/
  }
}
