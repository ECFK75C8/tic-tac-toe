import 'package:flutter/material.dart';
import '../utils/game_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int scoreP1 = 0, scoreP2 = 0;
  bool tooglePlayer = true;
  Map<int, Player> _selected = {};
  List<int> _selectedIndexesP1 = [], _selectedIndexesP2 = [], _winTile = [];
  GameState gameState = GameState.Playing;

  void _pressTileAction(int index) async {
    _selected.putIfAbsent(
        index, () => (tooglePlayer) ? Player.Player1 : Player.Player2);
    tooglePlayer
        ? _selectedIndexesP1.add(index)
        : _selectedIndexesP2.add(index);

    var result = tooglePlayer
        ? await _selectedIndexesP1.checkWin
        : await _selectedIndexesP2.checkWin;

    _winTile = [...result];

    setState(() {});
    if (_winTile.isNotEmpty) {
      gameState = GameState.Won;
      tooglePlayer ? ++scoreP1 : ++scoreP2;
      return;
    }
    if (checkDraw) gameState = GameState.Draw;
    tooglePlayer = !tooglePlayer;
  }

  void _reset() {
    setState(() {
      tooglePlayer = true;
      _winTile.clear();
      _selected.clear();
      _selectedIndexesP1.clear();
      _selectedIndexesP2.clear();
      gameState = GameState.Playing;
    });
  }

  bool get checkDraw =>
      !([..._selectedIndexesP1, ..._selectedIndexesP2].length < 9);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var gridBoxSize = mediaQuery.size.width - 20;
    var landscapeGridBoxSize =
        (mediaQuery.size.height - mediaQuery.padding.top) - 38;
    var isLandscape = mediaQuery.orientation == Orientation.landscape;

    var body = Container(
      color: Colors.black,
      width: isLandscape ? landscapeGridBoxSize : gridBoxSize,
      height: isLandscape ? landscapeGridBoxSize : gridBoxSize,
      margin: EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: List.generate(
          9,
          (index) => LayoutBuilder(
            builder: (_, contraints) => Container(
              width: (contraints.maxWidth / 3),
              height: (contraints.maxWidth / 3),
              color: gameState != GameState.Draw
                  ? _winTile.contains(index)
                      ? Theme.of(context).accentColor
                      : Theme.of(context).canvasColor
                  : Colors.grey,
              child: FlatButton(
                onPressed: gameState != GameState.Playing
                    ? null
                    : _selected.keys.contains(index)
                        ? null
                        : () => _pressTileAction(index),
                child: (!_selected.containsKey(index))
                    ? SizedBox.shrink()
                    : Image.asset(
                        'assets/images/${_selected[index] == Player.Player1 ? 'x.png' : 'circle.png'}',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
    );

    var chips = [
      Chip(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        label: FittedBox(
            child: Text('${isLandscape ? 'Player 1' : 'P1'}: $scoreP1')),
        labelStyle:
            TextStyle(color: (tooglePlayer) ? Colors.white : Colors.black54),
        backgroundColor:
            (tooglePlayer) ? Theme.of(context).accentColor : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      SizedBox(width: 10),
      Chip(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        label: FittedBox(
            child: Text('${isLandscape ? 'Player 2' : 'P2'}: $scoreP2')),
        labelStyle:
            TextStyle(color: (!tooglePlayer) ? Colors.white : Colors.black54),
        backgroundColor:
            (!tooglePlayer) ? Theme.of(context).accentColor : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    ];

    var controls = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...chips,
        SizedBox(height: 20),
        RaisedButton(
          onPressed: _reset,
          child: Text('Reset'),
        )
      ],
    );

    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                ...chips,
                SizedBox(width: 10),
                IconButton(
                  tooltip: 'Reset',
                  icon: Icon(Icons.refresh),
                  onPressed: _reset,
                ),
              ],
            ),
      body: !isLandscape
          ? Center(child: body)
          : SafeArea(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[body, controls],
              ),
            )),
    );
  }
}
