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
                  colors: [Colors.blue.shade900, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
        index: _selectedIndex, // เปลี่ยนค่า index เมื่อกดปุ่ม
        children: <Widget>[
          // แสดง HomePage Body, SharePage และ HowToPage ตาม index ที่เลือก
          Center(
            child: Text(
              'ยินดีต้อนรับ: Welcome, ${_userData?['firstName'] ?? 'ผู้ใช้: User'}!',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Stage(),
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
