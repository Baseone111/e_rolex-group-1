// product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChickenRolexService {
  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return FirebaseFirestore.instance
        .collection('Chicken Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'], // Fetch the vendorId field
              };
            }).toList());
  }
}

class EggRolexService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return _firestore
        .collection('Egg Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }
}

class KikomandoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return _firestore
        .collection('Kikomando')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }
}

class MeatRolexService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchMeatRolexProducts() {
    return _firestore
        .collection('Meat Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }
}

class PorkRolexService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchProducts(String collection) {
    return _firestore
        .collection('Pork Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'], // Fetch the vendorId field
              };
            }).toList());
  }
}
// product_service.dart

class SamosaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchProducts(String collectionName) {
    return _db
        .collection('Samosa Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }
}

class VegetableRolexService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> fetchProducts(String collectionName) {
    return _db
        .collection('Samosa Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }
}
