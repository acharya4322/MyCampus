import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Adminelibrary extends StatefulWidget {
  @override
  _AdminelibraryState createState() => _AdminelibraryState();
}

class _AdminelibraryState extends State<Adminelibrary> {
  File? _pdfFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _categoryController = TextEditingController();

  Future<void> _uploadPdf() async {
    if (_pdfFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a PDF file.')),
      );
      return;
    }

    try {
      String fileName =
          'featured_pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf';
      TaskSnapshot uploadTask = await _storage.ref(fileName).putFile(_pdfFile!);
      String downloadURL = await uploadTask.ref.getDownloadURL();

      // Add PDF download URL to Firestore (can be adjusted to your needs)
      await _firestore.collection('books').add({
        'pdfUrl': downloadURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF Uploaded Successfully')),
      );

      // Clear the file after successful upload
      setState(() {
        _pdfFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload Failed: $e')),
      );
    }
  }

  Future<void> _selectPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pdfFile = File(result.files.single.path!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No PDF selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting PDF: $e')),
      );
    }
  }

  Future<void> _uploadCategory(String categoryName) async {
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a category name.')),
      );
      return;
    }

    try {
      await _firestore.collection('categories').add({
        'name': categoryName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category Added Successfully')),
      );

      // Clear field after successful addition
      _categoryController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Add Category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _selectPdf,
              child: Text('Select Book PDF'),
            ),
            if (_pdfFile != null) ...[
              SizedBox(height: 16),
              Text('Selected File: ${_pdfFile!.path}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadPdf,
                child: Text('Upload PDF'),
              ),
            ],
            SizedBox(height: 32),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'New Category Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _uploadCategory(_categoryController.text);
              },
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
