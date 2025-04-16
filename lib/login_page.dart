import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/biometric_service.dart';  // Add this import
import 'dashboard_screen.dart';  // Add this import
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showbiometric = false;
  bool isBiometricRegistered = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
    void initState() {
      super.initState();
      _checkBiometricStatus();
    }

  void _checkBiometricStatus() async {
      final prefs = await SharedPreferences.getInstance();
      bool isloggedin = prefs.getBool('isloggedin') ?? false;
      bool isBiometricAdded = prefs.getBool('isBiometricAdded') ?? false;  // New preference

      setState(() { 
        showbiometric = isBiometricAdded;
        isBiometricRegistered = isBiometricAdded;
      });
    }

  Future<void> loginUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isloggedin', true);
        await prefs.setString('userId', userCredential.user!.uid);
        
        // Store credentials for biometric login
        final biometricService = BiometricService();
        await biometricService.saveBiometricCredentials(
          emailController.text.trim(),
          passwordController.text.trim(),
          userCredential.user!.uid,
        );
      }
      
      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
  
      if (mounted && userDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(
              userName: userDoc.data()?['name'] ?? '',
              mobile: userDoc.data()?['mobile'] ?? '',
              email: userDoc.data()?['email'] ?? '',
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  Future<void> handleBiometricLogin() async {
    try {
      final biometricService = BiometricService();
      final success = await biometricService.authenticateWithBiometrics();
      
      if (success) {
        final credentials = await biometricService.getBiometricCredentials();
        if (credentials['email'] != null && credentials['password'] != null) {
          // Use stored credentials for login
          emailController.text = credentials['email']!;
          passwordController.text = credentials['password']!;
          await loginUserWithEmailAndPassword();
        } else {
          throw Exception('Biometric credentials not found');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric authentication failed: ${e.toString()}')),
        );
      }
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
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign In.',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loginUserWithEmailAndPassword();
                  },
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SignUpPage.route());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isBiometricRegistered) ...[
                  const Text(
                    'OR',
                    style: TextStyle(color: Colors.black),  // Changed to black
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if(isBiometricRegistered)...[
                    GestureDetector(
                      onTap: handleBiometricLogin,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),  // Changed to blue
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.fingerprint,
                              color: Colors.blue,  // Changed to blue
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Login with Fingerprint',
                              style: TextStyle(
                                color: Colors.blue,  // Changed to blue
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                ],
              ],
            ],
            ),
          ),
        ),
      ),
    );
  }
  
  // In your LoginPage, add this to prevent unnecessary rebuilds
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _checkBiometricStatus();  // Add this to check biometric status
        });
      }
    });
  }
}