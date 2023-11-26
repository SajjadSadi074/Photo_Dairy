import 'package:flutter/material.dart';
import 'package:memories_in_frames/add_journals.dart';
import 'add.dart';
import 'showPhotos.dart';
import 'package:memories_in_frames/Calender.dart';
import 'showJournals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

  @override
  void initState() {
    super.initState();
    fetchData();
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

    combineAndSortAndGroupData(journals, memories);
  }






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
    var dates = dataGroupedByDate.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Diary'),
        // ... Your AppBar code
      ),
      body: ListView.builder(
        itemCount: dates.length,
        itemBuilder: (BuildContext context, int index) {
          String date = dates[index];
          var entries = dataGroupedByDate[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Date header
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(date, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              // Cards for each entry in a two-column grid
              GridView.count(
                crossAxisCount: 2, // Two columns
                childAspectRatio: 1.0, // Adjust the aspect ratio as needed
                shrinkWrap: true, // Important to make GridView work inside ListView
                physics: NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
                children: entries.map<Widget>((entry) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(entry['title'] ?? 'No title', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(entry['description'] ?? 'No description'),
                          // Adjust the image widget
                          if (entry.containsKey('image'))
                            Expanded(  // Wrap the image in an Expanded widget
                              child: Image.network(
                                entry['image'],
                                fit: BoxFit.cover,  // You can experiment with BoxFit values
                                height: 100,  // Optionally set a fixed height
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
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