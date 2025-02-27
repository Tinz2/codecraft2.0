import 'package:codecraft2/stage9.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Stage8 extends StatefulWidget {
  @override
  _Stage8State createState() => _Stage8State();
}

class _Stage8State extends State<Stage8> {
  TextEditingController _answerController1 = TextEditingController();
  TextEditingController _answerController2 = TextEditingController();
  TextEditingController _answerController3 = TextEditingController();
  int _princeRow = 0;
  int _princeCol = 1;
  int _princessRow = 0;
  int _princessCol = 0; // เจ้าหญิงอยู่ที่ (row 0, col 1) ตามเริ่มต้น
  int _prince1Row = 0;
  int _prince1Col = 2;
  bool _isGridVisible = false;
  bool _showAnswer = false;
  String _feedback = '';
  int _currentPage = 0;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<String> correctCommands = [
    "justify-content: center;",
    "justify-content: space-between;",
    "justify-content: space-around;",
    "justify-content: space-evenly;",
    "align-items: center;",
    "align-items: flex-end;",
    "flex-direction: column;",
    "flex-direction: row-reverse;",
    "flex-direction: column-reverse;",
    "justify-content: flex-end;",
    "align-self: center;"
  ];
  final List<String> storyImages = [
    'assets/boy.png',
    'assets/apple.png',
    'assets/story_image_3.png',
    'assets/story_image_4.png',
    'assets/story_image_5.png',
  ];

  void _moveCharacter(String command) {
    setState(() {
      if (command ==
          "flex-direction: column-reverse; \njustify-content: flex-end \n;align-items: center") {
        _princeRow = 1;
        _princeCol = 2;

        _princessRow = 2;
        _princessCol = 2;

        _prince1Row = 0;
        _prince1Col = 2;
      } else if (command == "justify-content: space-between;") {
        _princeRow = 0;
        _princeCol = 4;
        _princessRow = 2;
        _princessCol = 1;
      } else if (command == "justify-content: center;") {
        _princeRow = 0;
        _princeCol = 2;
        _princessRow = 0;
        _princessCol = 2;
      } else if (command == "justify-content: space-around;") {
        _princeRow = 2;
        _princeCol = 3;
        _princessRow = 2;
        _princessCol = 1;
      } else if (command == "align-items: center;") {
        _princeRow = 1;
        _princeCol = 2;
        _princessRow = 1;
        _princessCol = 2;
      } else if (command == "align-items: flex-end;") {
        _princeRow = 4;
        _princeCol = 2;
        _princessRow = 4;
        _princessCol = 2;
      } else if (command == "flex-direction: column;") {
        _princeRow = 3;
        _princeCol = 3;
        _princessRow = 3;
        _princessCol = 3;
      } else if (command == "flex-direction: row-reverse;") {
        _princeRow = 0;
        _princeCol = 0;
        _princessRow = 0;
        _princessCol = 0;
      } else if (command == "flex-direction: column-reverse;") {
        _princeRow = 4;
        _princeCol = 0;
        _princessRow = 4;
        _princessCol = 0;
      } else if (command == "justify-content: flex-end;") {
        _princeRow = 4;
        _princeCol = 3;
        _princessRow = 4;
        _princessCol = 3;
      } else if (command == "align-self: center;") {
        _princeRow = 1;
        _princeCol = 3;
        _princessRow = 1;
        _princessCol = 3;
      }
    });
  }

  void _saveStageCompletion() async {
    if (_currentUser != null) {
      await _databaseRef
          .child('userscodecraft/${_currentUser!.uid}/stages')
          .update({'stage8': true});
    }
  }

  void _checkAnswer() {
    setState(() {
      // ขยับตัวละครไปเก็บแอปเปิ้ลทันที
      _princeRow = 1; // ปรับให้เดินไปที่แอปเปิ้ล
      _princeCol = 2;

      _princessRow = 2;
      _princessCol = 2;

      _prince1Row = 0;
      _prince1Col = 2;
    });

    // แสดงข้อความสำเร็จ
    _saveStageCompletion();
    _showCompletionDialog();
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
              Image.asset('assets/boy.png', width: 100, height: 100),
              SizedBox(height: 10),
              Text(
                'Stage 8 completed!',
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
                              Stage9())); // Next stage logic here
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
                      width: 200, height: 200),
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
                      Text('${_currentPage + 1}/5', //ตรงนี้เพิ่มเลขหน้า
                          style: TextStyle(color: Colors.white)),
                      if (_currentPage < 4) //เพิ่มหน้าตรงนี้
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
                'Stage 8',
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
                "flex-direction: column-reverse; \njustify-content: \nflex-end;align-items: center;",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/grass.jpg'),
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
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/apple.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  // แอปเปิ้ล 2 (ลูกที่ 2)
                  Positioned(
                    top: (0 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/apple.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  // แอปเปิ้ล 3 (ลูกที่ 3)
                  Positioned(
                    top: (1 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/apple.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (_princeRow * (350 / 5)) + (350 / 10) - 25,
                    left: (_princeCol * (350 / 5)) + (350 / 10) - 25,
                    child: Image.asset(
                      'assets/boy.png',
                      width: 60,
                      height: 50,
                    ),
                  ),
                  Positioned(
                    top: (_princessRow * (350 / 5)) + (350 / 10) - 25,
                    left: (_princessCol * (350 / 5)) + (350 / 10) - 25,
                    child: Image.asset(
                      'assets/girl.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Positioned(
                    top: (_prince1Row * (350 / 5)) + (350 / 10) - 25,
                    left: (_prince1Col * (350 / 5)) + (350 / 10) - 25,
                    child: Image.asset(
                      'assets/boy.png',
                      width: 60,
                      height: 50,
                    ),
                  ),
                ],
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
                              _moveCharacter(_answerController1.text.trim() +
                                  " " +
                                  _answerController2.text.trim() +
                                  " " +
                                  _answerController3.text.trim());
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
                              _moveCharacter(_answerController1.text.trim() +
                                  " " +
                                  _answerController2.text.trim() +
                                  " " +
                                  _answerController3.text.trim());
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
                              _moveCharacter(_answerController1.text.trim() +
                                  " " +
                                  _answerController2.text.trim() +
                                  " " +
                                  _answerController3.text.trim());
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
