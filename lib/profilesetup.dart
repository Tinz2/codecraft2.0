import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'auth.dart';
import 'home_page.dart';

class profilesetup extends StatefulWidget {
  static const String routeName = '/profile';
  final Map<String, dynamic>? userData;
  profilesetup({this.userData});
  
  @override
  State<profilesetup> createState() => _profilesetupState();
}

class _profilesetupState extends State<profilesetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  String? _profileImageUrl;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

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

      await _dbRef.child('userscodecraft/$uid').update({
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'username': _username.text.trim(),
        'phoneNumber': _phoneNumber.text.trim(),
        'profileImage': downloadUrl ?? '',
        'profileComplete': true,
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอก $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('แก้ไขโปรไฟล์', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
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
                              leading: Icon(Icons.camera, color: Colors.black),
                              title: Text('ถ่ายรูป', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library, color: Colors.black),
                              title: Text('เลือกรูปจากแกลอรี่', style: TextStyle(color: Colors.black)),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: _profileImage != null
                          ? FileImage(File(_profileImage!.path))
                          : (_profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null) as ImageProvider?,
                      child: _profileImage == null && _profileImageUrl == null
                          ? Icon(Icons.camera_alt, color: Colors.white, size: 50)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(_firstName, 'ชื่อ (First Name)'),
                _buildTextField(_lastName, 'นามสกุล (Last Name)'),
                _buildTextField(_username, 'ชื่อผู้ใช้ (Username)'),
                _buildTextField(_phoneNumber, 'เบอร์โทรศัพท์ (Phone Number)'),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Save'),
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
