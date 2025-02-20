import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'auth.dart';
import 'home_page.dart'; // Import หน้า HomePage

class profilesetup extends StatefulWidget {
  @override
  State<profilesetup> createState() => _MyHomePageState();
  static const String routeName = '/profile';
  final Map<String, dynamic>? userData;
  profilesetup({this.userData});
}

class _MyHomePageState extends State<profilesetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  String? _selectedPrefix;
  DateTime? birthdayDate;
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  String? _profileImageUrl;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadProfile(String uid) async {
    try {
      String? downloadUrl;
      if (_profileImage != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('profilescodecraft/$uid.jpg');
        if (kIsWeb) {
          await storageRef.putData(await _profileImage!.readAsBytes());
        } else {
          await storageRef.putFile(File(_profileImage!.path));
        }
        downloadUrl = await storageRef.getDownloadURL();
      } else {
        downloadUrl = _profileImageUrl;
      }

      // ดึงข้อมูล stages ที่มีอยู่แล้ว
      final stagesSnapshot =
          await _dbRef.child('userscodecraft/$uid/stages').get();
      Map<String, dynamic>? stagesData;
      if (stagesSnapshot.exists) {
        stagesData = Map<String, dynamic>.from(stagesSnapshot.value as Map);
      }

      await _dbRef.child('userscodecraft/$uid').update({
        'firstName': _firstName.text.trim(), // ตัดช่องว่างด้านหน้าและหลัง
        'lastName': _lastName.text.trim(),
        'username': _username.text.trim(),
        'phoneNumber': _phoneNumber.text.trim(),
        'birthDate':
            birthdayDate?.toIso8601String() ?? '', // ถ้า null ให้ส่งค่าว่าง
        'profileImage': downloadUrl ?? '', // ถ้า null ให้ส่งค่าว่าง
        'profileComplete': true,
        if (stagesData != null)
          'stages': stagesData, // รวมข้อมูล stages ที่มีอยู่แล้ว
      });

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading profile: $e')),
      );
    }
  }

  void _submitForm() async {
    final user = AuthService().currentUser;
    if (_formKey.currentState!.validate() && user != null) {
      _formKey.currentState!.save();
      await _uploadProfile(user.uid);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _firstName.text = widget.userData?['firstName'] ?? '';
      _lastName.text = widget.userData?['lastName'] ?? '';
      _username.text = widget.userData?['username'] ?? '';
      _phoneNumber.text = widget.userData?['phoneNumber'] ?? '';
      _profileImageUrl = widget.userData?['profileImage'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขโปรไฟล์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('ถ่ายรูป: Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text(
                                  'เลือกรูปจากแกลอรี่: Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: FutureBuilder<Uint8List?>(
                      future: _profileImage != null
                          ? _profileImage!.readAsBytes()
                          : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(snapshot.data!),
                          );
                        } else if (_profileImageUrl != null) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_profileImageUrl!),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.camera_alt, size: 50),
                          );
                        }
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: _firstName,
                  decoration: InputDecoration(labelText: 'ชื่อ (First Name)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastName,
                  decoration: InputDecoration(labelText: 'นามสกุล (Last Name)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกนามสกุล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _username,
                  decoration:
                      InputDecoration(labelText: 'ชื่อผู้ใช้ (Username)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อผู้ใช้';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumber,
                  decoration: InputDecoration(
                      labelText: 'เบอร์โทรศัพท์ (Phone Number)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกเบอร์โทร';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();
                      }
                    },
                    child: Text('บันทึก'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
