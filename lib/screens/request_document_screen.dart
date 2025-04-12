import 'package:flutter/material.dart';
import '../models/document_request_model.dart';
import '../services/document_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestDocumentScreen extends StatefulWidget {
  final String organizationId;
  final String documentType;
  final Map<String, String> documentFields;

  const RequestDocumentScreen({
    super.key,
    required this.organizationId,
    required this.documentType,
    required this.documentFields,
  });

  @override
  State<RequestDocumentScreen> createState() => _RequestDocumentScreenState();
}

class _RequestDocumentScreenState extends State<RequestDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final _documentService = DocumentService();

  @override
  void initState() {
    super.initState();
    for (var field in widget.documentFields.keys) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> details = {};
      for (var entry in _controllers.entries) {
        details[entry.key] = entry.value.text;
      }

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to submit request')),
          );
          return;
        }

        final request = DocumentRequest(
          id: '',
          name: widget.documentType,
          userEmail: user.email ?? '',
          userId: user.uid,  // Add user ID
          organizationId: widget.organizationId,
          documentType: widget.documentType,
          requestDate: DateTime.now(),
          status: DocumentRequestStatus.pending,
          details: details,
        );

        await _documentService.submitRequest(request);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request submitted successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request ${widget.documentType}'),
      ),
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.documentFields.entries.map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _controllers[field.key],
                      decoration: InputDecoration(
                        labelText: field.value,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ${field.value}';
                        }
                        return null;
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitRequest,
                  child: const Text('Submit Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}