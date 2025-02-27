import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'profilesetup.dart';
import 'stage.dart';
import 'archivement.dart';
import 'signin_page.dart';

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
  int _selectedIndex = 0; // ใช้เก็บ index ของหน้า

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
        _fetchUserData(); // รีเฟรชข้อมูลเมื่อแก้ไขสำเร็จ
      }
    });
  }

  // ฟังก์ชันสำหรับการสลับหน้าใน navigation bar
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
              'assets/logo.png', // ใส่ path ของรูปโลโก้ที่คุณต้องการใช้
              height: 45,
              width: 45,
            ),
            SizedBox(width: 10),
            Text('Codecraft'),
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
            colors: [
              Color(0xFF0033FF),
              Color(0xFF3399FF)
            ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
            begin: Alignment.centerLeft, // เริ่มจากด้านซ้าย
            end: Alignment.centerRight, // ไปทางขวา
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

            // ปุ่มแก้ไขโปรไฟล์
            ListTile(
              tileColor: Colors.black,
              leading: Icon(Icons.edit, color: Colors.white),
              title: Text(
                'แก้ไขโปรไฟล์: Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _navigateToProfileSetup,
            ),
            // ปุ่มออกจากระบบ
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // หน้า Home
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // จัดเรียงเนื้อหาให้อยู่ตรงกลาง
              children: [
                SizedBox(height: 20), // กำหนดช่องว่าง
                // ข้อความหัวข้อหลัก
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'Learn Code By\n',
                          style: TextStyle(
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(
                          text: 'Playing ',
                          style: TextStyle(
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(
                          text: 'Games',
                          style: TextStyle(
                              fontSize: 39,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // คำอธิบายเนื้อหา
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // ระยะห่างซ้ายขวา
                  child: Text(
                    'Learning to code is no longer a dull experience with ITINs. '
                    'We transform the learning process into an engaging and interactive experience, '
                    'making it as fun and exciting as playing a game.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 10),
                // ปุ่ม "Play and Learn Code"
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0151FF),
                        Color(0xFF0095FF)
                      ], // ไล่สีจากซ้ายไปขวา
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // มุมโค้งมน
                  ),
                  child: SizedBox(
                    width: 200, // ปุ่มกว้างเต็มจอ
                    height: 50, // กำหนดความสูง 50
                    child: ElevatedButton(
                      onPressed: () {}, // กำหนดฟังก์ชันเมื่อกดปุ่ม
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // ให้ปุ่มเป็นสีโปร่งใส เพื่อให้เห็น Gradient
                        shadowColor: Colors.transparent, // เอาเงาออก
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        'Play and Learn Code',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // พื้นที่เล่นเกม (ตัวอย่าง)
                Padding(
                  padding: EdgeInsets.all(20), // เพิ่ม padding ทุกด้าน 20
                  child: Container(
                    height: 250, // ความสูงเริ่มต้น
                    width: 450, // ความกว้างเต็มหน้าจอ
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 9, 109, 54),
                      // สีพื้นหลังเทาอ่อนเพื่อรอใส่ content
                      borderRadius: BorderRadius.circular(10), // ขอบโค้งมน
                      border:
                          Border.all(color: Colors.grey, width: 2), // เส้นขอบ
                    ),
                    child: Center(
                      child: Text(
                        'พื้นที่ว่างสำหรับใส่ เกม',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ),
                ),
                // ช่องใส่โค้ด
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 30), // ระยะห่างซ้ายขวา
                  padding: EdgeInsets.all(15), // เพิ่ม padding
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2E2E), // เปลี่ยนเป็นสีเทาเข้มขึ้น
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style:
                              TextStyle(fontFamily: 'monospace', fontSize: 16),
                          children: [
                            TextSpan(
                                text: '1 ',
                                style: TextStyle(color: Colors.grey)),
                            TextSpan(
                              text: 'display',
                              style: TextStyle(
                                  color: Colors.lightGreenAccent, fontSize: 17),
                            ),
                            TextSpan(
                                text: ': flex;\n',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            TextSpan(
                                text: '2 ',
                                style: TextStyle(color: Colors.grey)),
                            TextSpan(
                              text: 'justify-content',
                              style: TextStyle(
                                  color: Colors.lightGreenAccent, fontSize: 17),
                            ),
                            TextSpan(
                                text: ': center;',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8), // ระยะห่างเล็กน้อยก่อนถึงบรรทัด 3
                      Row(
                        children: [
                          Text(
                            '3 ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'monospace',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Color(0xFF5A5A5A), // สีเทาเข้มขึ้น
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.5), // เงาสีดำ
                                    offset: Offset(2, 2), // ตำแหน่งเงา
                                    blurRadius: 4, // ความฟุ้งของเงา
                                  ),
                                ],
                              ),
                              child: TextField(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace'),
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // ปุ่ม "Check Answer"
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF0151FF),
                        Color(0xFF0095FF)
                      ], //สีจากซ้ายไปขวา
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20), // มุมโค้งมน
                  ),
                  child: ElevatedButton(
                    onPressed: () {}, // ฟังก์ชันเมื่อกดปุ่ม
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // ให้ปุ่มเป็นสีโปร่งใส
                      shadowColor: Colors.transparent, // ไม่มีเงา
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // ระยะห่างในปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // มุมโค้งมน
                      ),
                    ),
                    child: Container(
                      width: 145, // กำหนดความกว้างของปุ่ม
                      height: 45, // กำหนดความสูงของปุ่ม
                      alignment: Alignment.center, // จัดข้อความให้อยู่กึ่งกลาง
                      child: Text(
                        'Check Answer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // หน้า Stage
          Stage(),
          // หน้า Archivement
          Archivement(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0033FF),
              Color(0xFF3399FF)
            ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
            begin: Alignment.centerLeft, // เริ่มจากด้านซ้าย
            end: Alignment.centerRight, // ไปทางขวา
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Colors.transparent, // ทำให้พื้นหลังโปร่งใสเพื่อให้เห็น Gradient
          selectedItemColor: Colors.white, // สีของไอเท็มที่ถูกเลือกเป็นสีขาว
          unselectedItemColor:
              Colors.white, // สีของไอเท็มที่ไม่ได้เลือกเป็นสีดำ
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Stage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: 'Archivement',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
