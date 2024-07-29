import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VenderController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _uploadvenderImageToStorage(Uint8List? image) async {
    if (image == null) return '';
    Reference ref =
        _storage.ref().child('storeImages').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Uint8List?> pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image selected');
      return null;
    }
  }

  Future<void> registervender(
    String businessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegistered,
    String taxNumber,
    Uint8List? image,
  ) async {
    try {
      String storeImage = await _uploadvenderImageToStorage(image);
      await _firestore.collection('venders').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'taxRegistered': taxRegistered,
        'taxNumber': taxNumber,
        'storeImage': storeImage,
        'approved': false,
      });
    } catch (e) {
      print('Error uploading vendor details: $e');
      throw e;
    }
  }
}
