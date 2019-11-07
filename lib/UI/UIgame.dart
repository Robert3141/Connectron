import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Connectron/globals.dart' as globals;
import 'package:Connectron/logic.dart' as logic;
import 'package:flutter/rendering.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super (key : key);

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
    globals.mainBoard[columnNumber][0] = counterAdded ? globals.playerNumber : globals.mainBoard[columnNumber][0];
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

  void msgBox(String messageTitle, String message, bool pop) {
    setState(() {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(messageTitle),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(globals.errorActionAccept), onPressed: (){
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

  //code stolen from https://flutter.dev/docs/get-started/flutter-for/android-devs#how-do-you-move-work-to-a-background-thread
  //create isolate and return value when done
  Future isolateMinMax() async {
    //create new receive port
    ReceivePort receivePort = ReceivePort();
    //spawn in isolate with this receive port
    await Isolate.spawn(dataLoader, receivePort.sendPort);
    //get send port from receive port
    SendPort sendPort = await receivePort.first;
    //return the value from the isolate
    return await sendReceive(sendPort, globals.recursionLimit, globals.mainBoard, globals.boardSize);
  }
  Future sendReceive(SendPort port, recursion, board, boardSize) {
    ReceivePort receivePort = ReceivePort();
    //send data in port into isolate
    port.send([receivePort.sendPort,recursion,board,boardSize]);
    return receivePort.first;
  }
  //the actual isolate routine
  static dataLoader(SendPort sendPort) async {
    //get the port of the isolate
    ReceivePort port = ReceivePort();
    //tell other isolates this is listening on this send port
    sendPort.send(port.sendPort);
    //get data from port
    await for (var msg in port) {
      //get send port for return of data
      SendPort sendPort = msg[0];
      //get result from minMax fun and give it data from receive port message
      int result = await logic.minMax(msg[1], msg[2], msg[3], true);
      //return the result from the isolate
      sendPort.send(result);
    }
  }

  Future runAI() async {
    //local vars
    int players = globals.amountOfPlayers;
    globals.amountOfPlayers = 2;
    int winner = 0;
    int columnChosen = 0;

    //choose column
    //Web doesn't support isolates
    //run in isolate to stop main thread being cluttered so UI can still update
    if (!kIsWeb)  {
      columnChosen = await isolateMinMax();
    } else {
      columnChosen = await logic.minMax(globals.recursionLimit, globals.mainBoard, globals.boardSize, true);
    }


    //run procedures
    if (addCounter(columnChosen)) {
      setState(() {
        globals.mainBoard = logic.applyGravity(globals.mainBoard, globals.boardSize);
      });
      //temp increase amount of players
      winner = logic.checkWinner(globals.mainBoard,globals.boardSize);
      if (winner == 0 && spaceOnBoard()) {
        //next player already gonna occur
      } else {
        nextRound(winner);
      }
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
      globals.playerScores[winnerNumber-1]+=globals.amountOfPlayers;
    }

    //increment round
    globals.roundNumber++;
    if (globals.roundNumber > globals.amountOfRounds) {
      //find overall winner
      overallWinner = 0;
      for (int i = 1; i <= globals.amountOfPlayers; i++) {
        if (globals.playerScores[i-1] > (overallWinner == 0 ? 0 : globals.playerScores[overallWinner-1])) {
          overallWinner = i;
        }
      }
      //output winner
      msgBox(globals.errorTitleWin, globals.errorMsgWinner + globals.playerNames[winnerNumber] + globals.errorMsgOverall + globals.playerNames[overallWinner], true);
    } else {
      //output winner
      msgBox(globals.errorTitleWin, globals.errorMsgWinner + globals.playerNames[winnerNumber], false);
      //reset variables
      globals.mainBoard = new List<List<int>>.generate(globals.boardSize, (i) => List<int>.generate(globals.boardSize, (j) => 0));
      globals.playerNumber = 1;
    }
    //end running
    globals.running = false;
  }

  void onColumnPressed(int columnNumber) async {
    try {
      //prevents additional input (usually whilst computer playing)
      if (!globals.running) {
        globals.running = true;
        //local vars
        int winner = 0;

        //run procedures
        if (addCounter(columnNumber)) {
          setState(() {
            globals.mainBoard = logic.applyGravity(globals.mainBoard, globals.boardSize);
          });
          winner = logic.checkWinner(globals.mainBoard, globals.boardSize);
          if (winner == 0 && spaceOnBoard()){
            await nextPlayer();
          } else {
            nextRound(winner);
          }
        } else {
          msgBox(globals.errorTitleInput, globals.errorMsgBoardNoSpace, false);
          globals.running = false;
        }
      }
    } catch(e) {
      msgBox("Error", e.toString(), false);
    }
  }

  ///
  /// INTERFACE
  ///

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: globals.playerColors[globals.playerNumber].withAlpha(globals.backgroundAlpha),
      appBar: AppBar(
        title: Text(globals.titleGame),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.help),onPressed: (){msgBox(globals.errorTitleHelp,globals.errorMsgHelpGame, false);},)
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(globals.defaultPadding),
          itemCount: globals.boardSize,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int boardY){
            //Horizontal Board
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: globals.defaultPadding/globals.boardSize,bottom: globals.defaultPadding/globals.boardSize),
              height: (MediaQuery.of(context).size.width - globals.defaultPadding) / (globals.boardSize + 1),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: globals.boardSize,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int boardX) {
                  return Padding(
                    padding: EdgeInsets.only(left: globals.defaultPadding/globals.boardSize,right: globals.defaultPadding/globals.boardSize),
                    child: CircleAvatar(
                      backgroundColor: globals.playerColors[globals.mainBoard[boardX][boardY]],
                      radius: (MediaQuery.of(context).size.width / 2 - globals.defaultPadding) / (globals.boardSize + 1),
                      child: InkWell(
                        onTap: () {
                          onColumnPressed(boardX);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}