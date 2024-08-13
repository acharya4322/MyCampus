import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminTimeTable extends StatefulWidget {
  @override
  _AdminTimeTableState createState() => _AdminTimeTableState();
}

class _AdminTimeTableState extends State<AdminTimeTable> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedDay = 'Monday';

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _addPeriod() async {
    if (_formKey.currentState?.validate() ?? false) {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('timetables')
          .doc(_selectedDay)
          .collection('periods')
          .add({
        'name': _nameController.text,
        'subject': _subjectController.text,
        'startTime': _formatTime(_startTime!),
        'endTime': _formatTime(_endTime!),
      });

      // Clear input fields and reset time selection
      _nameController.clear();
      _subjectController.clear();
      _startTime = null;
      _endTime = null;

      // Close the dialog after adding the period
      Navigator.of(context).pop();
    }
  }

  void _showAddPeriodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Period'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Period Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a subject' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Start Time: ${_startTime?.format(context) ?? 'Select'}'),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, true),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'End Time: ${_endTime?.format(context) ?? 'Select'}'),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, false),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: _addPeriod,
              child: Text('Add Period'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedDay,
              onChanged: (value) {
                setState(() {
                  _selectedDay = value!;
                });
              },
              items: days.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('timetables')
                  .doc(_selectedDay)
                  .collection('periods')
                  .orderBy('startTime')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No periods for today.'));
                }

                final periods = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Period(
                    id: doc.id,
                    name: data['name'],
                    subject: data['subject'],
                    startTime: _parseTime(data['startTime']),
                    endTime: _parseTime(data['endTime']),
                  );
                }).toList();

                return TimetableGrid(
                  periods: periods,
                  selectedDay: _selectedDay,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPeriodDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Period',
      ),
    );
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format');
    }
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class TimetableGrid extends StatelessWidget {
  final List<Period> periods;
  final String selectedDay;

  const TimetableGrid({
    required this.periods,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    // Helper function to convert TimeOfDay to minutes since midnight
    int _timeToMinutes(TimeOfDay time) {
      return time.hour * 60 + time.minute;
    }

    // Function to create a unique key based on start and end time
    String _createUniqueKey(TimeOfDay startTime, TimeOfDay endTime) {
      return '${_timeToMinutes(startTime)}-${_timeToMinutes(endTime)}';
    }

    // Group periods by start and end time
    final uniquePeriods = <String, Period>{};
    for (var period in periods) {
      final key = _createUniqueKey(period.startTime, period.endTime);
      if (!uniquePeriods.containsKey(key)) {
        uniquePeriods[key] = period;
      }
    }

    // Convert unique periods to a list and sort by start time
    final sortedPeriods = uniquePeriods.values.toList()
      ..sort((a, b) =>
          _timeToMinutes(a.startTime).compareTo(_timeToMinutes(b.startTime)));

    return ListView.builder(
      itemCount: sortedPeriods.length,
      itemBuilder: (context, index) {
        final period = sortedPeriods[index];
        return GestureDetector(
          onLongPress: () => _showDeleteDialog(context, period),
          child: Card(
            margin: EdgeInsets.all(4.0),
            child: ListTile(
              title: Text('${period.name} - ${period.subject}'),
              subtitle: Text(
                  '${_formatTime(period.startTime)} - ${_formatTime(period.endTime)}'),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Period period) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Period'),
          content: Text('Are you sure you want to delete this period?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await _deletePeriod(period);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  print('Error deleting period: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete period')),
                  );
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePeriod(Period period) async {
    try {
      await FirebaseFirestore.instance
          .collection('timetables')
          .doc(selectedDay)
          .collection('periods')
          .doc(period.id)
          .delete();
    } catch (e) {
      print('Error deleting period: $e');
      throw e;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class Period {
  final String id; // Unique identifier for the period
  final String name;
  final String subject;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Period({
    required this.id, // Initialize id
    required this.name,
    required this.subject,
    required this.startTime,
    required this.endTime,
  });
}
