import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSection extends StatefulWidget {
  final String userName;
  final String mobile;
  final String email;
  final Function(String, String, String) onProfileUpdate;

  const ProfileSection({
    super.key,
    required this.userName,
    required this.mobile,
    required this.email,
    required this.onProfileUpdate,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    mobileController = TextEditingController(text: widget.mobile);
  }

  Future<void> updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'phone': mobileController.text,
      });
      widget.onProfileUpdate(
        nameController.text,
        mobileController.text,
        widget.email,
      );
      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(
              widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 20),
          isEditing
              ? Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: mobileController,
                      decoration: const InputDecoration(labelText: 'Mobile'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Text('Save Changes'),
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(widget.userName),
                    ),
                    ListTile(
                      title: const Text('Mobile'),
                      subtitle: Text(widget.mobile),
                    ),
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(widget.email),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => isEditing = true),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}