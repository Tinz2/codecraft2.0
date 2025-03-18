import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'profilesetup.dart';
import 'stage.dart';
import 'archivement.dart';
import 'signin_page.dart';
import 'characters.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/homepage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  late DatabaseReference _userRef;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      _userRef =
          FirebaseDatabase.instance.ref().child('userscodecraft/${user.uid}');
      _fetchUserData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final snapshot = await _userRef.get();
      if (snapshot.exists) {
        setState(() {
          _userData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      } else {
        setState(() {
          _userData = null;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _userData = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToProfileSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => profilesetup(
          userData: _userData,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _fetchUserData();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 45,
              width: 45,
            ),
            SizedBox(width: 10),
            Text('Codecraft', style: TextStyle(fontFamily: 'Kanit', ),),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              accountName: Text(
                _userData?['username'] != null
                    ? '${_userData!['username']}'
                    : 'ผู้ใช้: User',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                _auth.currentUser?.email ?? 'อีเมล: Email',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _userData?['profileImage'] != null
                    ? NetworkImage(_userData!['profileImage'])
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: _userData?['profileImage'] == null
                    ? Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              ),
            ),
            ListTile(
              tileColor: Colors.black,
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text(
                'แก้ไขโปรไฟล์: Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _navigateToProfileSetup,
            ),
            ListTile(
              tileColor: Colors.black,
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text(
                'ออกจากระบบ: Logout',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () async {
                await _auth.signOut(context);
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'เรียนเขียนโค้ด โดย\n',
                            style: TextStyle(
                                fontSize: 39,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: 'การเล่น',
                            style: TextStyle(
                                fontSize: 39,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: 'เกม',
                            style: TextStyle(
                                fontSize: 39,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'เรื่องราวของอาณาจักรแห่งหนึ่งที่ราชาปีศาจถูกปลดผนึกออกมา โค้ด อัศวินที่พระราชาได้ไว้ใจให้ออกไปปราบปีศาจและรวบรวมอาวุธโบราณทั้ง 4 เพื่อผนึกราชาปีศาจ การเดินทางของอัศวินโค้ดจะเป็นอย่างไรต่อไปจะสามารถจัดการกับราชาปีศาจได้หรือไม่',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0151FF), Color(0xFF0095FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                  ),
                  
                  _GameArea(),
                ],
              ),
            ),
            Stage(),
            Archivement(),
            CharactersPage(), // Add CharactersPage here
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icon/sword.png'),
                ),
                label: 'Stage',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/icon/shield.png'),
                ),
                label: 'Archivement',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Characters',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class _GameArea extends StatefulWidget {
  @override
  __GameAreaState createState() => __GameAreaState();
}

class __GameAreaState extends State<_GameArea> {
  TextEditingController _answerController = TextEditingController();
  int _characterRow = 0;
  int _characterCol = 0;
  bool _isGridVisible = false;
  bool _showAnswer = false;
  String _feedback = '';

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

  void _moveCharacter(String command) {
    setState(() {
      if (command.isEmpty) {
        _characterRow = 0;
        _characterCol = 0;
      } else if (command == "justify-content: flex-end;") {
        _characterRow = 0;
        _characterCol = 4;
      } else if (command == "justify-content: center;") {
        _characterRow = 0;
        _characterCol = 2;
      } else if (command == "justify-content: space-between;") {
        _characterRow = 0;
        _characterCol = 4;
      } else if (command == "justify-content: space-around;") {
        _characterRow = 2;
        _characterCol = 3;
      } else if (command == "justify-content: space-evenly;") {
        _characterRow = 2;
        _characterCol = 1;
      } else if (command == "align-items: center;") {
        _characterRow = 1;
        _characterCol = 2;
      } else if (command == "align-items: flex-end;") {
        _characterRow = 4;
        _characterCol = 2;
      } else if (command == "flex-direction: column;") {
        _characterRow = 3;
        _characterCol = 3;
      } else if (command == "flex-direction: row-reverse;") {
        _characterRow = 0;
        _characterCol = 0;
      } else if (command == "flex-direction: column-reverse;") {
        _characterRow = 4;
        _characterCol = 0;
      } else if (command == "justify-content: flex-end;") {
        _characterRow = 4;
        _characterCol = 3;
      } else if (command == "align-self: center;") {
        _characterRow = 1;
        _characterCol = 3;
      }
    });
  }

  void _checkAnswer() {
    String answer = _answerController.text.trim();
    if (answer == "justify-content: center;") {
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

  void _saveStageCompletion() async {
    if (_currentUser != null) {
      await _databaseRef
          .child('userscodecraft/${_currentUser!.uid}/stages')
          .update({'stage1': true});
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
                'test completed!',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bgstage/bgstage01.png'),
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
                  Positioned(
                    top: (0 * (350 / 5)) + (350 / 8) - 15,
                    left: (2 * (350 / 5)) + (350 / 8) - 15,
                    child: Image.asset(
                      'assets/gif/charecter+ring/goldring.gif',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  Positioned(
                    top: (_characterRow * (350 / 5)) + (350 / 5 / 2) - 50,
                    left: (_characterCol * (350 / 5)) + (350 / 5 / 2) - 30,
                    child: Image.asset(
                      'assets/gif/player/Maruto.gif',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Checkbox(
                value: _isGridVisible,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isGridVisible = newValue ?? false;
                  });
                },
              ),
              Text("Show Grid", style: TextStyle(color: Colors.white)),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(8),
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
                          controller: _answerController,
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: 'justify-content: center;',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            if (text.isEmpty) {
                              _moveCharacter('');
                            } else {
                              _moveCharacter(text.trim());
                            }
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
                    colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
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
                  fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }
}
