import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? get currentUser => _auth.currentUser;

  Future<String> _uploadProfileImageToStorage(Uint8List image) async {
    try {
      Reference ref =
          _storage.ref().child('profilepics').child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(image);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? file = await _imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print('No Image selected');
      return null;
    }
  }

  Future<String> signUpUsers(String email, String fullName, String phoneNumber,
      String password, Uint8List? image) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String profileImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('buyers').doc(cred.user!.uid).set({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'buyerId': cred.user!.uid,
          'address': '',
          'profileImage': profileImageUrl,
        });
        res = 'success';
      } else {
        res = 'Please fill in missing information';
      }
    } catch (e) {
      print('Error in signUpUsers: $e');
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUsers(String email, String password) async {
    String res = 'Something went wrong';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fields must not be empty';
      }
    } catch (e) {
      print('Error in loginUsers: $e');
      res = e.toString();
    }
    return res;
  }

  Future<String> _initializeChat(String vendorId, String buyerId) async {
    final chatDoc = FirebaseFirestore.instance.collection('chats').doc();
    await chatDoc.set({
      'vendorId': vendorId,
      'buyer': buyerId,
    });
    return chatDoc.id;
  }
}
