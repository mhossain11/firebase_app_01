import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Get total number of users where role is 'user' (case-insensitive)
  Future<int> getTotalUserCount(String roleName) async {
    try {
      // Step 1: Get all documents from 'users'
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      // Step 2: Filter manually (case-insensitive check)
      final filtered = snapshot.docs.where((doc) {
        final role = (doc['role'] ?? '').toString().toLowerCase();
        return role == roleName;
      }).toList();

      // Step 3: Return total count
      return filtered.length;
    } catch (e) {
      print('❌ Error fetching user count: $e');
      return 0;
    }
  }
}