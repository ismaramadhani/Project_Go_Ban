import 'package:flutter/material.dart';
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
