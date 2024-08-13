import 'dart:io'; // For File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_erolex_app/views/buyers/utils/profile_settings/account_settings.dart';
import 'package:new_erolex_app/views/buyers/utils/settings.dart';
 // Import image_picker

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _profileImage;

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });

      // You might want to upload the new image to Firebase Storage here
      // and update the Firestore document with the new image URL
      // Example: await _uploadImageToFirebaseStorage(_profileImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseAuth.instance.currentUser == null
          ? Future.value(null)
          : users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.red,
            ),
            body:
                Center(child: Text("Something went wrong: ${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.green.shade100,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(child: Text("User data not found")),
          );
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: Colors.green.shade100,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.yellow.shade900,
              title: const Text(
                'Profile',
                style: TextStyle(letterSpacing: 4),
              ),
              centerTitle: true,
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.star),
                ),
              ],
            ),
            body: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (data['profileImage'] != null
                                ? NetworkImage(data['profileImage'])
                                    as ImageProvider<Object>
                                : null),
                        radius: 64,
                        backgroundColor: Colors.yellow.shade900,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['fullName'] ?? 'Name not provided',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['email'] ?? 'Email not provided',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSettingsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    textStyle: const TextStyle(color: Colors.white), // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Edit Profile'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 4,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Phone'),
                ),
                const ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Cart'),
                ),
                const ListTile(
                  leading: Icon(Icons.shopping_cart_checkout),
                  title: Text('Orders'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
