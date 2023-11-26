import 'package:flutter/material.dart';
import 'package:memories_in_frames/add_journals.dart';
import 'add.dart';
import 'showPhotos.dart';
import 'package:memories_in_frames/Calender.dart';
import 'showJournals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo dairy',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Current index of the bottom navigation bar

  void _onTabTapped(int index) {
    if (index == 2) { // Assuming "Photos" is at index 2
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ShowPhotoPage()),
      );
    }
    else if(index == 1){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CalendarPage()),
      );
    }
    else if(index == 3){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ShowJournalsPage()),
      );
    }
    else {
      setState(() {
        _currentIndex = index;
      });
    }
    // Add handling for other tabs if needed
  }
  void _showEntryOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Add Photo Memory'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => add()), // Replace with your Add Photo Memory Page
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Add Journal'),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => add_journals()), // Existing Journal Add Page
                    );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
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
        title: Text('Photo Diary'),
        // ... Your AppBar code
      ),
      body: Center(
        child: Text('No Journal Entries'), // Update this based on the selected tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Journals',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: _showEntryOptions,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('New Entry'),
        elevation: 4.0,
      ),
    );
  }
}