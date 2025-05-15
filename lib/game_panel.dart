import 'package:flutter/material.dart';

class GamePanel extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  const GamePanel({
    Key? key,
    required this.player1Name,
    required this.player2Name,
  }) : super(key: key);

  @override
  State<GamePanel> createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  late List<List<String>> _board;
  late String _currentPlayer;
  int _player1Score = 0;
  int _player2Score = 0;
  int _round = 1;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _currentPlayer = widget.player1Name; // Player 1 starts
  }

  void _initializeBoard() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _gameOver = false;
  }

  void _resetGame() {
    setState(() {
      _initializeBoard();
      _player1Score = 0;
      _player2Score = 0;
      _round = 1;
      _currentPlayer = widget.player1Name; // Player 1 starts
    });
  }

  void _newRound(String startingPlayer) {
    setState(() {
      _initializeBoard();
      _round++;
      _currentPlayer = startingPlayer;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col].isEmpty && !_gameOver) {
      setState(() {
        _board[row][col] = _currentPlayer == widget.player1Name ? 'X' : 'O';

        // Check for win
        if (_checkWin(row, col)) {
          _gameOver = true;
          _showWinDialog();
          return;
        }

        // Check for draw
        if (_checkDraw()) {
          _gameOver = true;
          _showDrawDialog();
          return;
        }

        // Switching player
        _currentPlayer = _currentPlayer == widget.player1Name
            ? widget.player2Name
            : widget.player1Name;
      });
    }
  }

  bool _checkWin(int row, int col) {
    String symbol = _board[row][col];

    // Checking row
    if (_board[row][0] == symbol && _board[row][1] == symbol && _board[row][2] == symbol) {
      return true;
    }

    // Checking column
    if (_board[0][col] == symbol && _board[1][col] == symbol && _board[2][col] == symbol) {
      return true;
    }

    // Checking diagonals
    if (row == col && _board[0][0] == symbol && _board[1][1] == symbol && _board[2][2] == symbol) {
      return true;
    }

    if (row + col == 2 && _board[0][2] == symbol && _board[1][1] == symbol && _board[2][0] == symbol) {
      return true;
    }

    return false;
  }

  bool _checkDraw() {
    for (var row in _board) {
      for (var cell in row) {
        if (cell.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 100.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Center(
          child: Text(
            'Congratulations !!!\n${_currentPlayer} won (+3 points)',
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (_currentPlayer == widget.player1Name) {
                    _player1Score += 3;
                  } else {
                    _player2Score += 3;
                  }
                  _newRound(widget.player1Name);
                });
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(40, 24),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text('\t \t  Ok', style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 90.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Center(
          child: Text(
            'Draw !!!\nOne point for each player',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _player1Score += 1;
                    _player2Score += 1;
                    _newRound(widget.player1Name);
                  });
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(40, 24),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 12),
                ),
                child: const Text('Ok'),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(

          content: const Text('Are you sure to exit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (_player1Score ==0 && _player2Score==0) {
                  Navigator.pop(context);
                  return;
                }
                // Determine winner to add to heroes list
                String winnerName;
                String winnerSymbol;
                int winnerScore;

                if (_player1Score > _player2Score) {
                  winnerName = widget.player1Name;
                  winnerSymbol = 'X';
                  winnerScore = _player1Score;
                } else {
                  winnerName = widget.player2Name;
                  winnerSymbol = 'O';
                  winnerScore = _player2Score;
                }

                // Return data to previous screen
                Navigator.pop(context, {
                  'name': winnerName,
                  'symbol': winnerSymbol,
                  'score': winnerScore,
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Panel'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: const Color(0xFFE8F5E9), // Light green background color
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Player scores at top
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Player 1 Score: $_player1Score',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Player 2 Score: $_player2Score',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1),
                  ],
                ),
              ),

              // Round info
              Text(
                'Round: $_round',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),


              // Turn info
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Turn: ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '${_currentPlayer == widget.player1Name ? "Player 1" : "Player 2"} (${_currentPlayer == widget.player1Name ? "X" : "O"})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _currentPlayer == widget.player1Name ? Colors.blue : Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              const SizedBox(height: 1),
              // Game board
              Container(
                width: 370,
                height: 370,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: Row(
                          children: [
                            for (int j = 0; j < 3; j++)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _makeMove(i, j),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: j < 2 ? const BorderSide(color: Colors.black, width: 3) : BorderSide.none,
                                        bottom: i < 2 ? const BorderSide(color: Colors.black, width: 3) : BorderSide.none,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _board[i][j],
                                        style: TextStyle(
                                          fontSize: 100,
                                          fontWeight: FontWeight.bold,
                                          color: _board[i][j] == 'X'
                                              ? Colors.blue
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(height: 20, thickness: 1),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _resetGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showExitDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}