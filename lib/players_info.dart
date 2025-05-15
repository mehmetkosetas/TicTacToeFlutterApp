import 'package:flutter/material.dart';
import 'game_panel.dart';

class PlayersInfoPage extends StatefulWidget {
  const PlayersInfoPage({Key? key}) : super(key: key);

  @override
  State<PlayersInfoPage> createState() => _PlayersInfoPageState();
}

class _PlayersInfoPageState extends State<PlayersInfoPage> {
  final TextEditingController _player1Controller = TextEditingController();
  final TextEditingController _player2Controller = TextEditingController();
  final List<Map<String, dynamic>> _heroes = [];
  final FocusNode _player1Focus = FocusNode();
  final FocusNode _player2Focus = FocusNode();

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _player1Focus.dispose();
    _player2Focus.dispose();
    super.dispose();
  }

  void _swapPlayerNames() {
    String temp = _player1Controller.text;
    _player1Controller.text = _player2Controller.text;
    _player2Controller.text = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Players Panel'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFE0F2E0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          // For handling keyboard overflow
          child: SingleChildScrollView(
            // For making content scrollable when keyboard appears
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-2, -14),
                          child: const Icon(Icons.account_box, size: 22, color: Colors.grey,),
                        ),

                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _player1Controller,
                                focusNode: _player1Focus,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: '',
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  constraints: BoxConstraints(maxWidth: 240),
                                ),
                                onTap: () {
                                  _player1Focus.requestFocus();
                                },
                              ),
                              const Text(
                                'Player 1',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Swap button Arrow icon
                Center(
                  child: GestureDetector(
                    onTap: _swapPlayerNames,
                    child: const Text(
                      '▲\n│\n▼',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        height: 0.9,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Player 2 Card
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-2, -14),
                          child: const Icon(Icons.account_box, size: 22, color: Colors.grey,),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _player2Controller,
                                focusNode: _player2Focus,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: '',
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  constraints: BoxConstraints(maxWidth: 240),
                                ),
                                onTap: () {
                                  _player2Focus.requestFocus();
                                },
                              ),
                              const Text(
                                'Player 2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 5),
                // Changed to Center for heading
                const Center(
                  child: Text(
                    'Heros List:',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                SizedBox(
                  // Fixed height container for heroes list
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _heroes.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(_heroes[index]['name'] + index.toString()),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            _heroes.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _heroes[index]['name'],
                                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _heroes[index]['symbol'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _heroes[index]['symbol'] == 'X'
                                          ? Colors.blue
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${_heroes[index]['score']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Adding extra space
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          // Pass player names to game panel
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePanel(
                player1Name: _player1Controller.text.isEmpty
                    ? 'Player 1'
                    : _player1Controller.text,
                player2Name: _player2Controller.text.isEmpty
                    ? 'Player 2'
                    : _player2Controller.text,
              ),
            ),
          );

          // Check the result and update heroes list
          if (result != null ) {
            setState(() {
              _heroes.add({
                'name': result['name'],
                'symbol': result['symbol'],
                'score': result['score'],
              });
            });
          }
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white,size: 50,),
        shape: const CircleBorder(),
      ),
    );
  }
}