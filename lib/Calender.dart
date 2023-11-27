import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:memories_in_frames/add_journals.dart';
import 'add.dart';
import 'showPhotos.dart';
import 'package:memories_in_frames/Calender.dart';
import 'showJournals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }
  Map<String, List<Map<String, dynamic>>> dataGroupedByDate = {};

  void combineAndSortAndGroupData(Map<dynamic, dynamic> journals, Map<dynamic, dynamic> memories) {
    // Combine and sort data by date in ascending order
    List<Map<String, dynamic>> combinedData = [];
    combinedData.addAll(journals.values.map((e) => Map<String, dynamic>.from(e)));
    combinedData.addAll(memories.values.map((e) => Map<String, dynamic>.from(e)));
    combinedData.sort((a, b) => a['date'].compareTo(b['date']));

    // Group data by date
    for (var entry in combinedData) {
      String date = entry['date'];
      if (dataGroupedByDate[date] == null) {
        dataGroupedByDate[date] = [];
      }
      dataGroupedByDate[date]!.add(entry);
    }
  }

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when there is no user logged in
      return;
    }
    String userId = user.uid;


    // DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://memories-in-frames-default-rtdb.asia-southeast1.firebasedatabase.app",
    );

    // Create a path for the user's memories
    final DatabaseReference dbRef = database.ref();

    // Fetch journals
    DataSnapshot journalSnapshot = await dbRef.child('Users/$userId/journals').get();
    Map<dynamic, dynamic> journals = {};
    if (journalSnapshot.exists) {
      journals = Map<dynamic, dynamic>.from(journalSnapshot.value as Map);
    }

    // Fetch memories
    DataSnapshot memorySnapshot = await dbRef.child('Users/$userId/memories').get();
    Map<dynamic, dynamic> memories = {};
    if (memorySnapshot.exists) {
      memories = Map<dynamic, dynamic>.from(memorySnapshot.value as Map);
    }
    setState(() {
      // Update your data variables here
      combineAndSortAndGroupData(journals, memories);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          if (_selectedDay != null) // Only display the text if a day is selected
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Date: ${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),

    );
  }
}
