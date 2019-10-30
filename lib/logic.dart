library connectron.logic;
import 'package:Connectron/globals.dart' as globals;
import 'dart:math';

int randomNumber(int min, int max) {
  final random = new Random();
  return min + random.nextInt(max-min);
}

int checkHor(List<List<int>> board, int boardSize) {
  int winningPlayer = 0;
  int amountFound = 0;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = 0; y < boardSize; y++) {
      //check for every x
      for (int x = 0; x <= boardSize - globals.lineLength; x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x+n][y] == i) {
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

int checkVer(List<List<int>> board, int boardSize) {
  int winningPlayer = 0;
  int amountFound = 0;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every x
    for (int x = 0; x < boardSize; x++) {
      //check for every y
      for (int y = 0; y <= boardSize - globals.lineLength; y++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x][y+n] == i) {
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

int checkDiRight(List<List<int>> board, int boardSize) {
  int winningPlayer = 0;
  int amountFound = 0;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = 0; y <= boardSize - globals.lineLength; y++) {
      //check for every x
      for (int x = 0; x <= boardSize - globals.lineLength; x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x+n][y+n] == i) {
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

int checkDiLeft(List<List<int>> board, int boardSize) {
  int winningPlayer = 0;
  int amountFound = 0;
  //loop for every player
  for (int i = 1; i <= globals.amountOfPlayers; i++) {
    //check every y
    for (int y = globals.lineLength; y < boardSize; y++) {
      //check for every x
      for (int x = 0; x <= boardSize - globals.lineLength; x++) {
        //check for in line
        amountFound = 0;
        for (int n = 0; n < globals.lineLength; n++) {
          if (board[x+n][y-n] == i) {
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

int checkWinner(List<List<int>> board, int boardSize) {
  int winnerFound = 0;
  int horizontal = checkHor(board, boardSize);
  int vertical = checkVer(board, boardSize);
  int diagonalRight = checkDiRight(board, boardSize);
  int diagonalLeft = checkDiLeft(board, boardSize);
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

List<List<int>> applyGravity(List<List<int>> board, int boardSize) {
  //loop through entire array except bottom line
  for (int x = 0; x < boardSize; x++) {
    for (int y = 0; y < boardSize - 1; y++) {
      //if below is empty then drop down and replace
      if (board[x][y+1] == 0) {
        board[x][y+1] = board[x][y];
        board[x][y] = 0;
      }
    }
  }
  return board;
}

List<List<int>> playMove(List<List<int>> board, int boardSize, int player, int columnNumber) {
  //add counter to array if not full
  bool counterAdded = board[columnNumber][0] == 0;

  board[columnNumber][0] = counterAdded ? player : board[columnNumber][0];
  //msgBox(counterAdded.toString(), board[columnNumber][0].toString(), false);
  board = applyGravity(board, boardSize);
  return board;
}

Future<int> minMax(int n, List<List<int>> board, int boardSize, bool first) async {
  //local vars
  List<int> columnScores = new List<int>.generate(boardSize, (i) => 0);
  List<List<int>> newBoard = new List.generate(boardSize, (j) => List.generate(boardSize, (i) => 0));
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
      winner = checkWinner(board, boardSize);
      switch (winner) {
        case 0:
        //still no winner yet
          if (board != newBoard) {
            //move playable
            columnScores[y] = await minMax(n - 1, newBoard, boardSize, false);
          } else {
            //not playable. Give penalty
            columnScores[y] = -2 * (n) * boardSize;
          }
          break;
        case 1:
        //loss
          score = -2 * (n) * boardSize;
          break;
        case 2:
        //win
          score = 2 * (n) * boardSize;
          break;
      }
    }

    //return column rather then score for first value
    if (first) {
      //first value so find optimum column
      winner = 0;
      //find lowest value of score
      for (int i = 0; i < boardSize; i++) {
        winner = i;
        score = columnScores[i];
      }
      //select winner for highest value
      winner = randomNumber(0, boardSize-1);
      for (int i = 0; i < boardSize; i++) {
        if (columnScores[i] > score) {
          //check not going off board
          if (columnScores[i] != -1) {
            score = columnScores[i];
            winner = i;
          }
        }
      }
      return winner;
    } else {
      //not the first value
      //sum up scores
      for (int i = 0; i < boardSize; i++) {
        score+=columnScores[i];
      }
      return score;
    }
  } else {
    //deepest bit of recursion
    winner = checkWinner(board, boardSize);
    switch (winner) {
      case 0:
        score = 0;
        break;
      case 1:
        score = -1;
        break;
      case 2:
        score = 1;
        break;
    }
    return score;
  }
}