import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/dashboard_screen.dart';

class ProfileSetupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ProfileSetupPage(),
      );
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> saveUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': user.email,
        });
        
        if (mounted) {
          // Replace the current screen with DashboardScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                userName: nameController.text.trim(),
                mobile: phoneController.text.trim(),
                email: user.email ?? '',
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Complete Profile',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveUserProfile,
                child: const Text(
                  'COMPLETE SETUP',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}