import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/document_request_model.dart';
import '../services/document_service.dart';
import '../utils/document_fields_config.dart';
import '../screens/request_document_screen.dart';
import '../utils/constants.dart';

class FolderPage extends StatefulWidget{
  final String title;
  final String emoji;

  const FolderPage({
    super.key,
    required this.title,
    required this.emoji,
  });

  @override
  State<FolderPage> createState() => _FolderPageState();
}
class _FolderPageState extends State<FolderPage> {
  final DocumentService _documentService = DocumentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Map<String, List<String>> _documentTypes = {
    'Finances': [
      'PAN Card',
      'Form 16',
      'ITR Acknowledgment',
      'Bank Statements',
      'Salary Slips',
      'Investment Certificates',
      'Insurance Policies',
    ],
    'Health': [
      'Medical Records',
      'Vaccination Certificates',
      'Health Insurance Card',
      'Prescription Records',
      'Lab Test Reports',
      'COVID-19 Certificate',
      'Medical Bills',
    ],
    'Identity': [
      'Aadhaar Card',
      'Passport',
      'Voter ID',
      'Driving License',
      'Birth Certificate',
      'Marriage Certificate',
      'Residence Proof',
    ],
    'Education': [
      'Degree Certificate',
      '10th Mark Sheet',
      '12th Mark Sheet',
      'Transfer Certificate',
      'Migration Certificate',
      'Course Completion Certificate',
      'Entrance Exam Scores',
    ],
  };
  Future<void> _submitRequest(String documentName, Map<String, dynamic>? details) async {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to request documents')),
        );
        return;
      }
  
      try {
          final request = DocumentRequest(
            id: '',
            name: documentName,
            userEmail: user.email ?? '',
            userId: user.uid,
            organizationId: AppConstants.defaultOrganizationId,  // Use constant here
            documentType: documentName,
            requestDate: DateTime.now(),
            status: DocumentRequestStatus.pending,
            details: details,
          );
  
          await _documentService.submitRequest(request);
          
          // Refresh the stream after submission
          setState(() {});
  
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request submitted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit request: $e')),
          );
        }
      }

  Widget _buildRequestQueue() {
    return StreamBuilder<List<DocumentRequest>>(
      stream: _documentService.getUserRequests(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = snapshot.data ?? [];
        final folderRequests = requests
            .where((request) => (_documentTypes[widget.title] ?? []).contains(request.documentType))
            .toList();

        if (folderRequests.isEmpty) {
          return const Center(child: Text('No pending requests'));
        }

        return ListView.builder(
          itemCount: folderRequests.length,
          itemBuilder: (context, index) {
            final request = folderRequests[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.pending_actions),
                title: Text(request.name),
                subtitle: Text('Status: ${request.status.name}'),
                trailing: Chip(
                  label: Text(request.status.name),
                  backgroundColor: request.status == DocumentRequestStatus.pending
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRequestDialog() {
    final documents = _documentTypes[widget.title] ?? [];

    if (documents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No documents available in this folder')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request ${widget.title} Document'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: documents.map((document) {
                return ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(document),
                  trailing: SizedBox(
                    width: 100, // Fixed width for the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDocumentScreen(
                              organizationId: AppConstants.defaultOrganizationId,  // Use constant here
                              documentType: document,
                              documentFields: DocumentFieldsConfig.getFieldsForDocument(document),
                            ),
                          ),
                        );
                      },
                      child: const Text('Select'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
      ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showRequestDialog,
              icon: const Icon(Icons.request_page),
              label: const Text('Request New Document'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Requested Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildRequestQueue()),
          ],
        ),
      ),
    );
  }
}