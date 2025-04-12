import 'package:cloud_firestore/cloud_firestore.dart';

enum DocumentRequestStatus { pending, approved, rejected }

class DocumentRequest {
  final String id;
  final String name;
  final String userEmail;
  final String userId;  // Add this field
  final String organizationId;
  final String documentType;
  final DateTime requestDate;
  final DocumentRequestStatus status;
  final Map<String, dynamic>? details;

  DocumentRequest({
    required this.id,
    required this.name,
    required this.userEmail,
    required this.userId,  // Add this
    required this.organizationId,
    required this.documentType,
    required this.requestDate,
    required this.status,
    this.details,
  });

  // Update fromJson method
  factory DocumentRequest.fromJson(Map<String, dynamic> json) {
    return DocumentRequest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userId: json['userId'] ?? '',  // Add this
      organizationId: json['organizationId'] ?? '',
      documentType: json['documentType'] ?? '',
      requestDate: (json['requestDate'] as Timestamp).toDate(),
      status: DocumentRequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => DocumentRequestStatus.pending,
      ),
      details: json['details'],
    );
  }

  // Update toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userEmail': userEmail,
      'userId': userId,  // Add this
      'organizationId': organizationId,
      'documentType': documentType,
      'requestDate': requestDate,
      'status': status.toString().split('.').last,
      'details': details,
    };
  }
}