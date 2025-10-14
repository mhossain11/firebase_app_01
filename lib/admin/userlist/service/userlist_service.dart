import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListService{
  // FireStore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<void> addMonthlyDepositToUser({
    required String uid,
    required String monthId, // যেমন "2025-10"
    required double amount,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('deposits')
          .doc(monthId)
          .set({
        'month': monthId,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Deposit added successfully to user!");
    } catch (e) {
      print("Error: $e");
    }
  }

}