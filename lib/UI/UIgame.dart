import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Connectron/globals.dart' as globals;
import 'package:Connectron/logic.dart' as logic;
import 'package:flutter/rendering.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  ///
  /// FUCNTIONS
  ///

  bool addCounter(int columnNumber) {
    //add counter to array if not full
    bool counterAdded = globals.mainBoard[columnNumber][0] == 0;
    globals.mainBoard[columnNumber][0] = counterAdded
        ? globals.playerNumber
        : globals.mainBoard[columnNumber][0];
    return counterAdded;
  }

  bool spaceOnBoard() {
    bool spaceOnBoard = false;

    //loop through board
    for (int y = 0; y < globals.boardSize; y++) {
      for (int x = 0; x < globals.boardSize; x++) {
        if (globals.mainBoard[x][y] == 0) {
          spaceOnBoard = true;
        }
      }
    }

    return spaceOnBoard;
  }

  ///
  /// PROCEDURES
  ///

  void msgBox(String messageTitle, String message, bool pop, bool dismiss) {
    setState(() {
      showDialog<String>(
        context: context,
        barrierDismissible: dismiss,
        builder: (BuildContext context) => AlertDialog(
          title: Text(messageTitle),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(globals.errorActionAccept),
              onPressed: () {
                Navigator.of(context).pop();
                if (pop) {
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      );
    });
  }

  Future runAI() async {
    //local vars
    int players = globals.amountOfPlayers;
    globals.amountOfPlayers = 2;
    int winner = 0;
    int columnChosen = logic.randomNumber(0, globals.boardSize - 1);

    //choose column
    //Web doesn't support isolates
    //run in isolate to stop main thread being cluttered so UI can still update
    if (globals.recursionLimit != 0) {
      if (!kIsWeb) {
        columnChosen = await logic.isolateMinMax(2 * globals.recursionLimit,
            globals.mainBoard, globals.boardSize, true);
      } else {
        columnChosen = await logic.minMax(2 * globals.recursionLimit,
            globals.mainBoard, globals.boardSize, true);
      }
    }

    //add column to one that is not full
    while (!addCounter(columnChosen)) {
      columnChosen = logic.randomNumber(0, globals.boardSize - 1);
    }
    //apply gravity and update UI
    setState(() {
      globals.mainBoard = logic.applyGravity(
          globals.mainBoard, globals.boardSize, columnChosen);
    });
    //temp increase amount of players
    winner =
        logic.checkWinner(globals.mainBoard, globals.boardSize, columnChosen);
    if (winner == 0 && spaceOnBoard()) {
      //next player already gonna occur
    } else {
      nextRound(winner);
    }

    globals.amountOfPlayers = players;
  }

  nextPlayer() async {
    //increment player
    globals.playerNumber++;
    if (globals.playerNumber > globals.amountOfPlayers) {
      //check only one player
      if (globals.amountOfPlayers == 1) {
        await runAI();
      }

      //all players played
      globals.playerNumber = 1;
    }
    //end running
    globals.running = false;
  }

  void nextRound(int winnerNumber) async {
    //local vars
    int overallWinner = 1;

    //Add scores
    if (winnerNumber != 0) {
      globals.playerScores[winnerNumber - 1] += globals.amountOfPlayers;
    }

    //increment round
    globals.roundNumber++;
    if (globals.roundNumber > globals.amountOfRounds) {
      //find overall winner
      overallWinner = 0;
      for (int i = 1; i <= globals.amountOfPlayers; i++) {
        if (globals.playerScores[i - 1] >
            (overallWinner == 0
                ? 0
                : globals.playerScores[overallWinner - 1])) {
          overallWinner = i;
        }
      }
      //output winner
      msgBox(
          globals.outputTitleWin,
          globals.outputMsgWinner +
              globals.playerNames[winnerNumber] +
              globals.outputMsgOverall +
              globals.playerNames[overallWinner],
          true,
          true);
      globals.running = true;
    } else {
      //output winner
      msgBox(
          globals.outputTitleWin,
          globals.outputMsgWinner + globals.playerNames[winnerNumber],
          false,
          true);
      //reset variables
      globals.playerBombs =
          new List<bool>.generate(globals.amountOfPlayers, (i) => false);
      globals.mainBoard = new List<List<int>>.generate(globals.boardSize,
          (i) => List<int>.generate(globals.boardSize, (j) => 0));
      globals.playerNumber = 1;
      //end running
      globals.running = false;
    }
  }

  void onColumnPressed(int columnNumber, bool bombPlayed) async {
    try {
      //prevents additional input (usually whilst computer playing)
      if (!globals.running) {
        globals.running = true;
        //local vars
        int winner = 0;

        //run procedures
        if (addCounter(columnNumber)) {
          setState(() {
            if (bombPlayed) {
              globals.playerBombs[globals.playerNumber - 1] = false;
              globals.mainBoard =
                  logic.playBomb(columnNumber, globals.mainBoard);
            } else {
              globals.mainBoard = logic.applyGravity(
                  globals.mainBoard, globals.boardSize, columnNumber);
            }
          });
          winner = logic.checkWinner(
              globals.mainBoard, globals.boardSize, columnNumber);
          if (winner == 0 && spaceOnBoard()) {
            await nextPlayer();
          } else {
            nextRound(winner);
          }
        } else {
          msgBox(globals.errorTitleInput, globals.outputMsgBoardNoSpace, false,
              true);
          globals.running = false;
        }
      }
    } catch (e) {
      msgBox(globals.errorTitleError, e.toString(), false, true);
    }
  }

  ///
  /// INTERFACE
  ///

  Color chooseBackgroundColor() {
    //darken or brighten colour appropriately
    Color chosenColor = globals.playerColors[globals.playerNumber];
    if (Theme.of(context).brightness == Brightness.light) {
      chosenColor = TinyColor(chosenColor).brighten(10).color;
    } else {
      do {
        chosenColor = TinyColor(chosenColor).darken(10).color;
      } while (!TinyColor(chosenColor).isDark());
    }
    return chosenColor;
  }

  @override
  Widget build(BuildContext context) {
    //local variables of size
    double _paddingInsets = globals.defaultPadding / globals.boardSize;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double smallestLength = width > height ? height : width;
    double _counterSize =
        (smallestLength - globals.defaultPadding) / (globals.boardSize + 2);
    double _counterRadius =
        (smallestLength / 2 - globals.defaultPadding) / (globals.boardSize + 2);

    return Scaffold(
      backgroundColor: chooseBackgroundColor(),
      appBar: AppBar(
        title: Text(globals.titleGame),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              msgBox(
                  globals.helpTitleHelp, globals.helpMsgHelpGame, false, true);
            },
          )
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(globals.defaultPadding),
        itemCount: globals.bombCounter
            ? globals.boardSize + 2
            : globals.boardSize + 1, //For extra counters
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int boardY) {
          //Horizontal Board
          return Container(
            alignment: Alignment.center,
            padding:
                EdgeInsets.only(top: _paddingInsets, bottom: _paddingInsets),
            height: _counterSize,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: globals.boardSize,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int boardX) {
                if (boardY == 0) {
                  //Downward arrow
                  return Padding(
                    padding: EdgeInsets.only(
                        left: _paddingInsets, right: _paddingInsets),
                    child: CircleAvatar(
                      backgroundColor: globals
                          .playerColors[globals.playerNumber]
                          .withAlpha(0),
                      radius: _counterRadius,
                      child: InkWell(
                        splashColor: globals.playerColors[globals.playerNumber],
                        child: Container(
                          child: Icon(
                            Icons.arrow_downward,
                            size: _counterRadius,
                          ),
                        ),
                        onTap: () {
                          onColumnPressed(boardX, false);
                        },
                      ),
                    ),
                  );
                } else if (boardY == globals.boardSize + 1) {
                  //Bomb counter
                  return Padding(
                    padding: EdgeInsets.only(
                        left: _paddingInsets, right: _paddingInsets),
                    child: CircleAvatar(
                      backgroundColor: globals
                          .playerColors[globals.playerNumber]
                          .withAlpha(0),
                      radius: _counterRadius,
                      child: InkWell(
                        enableFeedback:
                            globals.playerBombs[globals.playerNumber - 1],
                        splashColor: globals.playerColors[globals.playerNumber],
                        child: globals.playerBombs[globals.playerNumber - 1]
                            ? Container(
                                child: Icon(
                                  Icons.flare,
                                  size: _counterRadius,
                                ),
                              )
                            : Container(),
                        onTap: () {
                          if (globals.playerBombs[globals.playerNumber - 1]) {
                            onColumnPressed(boardX, true);
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  //board
                  return Padding(
                    padding: EdgeInsets.only(
                        left: _paddingInsets, right: _paddingInsets),
                    child: CircleAvatar(
                      backgroundColor: globals.mainBoard[boardX][boardY - 1] ==
                                  0 &&
                              Theme.of(context).brightness == Brightness.dark
                          ? Color.fromRGBO(18, 18, 18, 1.0)
                          : globals.playerColors[globals.mainBoard[boardX]
                              [boardY - 1]],
                      radius: _counterRadius,
                      child: InkWell(
                        onTap: () {
                          onColumnPressed(boardX, false);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
