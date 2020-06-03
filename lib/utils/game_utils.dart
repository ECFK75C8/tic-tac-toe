import 'dart:async';

enum Player { Player1, Player2 }
enum GameState { Won, Draw, Playing }

const List<List<int>> winMoves = const [
  [0, 1, 2],
  [0, 3, 6],
  [0, 4, 8],
  [1, 4, 7],
  [2, 4, 6],
  [2, 5, 8],
  [3, 4, 5],
  [6, 7, 8]
];

extension Win on List {
  FutureOr<List<int>> get checkWin async {
    if (length < 3) return [];

    return await Future.microtask(() => winMoves.firstWhere(
        (moves) => moves.every((move) => contains(move)),
        orElse: () => []));
  }
}