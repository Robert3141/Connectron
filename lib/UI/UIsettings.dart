//import 'dart:html';
import 'package:Connectron/UI/UIgame.dart';
import 'package:Connectron/globals.dart' as globals;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super (key: key);

  final String title;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  ///
  /// FUNCTIONS
  ///

  bool checkProblems() {
    bool issue = false;
    //check board size
    if (globals.boardSize > globals.boardMax) {
      //TOO LARGE
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputBoardSizeLarge);
    }
    if (globals.boardSize < globals.boardMin) {
      //TOO SMALL
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputBoardSizeSmall);
    }
    //check player amount
    if (globals.amountOfPlayers > globals.playerMax){
      //TOO LARGE
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputPlayerAmountLarge);
    }
    if (globals.amountOfPlayers < globals.playerMin) {
      //TOO SMALL
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputPlayerAmountSmall);
    }
    //check line length
    if (globals.lineLength > globals.lineMax) {
      //TOO LARGE
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputLineLengthLarge);
    }
    if (globals.lineLength < globals.lineMin) {
      //TOO SMALL
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputLineLengthSmall);
    }
    if (globals.lineLength > globals.boardSize) {
      //LARGER THAN BOARD
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputLineLengthProblem);
    }
    //check round number
    if (globals.amountOfRounds > globals.roundMax) {
      //TOO LARGE
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputRoundLarge);
    }
    if (globals.amountOfRounds < globals.roundMin) {
      //TOO SMALL
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputRoundSmall);
    }
    //check recursion
    if (globals.recursionLimit > globals.recursionMax) {
      //TOO LARGE
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputRecursionLarge);
    }
    if (globals.recursionLimit < globals.recursionMin) {
      //TOO SMALL
      issue = true;
      msgBox(globals.errorTitleInput, globals.errorMsgInputRecursionSmall);
    }

    return issue;
  }

  ///
  /// PROCEDURES
  ///

  void msgBox(String messageTitle, String message) {
    setState(() {
      showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          title: Text(messageTitle),
          content: Text(message),
          actions: <Widget>[
            FlatButton(child: Text(globals.errorActionAccept), onPressed: (){Navigator.of(context).pop();},)
          ],
        ),
      );
    });
  }

  void onLblPresetsPressed(String selectedString) {
    setState(() {
      //set preset selected
      for (int i = 0; i < globals.optionalPresetsTitles.length; i++) {
        if (selectedString == globals.optionalPresetsTitles[i]) {
          globals.selectedPreset = i;
          break;
        }
      }
      //set new values
      if (globals.selectedPreset != globals.optionalPresetsTitles.length-1){
        globals.boardSize = globals.optionalPresetsValues[globals.selectedPreset][0];
        globals.amountOfPlayers = globals.optionalPresetsValues[globals.selectedPreset][1];
        setState(() {
          globals.conBoardSize.text = globals.boardSize.toString();
          globals.conAmountOfPlayers.text = globals.amountOfPlayers.toString();
          globals.recursionEnabled = globals.amountOfPlayers <= 1;
          globals.bombCounter = globals.recursionEnabled ? false : globals.bombCounter;
        });
      }
    });
  }

  void onLblBombPressed(bool newBomb) {
    msgBox(newBomb.toString(), globals.recursionEnabled.toString() + "|" + globals.bombCounter.toString());
    if (!globals.recursionEnabled) {
      setState(() {
        globals.bombCounter = newBomb;
      });
    } else {
      setState(() {
        globals.bombCounter = false;
      });
    }
  }

  void onLblBoardSizePressed(String boardSizeString) {
    globals.boardSize = int.parse(boardSizeString) ?? globals.boardDefault;
    globals.boardSize = globals.boardSize == 0 ? globals.boardDefault : globals.boardSize;
    setState(() {
      globals.selectedPreset = globals.optionalPresetsTitles.length-1;
    });
  }

  void onLblPlayerAmountPressed(String playerAmountString) {
    globals.amountOfPlayers = int.parse(playerAmountString) ?? globals.playerDefault;
    globals.amountOfPlayers = globals.amountOfPlayers == 0 ? globals.playerDefault : globals.amountOfPlayers;
    //enable recursion
    setState(() {
      globals.selectedPreset = globals.optionalPresetsTitles.length-1;
      globals.recursionEnabled = globals.amountOfPlayers < 2;
      globals.bombCounter = globals.recursionEnabled ? false : globals.bombCounter;
    });
  }

  void onLblLineLengthPressed(String lineLengthString) {
    globals.lineLength = int.parse(lineLengthString) ?? globals.lineDefault;
    globals.lineLength = globals.lineLength == 0 ? globals.lineDefault : globals.lineLength;
    setState(() {
      globals.selectedPreset = globals.optionalPresetsTitles.length-1;
    });
  }

  void onLblRoundAmountPressed(String roundAmountString) {
    globals.amountOfRounds = int.parse(roundAmountString) ?? globals.roundDefault;
    globals.amountOfRounds = globals.amountOfRounds == 0 ? globals.roundDefault : globals.amountOfRounds;
    setState(() {
      globals.selectedPreset = globals.optionalPresetsTitles.length-1;
    });
  }

  void onLblRecursionPressed(String recursionString) {
    globals.recursionLimit = int.parse(recursionString) ?? globals.recursionDefault;
    globals.recursionLimit = globals.recursionLimit == 0 ? globals.recursionDefault : globals.recursionLimit;
    setState(() {
      globals.selectedPreset = globals.optionalPresetsTitles.length-1;
    });
  }

  void onBtnRunGamePressed(){
    //local vars
    bool issue = checkProblems();

    //no issues
    if (!issue) {
      //reset variables
      if (globals.amountOfPlayers > 1) {
        globals.playerBombs = new List<bool>.generate(globals.amountOfPlayers, (i) => true);
      } else {
        globals.bombCounter = false;
      }
      globals.mainBoard = new List<List<int>>.generate(globals.boardSize, (i) => List<int>.generate(globals.boardSize, (j) => 0));
      globals.playerScores = globals.amountOfPlayers <= 1 ? new List<int>.generate(2, (i) => 0) : new List<int>.generate(globals.amountOfPlayers, (i) => 0);
      globals.playerNumber = 1;
      globals.roundNumber = 1;
      globals.running = false;

      //Push interface
      Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(title: globals.titleGame)));
    }
  }

  ///
  /// INTERFACE
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.brightness_3),onPressed: (){DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);},),
          IconButton(icon: Icon(Icons.help),onPressed: (){msgBox(globals.errorTitleHelp,globals.errorMsgHelpMain);},)
        ],
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(globals.defaultPadding),
          children: <Widget>[
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      globals.lblOptionalPrests,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: DropdownButton<String>(
                        value:globals.optionalPresetsTitles[globals.selectedPreset],
                        items:globals.optionalPresetsTitles.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, textAlign: TextAlign.center,),
                          );
                        }).toList(),
                        icon: Icon(Icons.arrow_downward),
                        onChanged: onLblPresetsPressed,
                        underline: Container(height: 2,color:Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            InkWell(
              enableFeedback: globals.recursionEnabled,
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      globals.lblBombCounter,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: InkWell(
                        onTap: (){
                          onLblBombPressed(!globals.bombCounter);
                        },
                        child: Switch(
                          value: globals.bombCounter,
                          onChanged: onLblBombPressed,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      globals.lblBoardSize,
                      textAlign: TextAlign.center
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: globals.conBoardSize,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: onLblBoardSizePressed,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: globals.boardDefault.toString(),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                        globals.lblAmountOfPlayers,
                        textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: globals.conAmountOfPlayers,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: onLblPlayerAmountPressed,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: globals.playerDefault.toString(),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                        globals.lblLineLength,
                        textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: globals.conLineLength,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: onLblLineLengthPressed,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: globals.lineDefault.toString(),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      globals.lblRoundNum,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: globals.conNumberOfRounds,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: onLblRoundAmountPressed,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: globals.roundDefault.toString(),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            InkWell(
              enableFeedback: globals.recursionEnabled,
              splashColor: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      globals.lblRecursion,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: globals.conRecursion,
                      enabled: globals.recursionEnabled,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                      onChanged: onLblRecursionPressed,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: globals.recursionDefault.toString(),
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            RaisedButton(
              child: Text(globals.lblRunGame),
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: onBtnRunGamePressed,
            ),
          ],

        ),
      ),
    );
  }

}