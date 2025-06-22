import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nyoba_modul_5/screens/auth/edit_profile_screen.dart';
// import 'package:nyoba_modul_5/screens/auth/change_password_screen.dart';
import 'package:nyoba_modul_5/screens/home/change_password_screen.dart';
import 'package:nyoba_modul_5/screens/home/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;

import 'package:nyoba_modul_5/services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _profileService = ProfileService();
  final _auth = FirebaseAuth.instance;

  String? _photoUrl;
  bool _isPhotoUrlValid = true;
  bool _isEmailValid = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        _userData = doc.data()!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tidak ada app bar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 40),
            // const Text(
            //   "Profile Pengguna",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     fontFamily: 'Poppins',
            //   ),
            // ),
            const SizedBox(height: 30),
            
            // Profile photo
            CircleAvatar(
              radius: 90,
              backgroundImage: _userData?['imageUrl'] != null
                  ? NetworkImage(_userData!['imageUrl'])
                  : null,
              child: _userData?['imageUrl'] == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 20),
            
            // User info
            Text(
              _userData?['name'] ?? 'Nama Pengguna',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              _userData?['email'] ?? 'email@example.com',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 40),
            
            // Menu options
            _buildMenuOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.notifications,
              title: 'Notification',
              onTap: () {},
            ),
            _buildMenuOption(
              icon: Icons.location_on,
              title: 'Shipping Address',
              onTap: () {},
            ),
            _buildMenuOption(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF41B06E)),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
    _loadProfile();

    // Listen perubahan di photoUrl textfield untuk preview & validasi
    _photoUrlController.addListener(() {
      final url = _photoUrlController.text;
      final isValid = _validateUrl(url);
      setState(() {
        _isPhotoUrlValid = isValid || url.isEmpty;
        _photoUrl = isValid ? url : null;
      });
    });

    // Listen perubahan di email textfield untuk validasi
    _emailController.addListener(() {
      final email = _emailController.text;
      setState(() {
        _isEmailValid = _validateEmail(email);
      });
    });
  }

  Future<void> _loadProfile() async {
    final doc = await _profileService.getProfile();

    _usernameController.text = doc['username'] ?? '';
    _photoUrlController.text = doc['photoUrl'] ?? '';
    _emailController.text = doc['email'] ?? _auth.currentUser?.email ?? '';

    setState(() {
      _photoUrl = doc['photoUrl'];
    });
  }

  bool _validateUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> _saveProfile() async {
    // Validasi dulu
    if (!_isPhotoUrlValid) {
      _showSnack('Invalid photo URL');
      return;
    }
    if (!_isEmailValid) {
      _showSnack('Invalid email format');
      return;
    }
    if (_usernameController.text.isEmpty) {
      _showSnack('Username cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Update email via Firebase Auth + Firestore
      if (_emailController.text != _auth.currentUser?.email) {
        await _profileService.updateEmail(_emailController.text);
      }
      // Update password via Firebase Auth jika diisi
      if (_passwordController.text.isNotEmpty) {
        await _profileService.updatePassword(_passwordController.text);
      }

      // Update username & photoUrl di Firestore
      await _profileService.createOrUpdateProfile(
        username: _usernameController.text,
        photoUrl:
            _photoUrlController.text.isEmpty ? null : _photoUrlController.text,
      );

      _showSnack('Profile updated!');
      _passwordController.clear();
    } catch (e) {
      _showSnack('Failed to update profile: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _photoUrlController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview photo kotak besar 150x150
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPhotoUrlValid ? Colors.grey : Colors.red,
                  width: 2,
                ),
                image:
                    _photoUrl != null && _photoUrl!.isNotEmpty
                        ? DecorationImage(
                          image: NetworkImage(_photoUrl!),
                          fit: BoxFit.cover,
                        )
                        : null,
                color: Colors.grey[200],
              ),
              child:
                  (_photoUrl == null || _photoUrl!.isEmpty)
                      ? const Icon(Icons.image, size: 80, color: Colors.grey)
                      : null,
            ),
            const SizedBox(height: 16),

            // Username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: _isEmailValid ? null : 'Invalid email',
              ),
            ),
            const SizedBox(height: 16),

            // Photo URL
            TextField(
              controller: _photoUrlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Photo URL',
                border: const OutlineInputBorder(),
                errorText: _isPhotoUrlValid ? null : 'Invalid URL',
              ),
            ),
            const SizedBox(height: 16),

            // Password (optional)
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password (leave blank to keep)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon:
                  _isSaving
                      ? const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      )
                      : const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: _isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
