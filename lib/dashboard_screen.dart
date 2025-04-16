import 'package:app/login_page.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'folder_page.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/biometric_service.dart';  // Make sure this path is correct

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String mobile;
  final String email;

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.mobile,
    required this.email,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late String currentUserName;
  late String currentMobile;
  late String currentEmail;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    currentUserName = widget.userName;
    currentMobile = widget.mobile;
    currentEmail = widget.email;
  }

  void updateProfile(String name, String mobile, String email) {
    setState(() {
      currentUserName = name;
      currentMobile = mobile;
      currentEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),  // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard'),
              Flexible(  // Added Flexible
                child: Row(
                  mainAxisSize: MainAxisSize.min,  // Added this
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 4),  // Reduced spacing
                    Flexible(  // Added Flexible
                      child: Text(
                        'Hello, $currentUserName',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final Future<SharedPreferences> prefs =
                    SharedPreferences.getInstance();
                prefs.then((SharedPreferences prefs) {
                  prefs.setBool('isloggedin', false);
                  prefs.setBool('isbiometricenabled', false);
                });
              await _authService.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Folders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const FoldersSection();
      case 1:
        return ProfileSection(
          userName: currentUserName,
          mobile: currentMobile,
          email: currentEmail,
          onProfileUpdate: updateProfile,
        );
      default:
        return const FoldersSection();
    }
  }
}

class FoldersSection extends StatelessWidget {
  const FoldersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(  // Changed from GridView.count directly to Column
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildFolder('Finances', '💰', context),
                _buildFolder('Health', '🏥', context),
                _buildFolder('Identity', '🪪', context),
                _buildFolder('Education', '🎓', context),
              ],
            ),
            const SizedBox(height: 20),  // Add some spacing
            ElevatedButton(
              onPressed: () async {
                bool success = await BiometricService().authenticateWithBiometrics();
                if (success) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isBiometricAdded', true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biometric authentication enabled')),
                  );
                }
              },
              child: const Text('Enable Biometric Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolder(String name, String emoji, BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FolderPage(
                title: name,
                emoji: emoji,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}