import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAnnouncement extends StatefulWidget {
  @override
  _AdminAnnouncementState createState() => _AdminAnnouncementState();
}

class _AdminAnnouncementState extends State<AdminAnnouncement> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isDialogVisible = false; // Flag to prevent multiple dialogs

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final fileName = DateTime.now().toIso8601String(); // Unique file name
    final storageRef =
        FirebaseStorage.instance.ref().child('announcements/$fileName');
    final uploadTask = storageRef.putFile(_image!);

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('announcements')
        .add({'imageUrl': downloadUrl, 'storagePath': storageRef.fullPath});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Image uploaded successfully!')));
    setState(() {
      _image = null; // Clear the selected image
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _deleteAnnouncement(String imageUrl, String storagePath) async {
    try {
      // Delete from Firestore
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
          .collection('announcements')
          .where('imageUrl', isEqualTo: imageUrl)
          .get();
      for (var doc in query.docs) {
        await doc.reference.delete();
      }

      // Delete from Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      await storageRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Announcement deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete announcement: $e')));
    }
  }

  void _showImageDialog() {
    if (_isDialogVisible) return; // Prevent multiple dialogs
    setState(() {
      _isDialogVisible = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: Text('Add Announcement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_image != null)
              Image.file(_image!, height: 200.0, fit: BoxFit.cover),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _pickImage();
                if (_image != null) {
                  await _uploadImage();
                }
                setState(() {
                  _isDialogVisible = false; // Reset the flag
                });
              },
              child: Text('Pick and Upload Image'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                _isDialogVisible = false; // Reset the flag
              });
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((_) {
      // Reset the flag when the dialog is dismissed
      setState(() {
        _isDialogVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Announcements ')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data?.docs.isEmpty == true) {
                  return Center(child: Text('No announcements available.'));
                }

                final announcements = snapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Space between columns
                    mainAxisSpacing: 8.0, // Space between rows
                  ),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final doc = announcements[index];
                    final data = doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return SizedBox.shrink();
                    }

                    final imageUrl = data['imageUrl'] as String? ?? '';
                    final storagePath = data['storagePath'] as String? ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreenImage(imageUrl: imageUrl),
                          ),
                        );
                      },
                      onLongPress: () {
                        _showDeleteDialog(context, imageUrl, storagePath);
                      },
                      child: Card(
                        margin: EdgeInsets.all(0.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Announcement',
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String imageUrl, String storagePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Announcement'),
        content: Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAnnouncement(imageUrl, storagePath);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect downward swipe
          if (details.primaryDelta! > 10) {
            Navigator.of(context).pop(); // Close on swipe down
          }
        },
        child: Center(
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
