import 'package:codecraft2/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Stage11 extends StatefulWidget {
  @override
  _Stage11State createState() => _Stage11State();
}

class _Stage11State extends State<Stage11> {
  TextEditingController _answerController1 = TextEditingController();

  int _princeRow = 1;
  int _princeCol = 1;
  int _princessRow = 2;
  int _princessCol = 3;
  int _prince1Row = 2;
  int _prince1Col = 0;
  bool _isGridVisible = false;
  bool _showAnswer = false;
  String _feedback = '';
  int _currentPage = 0;

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<String> storyImages = [
    'assets/boy.png',
    'assets/apple.png',
    'assets/story_image_3.png',
    'assets/story_image_4.png',
    'assets/story_image_5.png',
  ];

  void _moveCharacter() {
    String command = _answerController1.text.trim();
    if (command == "align-items: center;") {
      setState(() {
        _princeRow = 2;
        _princeCol = 1;
      });
    }
  }

  void _saveStageCompletion() async {
    if (_currentUser != null) {
      await _databaseRef
          .child('userscodecraft/${_currentUser!.uid}/stages')
          .update({'stage11': true});
    }
  }

  void _checkAnswer() {
    String fullCommand = _answerController1.text.trim();
    if (fullCommand == "align-items: center;") {
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
              Image.asset('assets/boy.png', width: 100, height: 100),
              SizedBox(height: 10),
              Text(
                'Stage 11 completed!',
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
                              HomePage())); // Next stage logic here
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
                      Text('${_currentPage + 1}/5',
                          style: TextStyle(color: Colors.white)),
                      if (_currentPage < 4)
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
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close', style: TextStyle(color: Colors.white)),
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
                    const Color.fromARGB(255, 36, 152, 247),
                    const Color.fromARGB(255, 0, 94, 255)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                'Stage 11',
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
                        const Color.fromARGB(255, 36, 152, 247),
                        const Color.fromARGB(255, 0, 94, 255)
                      ],
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
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (_showAnswer) ...[
              SizedBox(height: 10),
              Text(
                "align-items: center;",
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
                  // ตำแหน่งของตัวละครหลัก
                  Positioned(
                    top: (4 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (4 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree8.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (4 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (3 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree7.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (4 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree6.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (4 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (1 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/dog.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (4 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (0 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree5.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (3 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (0 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/dadman.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (3 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (4 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/dadgirl.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (2 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (4 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/girl.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (1 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/box.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (0 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/endgameitem.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (0 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (4 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree4.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (1 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (3 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree3.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (0 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (1 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree2.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (1 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (0 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/tree1.png',
                      width: 30,
                      height: 40,
                    ),
                  ),
                  Positioned(
                    top: (2 * (350 / 5)) + (350 / 10) - (40 / 2),
                    left: (2 * (350 / 5)) + (350 / 8) - (30 / 2),
                    child: Image.asset(
                      'assets/ring.png',
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
                              _moveCharacter();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('4', style: TextStyle(color: Colors.grey)),
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
                        const Color.fromARGB(255, 36, 152, 247),
                        const Color.fromARGB(255, 0, 94, 255)
                      ],
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
                  color:
                      _feedback.contains('Correct') ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
