import 'package:codecraft2/stage10.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Stage9 extends StatefulWidget {
  @override
  _Stage9State createState() => _Stage9State();
}

class _Stage9State extends State<Stage9> {
  TextEditingController _answerController1 = TextEditingController();
  TextEditingController _answerController2 = TextEditingController();
  TextEditingController _answerController3 = TextEditingController();
  int _princeRow = 0;
  int _princeCol = 0;
  int _princessRow = 0;
  int _princessCol = 1; // เจ้าหญิงอยู่ที่ (row 0, col 1) ตามเริ่มต้น
  int _prince1Row = 0;
  int _prince1Col = 2;
  bool _isGridVisible = false;
  bool _showAnswer = false;
  String _feedback = '';
  int _currentPage = 0;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<String> correctCommands = [
    "flex-direction: row-reverse;",
    "justify-content: center;",
    "align-items: center;"
  ];
  final List<String> storyImages = [
    'assets/story/9.1.png',
    'assets/story/9.2.png',
    'assets/story/9.3.png',
    'assets/d9.png',
    'assets/d9.2.png',
    'assets/d9.3.png',
  ];

  void _moveCharacter() {
    String command = _answerController1.text.trim() +
        _answerController2.text.trim() +
        _answerController3.text.trim();
    setState(() {if (command.isEmpty) {
        _princeRow = 0;
        _princeCol = 0;
        _princessRow = 0;
        _princessCol = 1;
        _prince1Row = 0;
        _prince1Col = 3;
      } else if (command ==
          "flex-direction: row-reverse;justify-content: center;align-items: center;") {
        _princeRow = 2;
        _princeCol = 3;

        _princessRow = 2;
        _princessCol = 2;

        _prince1Row = 2;
        _prince1Col = 1;
      }
    });
  }

  void _saveStageCompletion() async {
    if (_currentUser != null) {
      await _databaseRef
          .child('userscodecraft/${_currentUser!.uid}/stages')
          .update({'stage9': true});
    }
  }

  void _checkAnswer() {
    String fullCommand = _answerController1.text.trim() +
        _answerController2.text.trim() +
        _answerController3.text.trim();
    if (fullCommand ==
        "flex-direction: row-reverse;justify-content: center;align-items: center;") {
      setState(() {
        _feedback = 'Correct! Well done!';
      });
      _saveStageCompletion();
      _showCompletionDialog();
    } else {
      setState(() {
        _feedback = 'Incorrect! Try again.';
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          backgroundColor: Colors.black87,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/gif/player/Maruto.gif',
                  width: 100, height: 100),
              SizedBox(height: 10),
              Text(
                'Stage 9 completed!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Next stage',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Stage10())); // Next stage logic here
                },
                child: Text('Go to Next Stage'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(20),
              backgroundColor: Colors.black87,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(storyImages[_currentPage],
                      width: 500, height: 500),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentPage--;
                            });
                          },
                          child: Text('Previous',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      Text('${_currentPage + 1}/6',
                          style: TextStyle(color: Colors.white)),
                      if (_currentPage < 5)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentPage++;
                            });
                          },
                          child: Text('Next',
                              style: TextStyle(color: Colors.blue)),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0033FF),
                            Color(0xFF3399FF)
                          ], // ไล่สีจากน้ำเงินเข้มไปฟ้าน้ำทะเล
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    Color(0xFF0033FF),
                    Color(0xFF3399FF)
                  ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                'กองเงินกองทอง',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _showStoryDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0033FF),
                        Color(0xFF3399FF)
                      ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    "กดดูเนื้อเรื่อง",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAnswer = !_showAnswer;
                });
              },
              child: Text(
                'Show Answer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
            if (_showAnswer) ...[
              SizedBox(height: 10),
              Text(
                "flex-direction: row-reverse;\njustify-content: center;\nalign-items: center;",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
             Center(
              child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgstage/bgstage05.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  if (_isGridVisible)
                    Positioned.fill(
                      child: Column(
                        children: List.generate(5, (rowIndex) {
                          return Expanded(
                            child: Row(
                              children: List.generate(5, (colIndex) {
                                return Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),

                  // แอปเปิ้ล 1 (ลูกที่ 1)
                  Positioned(
                    top: (2 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (3 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/gif/item/coin.gif',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  // แอปเปิ้ล 2 (ลูกที่ 2)
                  Positioned(
                    top: (2 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/gif/item/coin.gif',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  // แอปเปิ้ล 3 (ลูกที่ 3)
                  Positioned(
                    top: (2 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (1 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/gif/item/coin.gif',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (_princeRow * (350 / 5)) + (350 / 5 / 2) - 50,
                    left: (_princeCol * (350 / 5)) + (350 / 5 / 2) - 30,
                    child: Image.asset(
                      'assets/gif/player/Maruto.gif',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  // เจ้าหญิง
                  Positioned(
                    top: (_princessRow * (350 / 5)) + (350 / 5 / 2) - 25,
                    left: (_princessCol * (350 / 5)) + (350 / 5 / 2) - 10,
                    child: Image.asset(
                      'assets/gif/player/Charlotte.gif',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Positioned(
                    top: (_prince1Row * (350 / 5)) + (350 / 5 / 2) - 25,
                    left: (_prince1Col * (350 / 5)) + (350 / 5 / 2) - 10,
                    child: Image.asset(
                      'assets/gif/player/Alucard.gif',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              ),
            ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isGridVisible,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isGridVisible = newValue!;
                    });
                  },
                ),
                Text("Show Grid", style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 54, 54, 54),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('1', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "#field {",
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('2', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "display: flex;",
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      children: [
                        Text('3', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _answerController1,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: 'Type your code here...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              if (text != correctCommands[0]) {
                                _answerController1.text = correctCommands[0];
                                _answerController1.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _answerController1.text.length));
                              }
                              _moveCharacter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      children: [
                        Text('4', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _answerController2,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              if (text != correctCommands[1]) {
                                _answerController2.text = correctCommands[1];
                                _answerController2.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _answerController2.text.length));
                              }
                              _moveCharacter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      children: [
                        Text('5', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: _answerController3,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              if (text != correctCommands[2]) {
                                _answerController3.text = correctCommands[2];
                                _answerController3.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _answerController3.text.length));
                              }
                              _moveCharacter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('6', style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "}",
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: _checkAnswer,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0033FF),
                        Color(0xFF3399FF)
                      ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    "Check Answer",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_feedback.isNotEmpty) ...[
              Text(
                _feedback,
                style: TextStyle(
                    color: _feedback.contains('Correct')
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
