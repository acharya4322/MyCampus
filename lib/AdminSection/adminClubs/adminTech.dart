import 'dart:io';
import 'package:mycampus/event_card.dart';
import 'package:mycampus/modals/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminTechClub extends StatefulWidget {
  const AdminTechClub({super.key});

  @override
  _AdminTechClubState createState() => _AdminTechClubState();
}

class _AdminTechClubState extends State<AdminTechClub> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _headerTitleController = TextEditingController();
  final TextEditingController _footerEmailController = TextEditingController();
  final TextEditingController _footerFacebookController =
      TextEditingController();
  final TextEditingController _footerTwitterController =
      TextEditingController();
  final TextEditingController _footerLinkedinController =
      TextEditingController();
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  File? _headerImageFile;
  File? _eventImageFile;

  // Function to pick an image from the device
  Future<void> _pickImage({required bool isHeader}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isHeader) {
          _headerImageFile = File(pickedFile.path);
        } else {
          _eventImageFile = File(pickedFile.path);
        }
      });
    }
  }

  // Function to upload the image to Firebase Storage
  Future<String?> _uploadImage(File file, String path) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = _storage.ref().child('$path/$fileName');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to update header data
  Future<void> _updateHeader() async {
    String? imageUrl;
    if (_headerImageFile != null) {
      imageUrl = await _uploadImage(_headerImageFile!, 'header_images');
    }

    try {
      await _firestore.collection('techclub').doc('header').set({
        'title': _headerTitleController.text,
        'imageUrl': imageUrl ?? '',
      });
    } catch (e) {
      print('Error updating header: $e');
    }
  }

  // Function to update footer data
  Future<void> _updateFooter() async {
    try {
      await _firestore.collection('techclub').doc('footer').set({
        'email': _footerEmailController.text,
        'facebook': _footerFacebookController.text,
        'twitter': _footerTwitterController.text,
        'linkedin': _footerLinkedinController.text,
      });
    } catch (e) {
      print('Error updating footer: $e');
    }
  }

  // Function to add an event
  Future<void> _addEvent(BuildContext context) async {
    if (_eventTitleController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    String? imageUrl;
    if (_eventImageFile != null) {
      imageUrl = await _uploadImage(_eventImageFile!, 'event_images');
    }

    try {
      await _firestore.collection('events').add({
        'title': _eventTitleController.text,
        'date': _eventDateController.text,
        'description': _eventDescriptionController.text,
        'imageUrl': imageUrl ?? '',
      });

      // Clear fields and image state
      _eventTitleController.clear();
      _eventDateController.clear();
      _eventDescriptionController.clear();
      setState(() {
        _eventImageFile = null;
      });

      // Close the dialog box
      Navigator.of(context).pop();
    } catch (e) {
      print('Error adding event: $e');
    }
  }

  // Function to delete an event
  Future<void> _deleteEvent(String id) async {
    try {
      await _firestore.collection('events').doc(id).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  // Function to show Add Event dialog
  void _showAddEventDialog() {
    _eventTitleController.clear();
    _eventDateController.clear();
    _eventDescriptionController.clear();
    setState(() {
      _eventImageFile = null;
    });

    bool showDoneButton = false;
    bool showAddEventButton = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _eventDateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              if (_eventImageFile != null)
                Image.file(
                  _eventImageFile!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image selected'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(isHeader: false);
                  setState(() {}); // Refresh dialog to show selected image
                },
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without adding the event
              },
              child: const Text('Cancel'),
            ),
            if (showDoneButton)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Done'),
              ),
            if (showAddEventButton)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showAddEventButton = false; // Hide "Add Event" button
                    showDoneButton = true; // Show "Done" button
                  });
                  await _addEvent(context);
                  // Dialog closes automatically after adding event
                },
                child: const Text('Add Event'),
              ),
          ],
        ),
      ),
    );
  }

  // Function to show Update Header dialog
  void _showUpdateHeaderDialog() {
    _headerTitleController.clear();
    setState(() {
      _headerImageFile = null;
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Header'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _headerTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              if (_headerImageFile != null)
                Image.file(
                  _headerImageFile!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image selected'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(isHeader: true);
                  setState(() {}); // Refresh dialog to show selected image
                },
                child: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without updating the header
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateHeader();
                Navigator.of(context)
                    .pop(); // Close the dialog after updating the header
              },
              child: const Text('Update Header'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show Update Footer dialog
  void _showUpdateFooterDialog() {
    _firestore.collection('techclub').doc('footer').get().then((doc) {
      if (doc.exists) {
        final footerData = doc.data() as Map<String, dynamic>;
        _footerEmailController.text = footerData['email'] ?? '';
        _footerFacebookController.text = footerData['facebook'] ?? '';
        _footerTwitterController.text = footerData['twitter'] ?? '';
        _footerLinkedinController.text = footerData['linkedin'] ?? '';
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Footer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _footerEmailController,
              decoration: const InputDecoration(labelText: 'Contact Email'),
            ),
            TextField(
              controller: _footerFacebookController,
              decoration: const InputDecoration(labelText: 'Facebook URL'),
            ),
            TextField(
              controller: _footerTwitterController,
              decoration: const InputDecoration(labelText: 'Twitter URL'),
            ),
            TextField(
              controller: _footerLinkedinController,
              decoration: const InputDecoration(labelText: 'LinkedIn URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Close the dialog without updating the footer
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateFooter();
              Navigator.of(context)
                  .pop(); // Close the dialog after updating the footer
            },
            child: const Text('Update Footer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Function to show Delete Event dialog
  void _showDeleteEventDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteEvent(id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            StreamBuilder<DocumentSnapshot>(
              stream:
                  _firestore.collection('techclub').doc('header').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No header data available.'));
                }

                final headerData =
                    snapshot.data!.data() as Map<String, dynamic>;
                final headerTitle = headerData['title'] ?? '';
                final headerImageUrl = headerData['imageUrl'] ?? '';

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        headerImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        (progress.expectedTotalBytes ?? 1)
                                    : null),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Error loading image'));
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.2),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          headerTitle,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Update Header Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showUpdateHeaderDialog,
                child: const Text('Update Header'),
              ),
            ),
            // Update Footer Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showUpdateFooterDialog,
                child: const Text('Update Footer'),
              ),
            ),
            const SizedBox(height: 20),
            // Add Event Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showAddEventDialog,
                child: const Text('Add Event'),
              ),
            ),
            const SizedBox(height: 20),
            // Upcoming Events Section
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No events available.'));
                }

                final events = snapshot.data!.docs;
                return Column(
                  children: events.map((doc) {
                    final event = Event.fromDocument(doc);
                    return GestureDetector(
                      onLongPress: () => _showDeleteEventDialog(event.id),
                      child: EventCard(
                        title: event.title,
                        date: event.date,
                        description: event.description,
                        imageUrl: event.imageUrl,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
