import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Archivement extends StatefulWidget {
  @override
  _ArchivementPageState createState() => _ArchivementPageState();
}

class _ArchivementPageState extends State<Archivement> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  List<String> stageImages = [
    'assets/bgstage/bg1.png',
    'assets/bgstage/bg2.png',
    'assets/bgstage/bg3.png',
    'assets/bgstage/bg4.png',
    'assets/bgstage/bg5.png',
    'assets/1.png',
    'assets/1.png',
    'assets/1.png',
    'assets/1.png',
    'assets/1.png',
    'assets/bgstage/bg11.png',
  ];

  List<String> stageDescriptions = [
    'จุดเริ่มต้นของ Code',
    'การพบกับนักเวทหญิง',
    'ดาบแห่งโค้ด',
    'เส้นทางที่เต็มไปด้วยกับดัก',
    'คนป่ากับขวานอัลกอริทึม',
    'พักเหนื่อย',
    'สนามประลองอัลกอริทึม',
    'หมวกเกราะป้องกันไวรัส',
    'ปรับปรุงโค้ดให้ดีขึ้น',
    'ศึกสุดท้ายกับบอสใหญ่',
    'พิธีวิวาห์แห่งความมุ่งมั่น',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      try {
        final snapshot = await _databaseRef
            .child('userscodecraft/${_currentUser!.uid}')
            .get();
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
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: _userData?['profileImage'] != null
                  ? NetworkImage(_userData!['profileImage'])
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              _userData?['username'] ?? 'Player01',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds),
  child: const Text(
    'Archievement',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white, // สีขาวเพื่อให้ ShaderMask ทำงาน
    ),
  ),
),
const SizedBox(height: 20),

            StreamBuilder(
              stream: _databaseRef
                  .child('userscodecraft/${_currentUser!.uid}/stages')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data!.snapshot.value != null) {
                  final stagesData = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map);
                  List<bool> stageCompletion = List.generate(11, (index) {
                    return stagesData['stage${index + 1}'] ?? false;
                  });

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75, // ปรับให้สมดุลทุกหน้าจอ
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: stageCompletion.length,
                    itemBuilder: (context, index) {
                      return AchievementCard(
                        stage: index + 1,
                        imagePath: stageImages[index],
                        description: stageDescriptions[index],
                        isCompleted: stageCompletion[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final int stage;
  final String imagePath;
  final String description;
  final bool isCompleted;

  const AchievementCard({
    required this.stage,
    required this.imagePath,
    required this.description,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5, // ให้กรอบมีเงาสวยขึ้น
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [Color(0xFF0033FF), Color(0xFF3399FF)], // ไล่สีจากน้ำเงินเข้มไปฟ้าน้ำทะเล
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds),
  child: Text(
    'Stage $stage',
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white, // ใช้สีขาวเพื่อให้ ShaderMask ทำงาน
    ),
  ),
),
const SizedBox(height: 4),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Icon(isCompleted ? Icons.check_circle : Icons.cancel,
                color: isCompleted ? Colors.green : Colors.red, size: 28),
          ],
        ),
      ),
    );
  }
}