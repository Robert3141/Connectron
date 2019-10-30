//import 'dart:html';
import 'package:Connectron/UI/UIgame.dart';
import 'package:Connectron/globals.dart' as globals;
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

  void onLblBoardSizePressed(String boardSizeString) {
    globals.boardSize = int.parse(boardSizeString) ?? globals.boardDefault;
    globals.boardSize = globals.boardSize == 0 ? globals.boardDefault : globals.boardSize;
  }

  void onLblPlayerAmountPressed(String playerAmountString) {
    globals.amountOfPlayers = int.parse(playerAmountString) ?? globals.playerDefault;
    globals.amountOfPlayers = globals.amountOfPlayers == 0 ? globals.playerDefault : globals.amountOfPlayers;
    //enable recursion
    setState(() {
      globals.recursionEnabled = globals.amountOfPlayers < 2;
    });
  }

  void onLblLineLengthPressed(String lineLengthString) {
    globals.lineLength = int.parse(lineLengthString) ?? globals.lineDefault;
    globals.lineLength = globals.lineLength == 0 ? globals.lineDefault : globals.lineLength;
  }

  void onLblRoundAmountPressed(String roundAmountString) {
    globals.amountOfRounds = int.parse(roundAmountString) ?? globals.roundDefault;
    globals.amountOfRounds = globals.amountOfRounds == 0 ? globals.roundDefault : globals.amountOfRounds;
  }

  void onLblRecursionPressed(String recursionString) {
    globals.recursionLimit = int.parse(recursionString) ?? globals.recursionDefault;
    globals.recursionLimit = globals.recursionLimit == 0 ? globals.recursionDefault : globals.recursionLimit;
  }

  void onBtnRunGamePressed(){
    //local vars
    bool issue = checkProblems();

    //no issues
    if (!issue) {
      //reset variables
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
                      globals.lblBoardSize,
                      textAlign: TextAlign.center
                    ),
                  ),
                  Expanded(
                    child: TextField(
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