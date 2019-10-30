library connectron.globals;

import 'package:flutter/cupertino.dart';


///
/// STRINGS
///

//Page titles
const String titleSettings = "Set up";
const String titleGame = "Connectron";

//Settings Page
const int boardMin = 3;
const int boardDefault = 7;
const int boardMax = 100;
const int playerMin = 1;
const int playerDefault = 1;
const int playerMax = 10;
const int lineMin = 3;
const int lineDefault = 4;
const int lineMax = 10;
const int roundMin = 1;
const int roundDefault = 1;
const int roundMax = 5;
const int recursionMin = 1;
const int recursionDefault = 3;
const int recursionMax = 10;
const String lblBoardSize = "Board Size ($boardMin-$boardMax)";
const String lblAmountOfPlayers = "Amount of players ($playerMin-$playerMax)";
const String lblLineLength = "Line Length ($lineMin-$lineMax)";
const String lblRoundNum = "Number of rounds ($roundMin-$roundMax)";
const String lblRecursion = "CPU Level ($recursionMin-$recursionMax)";
const String lblRunGame = "Run Game";
const String errorActionAccept = "OK";
const String errorTitleInput = "Invalid Input";
const String errorMsgInputBoardSizeSmall = "The board size is too small. It should be $boardMin-$boardMax";
const String errorMsgInputBoardSizeLarge = "The board size is too large. It should be $boardMin-$boardMax";
const String errorMsgInputPlayerAmountSmall = "The player amount is too small. It should be $playerMin-$playerMax";
const String errorMsgInputPlayerAmountLarge = "The player amount is too large. It should be $playerMin-$playerMax";
const String errorMsgInputLineLengthSmall = "The line length is too small. It should be $lineMin-$lineMax";
const String errorMsgInputLineLengthLarge = "The line length is too large. It should be $lineMin-$lineMax";
const String errorMsgInputLineLengthProblem = "The line length is larger than the board!";
const String errorMsgInputRoundSmall = "The round number is too small. It should be $roundMin-$roundMax";
const String errorMsgInputRoundLarge = "The round number is too large. It should be $roundMin-$roundMax";
const String errorMsgInputRecursionSmall = "The CPU level is too small. It should be $recursionMin-$recursionMax";
const String errorMsgInputRecursionLarge = "The CPU level is too large. It should be $recursionMin-$recursionMax";
const String errorTitleHelp = "Help";
const String errorMsgHelpMain = "Connectron is a Connect 4 style game played by $playerMin-$playerMax.";
const String errorMsgHelpGame = "To play press a spot on the chosen column. The background colour represents the player playing. A win for white represents a draw";
const double defaultPadding = 12.0;


//Games Page
const double btnSize = 1.0;
const int backgroundAlpha = 200;
const errorTitleWin = "Winner!";
const errorMsgWinner = "The winner is player ";
const errorMsgOverall = " and the overall winner is player ";
const errorMsgBoardNoSpace = "The column you selected is full!";
const List<Color> playerColors = [
  Color.fromRGBO(255,255,255,1.0),  //00 WHITE
  Color.fromRGBO(198, 40, 40,1.0),  //01 RED
  Color.fromRGBO(249, 168, 37,1.0), //02 YELLOW
  Color.fromRGBO(46, 125, 50,1.0),  //03 GREEN
  Color.fromRGBO(106, 27, 154,1.0), //04 PURPLE
  Color.fromRGBO(173, 20, 87,1.0),  //05 PINK
  Color.fromRGBO(216, 67, 21,1.0),  //06 ORANGE
  Color.fromRGBO(55, 71, 79,1.0),   //07 BLUE-GREY
  Color.fromRGBO(21, 101, 192,1.0), //08 BLUE
  Color.fromRGBO(158, 157, 36,1.0), //09 LIME
  Color.fromRGBO(0, 131, 143,1.0)   //10 CYAN
];
const List<String> playerNames = [
  "nobody",
  "red",
  "yellow",
  "green",
  "purple",
  "pink",
  "orange",
  "blue-grey",
  "blue",
  "lime",
  "cyan",
];
bool running = false;
int boardSize = boardDefault;
int amountOfPlayers = playerDefault;
int amountOfRounds = roundDefault;
int lineLength = lineDefault;
int recursionLimit = recursionDefault;
bool recursionEnabled = true;
int roundNumber = roundDefault;
int playerNumber = playerDefault;
List<List<int>> mainBoard = new List<List<int>>.generate(boardDefault, (i) => List<int>.generate(boardDefault, (j) => 0));
List<int> playerScores = new List<int>.generate(playerDefault, (i) => 0);