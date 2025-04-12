import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../models/document_request_model.dart';
import './auth_service.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<void> submitRequest(DocumentRequest request) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Please sign in to submit requests');
    }

    final docRef = await _firestore.collection('document_requests').add({
      'name': request.name,
      'userEmail': request.userEmail,
      'organizationId': request.organizationId,
      'documentType': request.documentType,
      'requestDate': FieldValue.serverTimestamp(),
      'status': 'pending',
      'details': request.details,
      'userId': user.uid,
    });

    await docRef.update({'id': docRef.id});
  }

  Stream<List<DocumentRequest>> getUserRequests() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('document_requests')
        .where('userEmail', isEqualTo: user.email)  // Query by user email
        .orderBy('requestDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DocumentRequest.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
}
}