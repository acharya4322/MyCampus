import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Displaytimetable extends StatelessWidget {
  const Displaytimetable({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final currentDay = _getCurrentDay();
    final currentTime = TimeOfDay.now();
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('timetables')
            .doc(currentDay)
            .collection('periods')
            .orderBy('startTime')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final periods = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final startTime = _parseTime(data['startTime']);
            final endTime = _parseTime(data['endTime']);
            return Period(
              name: data['name'],
              subject: data['subject'],
              startTime: startTime,
              endTime: endTime,
            );
          }).toList();

          // Filter to find periods that include the current time
          final currentPeriods = periods
              .where((period) => _isCurrentPeriod(period, currentTime))
              .toList();

          // Show only one period if multiple are found
          final displayPeriod = currentPeriods.isNotEmpty
              ? currentPeriods.first
              : Period(
                  name: 'No Period',
                  subject: 'N/A',
                  startTime: TimeOfDay.now(),
                  endTime: TimeOfDay.now(),
                );

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shadowColor: Colors.blueGrey,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  decoration: const BoxDecoration(
                      //border: Border.all(color: Colors.black, width: 1),
                      // borderRadius: BorderRadius.circular(8),
                      //color: Colors.white,
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Period: ${displayPeriod.name}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Subject: ${displayPeriod.subject}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Start: ${_formatTime(displayPeriod.startTime)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors
                                    .grey[600], // Faded color for time interval
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'End: ${_formatTime(displayPeriod.endTime)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors
                                    .grey[600], // Faded color for time interval
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String _getCurrentDay() {
  final now = DateTime.now();
  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  return days[now.weekday - 1];
}

TimeOfDay _parseTime(String timeStr) {
  final parts = timeStr.split(':');
  if (parts.length != 2) {
    throw const FormatException('Invalid time format');
  }
  return TimeOfDay(
    hour: int.parse(parts[0]),
    minute: int.parse(parts[1]),
  );
}

String _formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

bool _isCurrentPeriod(Period period, TimeOfDay currentTime) {
  final startTime = period.startTime;
  final endTime = period.endTime;

  if (startTime.hour < endTime.hour ||
      (startTime.hour == endTime.hour && startTime.minute < endTime.minute)) {
    return (currentTime.hour > startTime.hour ||
            (currentTime.hour == startTime.hour &&
                currentTime.minute >= startTime.minute)) &&
        (currentTime.hour < endTime.hour ||
            (currentTime.hour == endTime.hour &&
                currentTime.minute <= endTime.minute));
  } else {
    // Period spans midnight
    return (currentTime.hour > startTime.hour ||
            (currentTime.hour == startTime.hour &&
                currentTime.minute >= startTime.minute)) ||
        (currentTime.hour < endTime.hour ||
            (currentTime.hour == endTime.hour &&
                currentTime.minute <= endTime.minute));
  }
}

class Period {
  final String name;
  final String subject;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Period({
    required this.name,
    required this.subject,
    required this.startTime,
    required this.endTime,
  });
}
