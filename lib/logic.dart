library connectron.logic;

import 'dart:isolate';
import 'package:Connectron/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

int randomNumber(int min, int max) {
  final random = new Random();
  return min + random.nextInt(max - min);
}

int checkHor(List<List<int>> board, int boardSize, int column) {
  int winningPlayer = 0;
  int amountFound = 0;
  int minX = column == null
      ? 0
      : column - globals.lineLength + 1 > 0
          ? column - globals.lineLength + 1
          : 0;
  int maxX = column == null
      ? boardSize - globals.lineLength
      : column + globals.lineLength < boardSize - globals.lineLength
          ? column + globals.lineLength
          : boardSize - globals.lineLength;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = 0; y < boardSize; y++) {
      //check for every x
      for (int x = minX /*0*/;
          x <= maxX /*boardSize - globals.lineLength*/;
          x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x + n][y] == i) {
            amountFound++;
          }
        }
        //amountFound should be line length to have a line
        if (amountFound == globals.lineLength) {
          winningPlayer = i;
        }
      }
    }
  }

  return winningPlayer;
}

int checkVer(List<List<int>> board, int boardSize, int column) {
  int winningPlayer = 0;
  int amountFound = 0;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check only the column
    for (int x = column ?? 0;
        column == null ? column == x : x < boardSize;
        x++) {
      //check for every y
      for (int y = 0; y <= boardSize - globals.lineLength; y++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x][y + n] == i) {
            amountFound++;
          }
        }
        //amountFound should be line length to have a line
        if (amountFound == globals.lineLength) {
          winningPlayer = i;
        }
      }
    }
  }

  return winningPlayer;
}

int checkDiRight(List<List<int>> board, int boardSize, int column) {
  int winningPlayer = 0;
  int amountFound = 0;
  int minX = column == null
      ? 0
      : column - globals.lineLength + 1 > 0
          ? column - globals.lineLength + 1
          : 0;
  int maxX = column == null
      ? boardSize - globals.lineLength
      : column + globals.lineLength < boardSize - globals.lineLength
          ? column + globals.lineLength
          : boardSize - globals.lineLength;

  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = 0; y <= boardSize - globals.lineLength; y++) {
      //check for every x
      for (int x = minX; x <= maxX; x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x + n][y + n] == i) {
            amountFound++;
          }
        }
        //amountFound should be line length to have a line
        if (amountFound == globals.lineLength) {
          winningPlayer = i;
        }
      }
    }
  }

  return winningPlayer;
}

int checkDiLeft(List<List<int>> board, int boardSize, int column) {
  int winningPlayer = 0;
  int amountFound = 0;
  int minX = column == null
      ? 0
      : column - globals.lineLength + 1 > 0
          ? column - globals.lineLength + 1
          : 0;
  int maxX = column == null
      ? boardSize - globals.lineLength
      : column + globals.lineLength < boardSize - globals.lineLength
          ? column + globals.lineLength
          : boardSize - globals.lineLength;

  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = globals.lineLength - 1; y < boardSize; y++) {
      //check for every x
      for (int x = minX; x <= maxX; x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x + n][y - n] == i) {
            amountFound++;
          }
        }
        //amountFound should be line length to have a line
        if (amountFound == globals.lineLength) {
          winningPlayer = i;
        }
      }
    }
  }

  return winningPlayer;
}

int checkWinner(List<List<int>> board, int boardSize, [int placed]) {
  int winnerFound = 0;
  int horizontal = checkHor(board, boardSize, placed);
  int vertical = checkVer(board, boardSize, placed);
  int diagonalRight = checkDiRight(board, boardSize, placed);
  int diagonalLeft = checkDiLeft(board, boardSize, placed);
  if (horizontal != 0) {
    winnerFound = horizontal;
  } else if (vertical != 0) {
    winnerFound = vertical;
  } else if (diagonalRight != 0) {
    winnerFound = diagonalRight;
  } else if (diagonalLeft != 0) {
    winnerFound = diagonalLeft;
  }
  return winnerFound;
}

List<List<int>> applyGravity(List<List<int>> board, int boardSize, int x) {
  //loop through entire array except bottom line
  for (int y = 0; y < boardSize - 1; y++) {
    //if below is empty then drop down and replace
    if (board[x][y + 1] == 0) {
      board[x][y + 1] = board[x][y];
      board[x][y] = 0;
    }
  }
  return board;
}

List<List<int>> boardGravity(List<List<int>> board, int boardSize, int x) {
  //loop through entire array except bottom line
  for (int i = 0; i < 2; i++) {
    for (int y = boardSize - 1; y > 0; y--) {
      //if below is empty then drop down and replace
      if (board[x][y] == 0) {
        board[x][y] = board[x][y - 1];
        board[x][y - 1] = 0;
      }
    }
  }

  return board;
}

List<List<int>> bombRemoval(int x, int y, List<List<int>> movedBoard) {
  if (x > 0) {
    if (y > 0) {
      movedBoard[x - 1][y - 1] = 0;
    }
    if (y < globals.boardSize - 1) {
      movedBoard[x - 1][y + 1] = 0;
    }
    movedBoard[x - 1][y] = 0;
  }
  if (x < globals.boardSize - 1) {
    if (y > 0) {
      movedBoard[x + 1][y - 1] = 0;
    }
    if (y < globals.boardSize - 1) {
      movedBoard[x + 1][y + 1] = 0;
    }
    movedBoard[x + 1][y] = 0;
  }
  if (y < globals.boardSize - 1) {
    movedBoard[x][y + 1] = 0;
  }
  movedBoard[x][y] = 0;

  return movedBoard;
}

List<List<int>> playBomb(int x, List<List<int>> movedBoard,
    {bool debug = false}) {
  //apply gravity for bomb
  for (int y = 0; y < globals.boardSize - 1; y++) {
    //dropdown until
    if (movedBoard[x][y + 1] == 0) {
      //drop down below
      movedBoard[x][y + 1] = movedBoard[x][y];
      movedBoard[x][y] = 0;
    } else {
      //y is bomb counter
      if (debug) debugPrint("x=$x;y=$y");

      //bomb
      movedBoard = bombRemoval(x, y, movedBoard);
      movedBoard = boardGravity(movedBoard, globals.boardSize, x);
      if (x > 0) {
        //apply gravity on all tokens above
        for (int i = 0; i < globals.boardSize - 3; i++) {
          movedBoard = boardGravity(movedBoard, globals.boardSize, x - 1);
        }
      }
      if (x < globals.boardSize - 1) {
        //apply gravity on all tokens above
        for (int i = 0; i < globals.boardSize - 3; i++) {
          movedBoard = boardGravity(movedBoard, globals.boardSize, x + 1);
        }
      }
      return movedBoard;
    }
  }

  movedBoard = bombRemoval(x, globals.boardSize - 1, movedBoard);
  movedBoard = boardGravity(movedBoard, globals.boardSize, x);
  if (x > 0) {
    movedBoard = boardGravity(movedBoard, globals.boardSize, x - 1);
  }
  if (x < globals.boardSize - 1) {
    movedBoard = boardGravity(movedBoard, globals.boardSize, x + 1);
  }
  return movedBoard;
}

List<List<int>> playMove(
    List<List<int>> board, int boardSize, int player, int columnNumber) {
  //add counter to array if not full
  bool counterAdded = board[columnNumber][0] == 0;

  board[columnNumber][0] = counterAdded ? player : board[columnNumber][0];
  //msgBox(counterAdded.toString(), board[columnNumber][0].toString(), false);
  board = applyGravity(board, boardSize, columnNumber);
  return board;
}

Future<int> minMax(int n, List<List<int>> board, int boardSize, bool first,
    {bool debug = kDebugMode}) async {
  //local vars
  List<int> columnScores = new List<int>.generate(boardSize, (i) => 0);
  List<List<int>> newBoard =
      new List.generate(boardSize, (j) => List.generate(boardSize, (i) => 0));
  int score = 0;
  int winner = 0;

  //is n 0
  if (n > 0) {
    //loop through columns
    for (int y = 0; y < boardSize; y++) {
      //make sure not passed as reference
      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          newBoard[i][j] = int.parse((board[i][j] ?? 0).toString() ?? "0") ?? 0;
        }
      }
      if (n % 2 == globals.recursionLimit % 2) {
        //AI's turn
        newBoard = playMove(newBoard, boardSize, 2, y);
      } else {
        //player's turn
        newBoard = playMove(newBoard, boardSize, 1, y);
      }
      //check for winner
      winner = checkWinner(board, boardSize, y);
      switch (winner) {
        case 0:
          //still no winner yet
          if (board != newBoard) {
            //move playable
            columnScores[y] = await minMax(n - 1, newBoard, boardSize, false);
          } else {
            //not playable. Give penalty
            columnScores[y] = -1 * (n) * boardSize - 1;
          }
          break;
        case 1:
          //loss
          columnScores[y] = n - 1 == globals.recursionLimit
              ? -1 * (n) * boardSize
              : -1 * (n ~/ 2) * boardSize;
          break;
        case 2:
          //win
          columnScores[y] = n == globals.recursionLimit
              ? 1 * (n) * boardSize
              : 1 * (n ~/ 2) * boardSize;
          break;
      }
    }

    //return column rather then score for first value
    if (first) {
      //first value so find optimum column
      score = 0;
      winner = 0;
      //find smallest value of score
      for (int i = 0; i < boardSize; i++) {
        if (columnScores[i] < score) {
          winner = i;
          score = columnScores[i];
        }
      }
      //if all the same choose random
      if ((columnScores[winner] == columnScores[0] && winner != 0) ||
          (columnScores[winner] == columnScores[1] && winner != 1)) {
        winner = randomNumber(0, boardSize - 1);
      }
      //select winner for highest value
      for (int i = 0; i < boardSize; i++) {
        //find largest value
        if (columnScores[i] > score) {
          //check not going off board
          if (columnScores[i] != -1) {
            score = columnScores[i];
            winner = i;
          }
        }
      }
      //output to debugPrint the data from
      if (debug) debugPrint("Largest Score=$score | minMax() Column=$winner");
      String stringOfScores = "Scores=|";
      for (int i = 0; i < boardSize; i++) {
        stringOfScores += "${columnScores[i]}|";
      }
      if (debug) debugPrint(stringOfScores);
      //return chosen result
      return winner;
    } else {
      //not the first value
      //sum up scores
      for (int i = 0; i < boardSize; i++) {
        score += columnScores[i];
      }
      return score;
    }
  } else {
    //deepest bit of recursion
    winner = checkWinner(board, boardSize);
    switch (winner) {
      case 0:
        //draw
        score = 0;
        break;
      case 1:
        //loss
        score = -1;
        break;
      case 2:
        //win
        score = 1;
        break;
    }

    return score;
  }
}

//code stolen from https://flutter.dev/docs/get-started/flutter-for/android-devs#how-do-you-move-work-to-a-background-thread
//create isolate and return value when done
Future<int> isolateMinMax(int n, List<List<int>> board, int boardSize,
    [bool first = false]) async {
  //create new receive port
  ReceivePort receivePort = ReceivePort();
  //spawn in isolate with this receive port
  await Isolate.spawn(dataLoader, receivePort.sendPort);
  //get send port from receive port
  SendPort sendPort = await receivePort.first;
  //return the value from the isolate
  return await sendReceive(sendPort, n, board, boardSize, first);
}

Future sendReceive(SendPort port, int recursion, List<List<int>> board,
    int boardSize, bool first) {
  ReceivePort receivePort = ReceivePort();
  //send data in port into isolate
  port.send([receivePort.sendPort, recursion, board, boardSize, first]);
  return receivePort.first;
}

//the actual isolate routine
Future dataLoader(SendPort sendPort) async {
  //get the port of the isolate
  ReceivePort port = ReceivePort();
  //tell other isolates this is listening on this send port
  sendPort.send(port.sendPort);
  //get data from port
  await for (var msg in port) {
    //get send port for return of data
    SendPort sendPort = msg[0];
    //get result from minMax fun and give it data from receive port message
    int result = await minMax(msg[1], msg[2], msg[3], msg[4]);
    //return the result from the isolate
    sendPort.send(result);
  }
}
