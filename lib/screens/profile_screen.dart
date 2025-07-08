import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_math_trainer_app/firebase/firebase_auth_services.dart';
import 'package:mental_math_trainer_app/widgets/loading_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isImageLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadingImageWithDelay();
  }

  Future<void> _loadingImageWithDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      children: [
                        _isImageLoading
                            ? Shimmer.fromColors(
                                highlightColor: Colors.grey[100]!,
                                baseColor: Colors.grey[300]!,
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                ),
                              ),
                        const SizedBox(height: 10),
                        Text(
                          _user?.displayName ?? 'User',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _user?.email ?? 'youremail@example.com',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildProfileOption(context, 'Edit Profile', Icons.edit, () {}),
                _buildProfileOption(context, 'Settings', Icons.settings, () {}),
                _buildProfileOption(
                  context,
                  'Log Out',
                  Icons.logout,
                  () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await FirebaseAuthService().signOutFromGoogle();
                    } catch (e) {
                      print(e);
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),
                if (isLoading) const LoadingScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
