import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(showJournals());
}

class showJournals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Memories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowJournalsPage(),
    );
  }
}

class ShowJournalsPage extends StatefulWidget {
  @override
  _ShowJournalsPageState createState() => _ShowJournalsPageState();
}

class PhotoMemory {
  String title;
  String description;
  String imageUrl;

  PhotoMemory(this.title, this.description, this.imageUrl);
}



class _ShowJournalsPageState extends State<ShowJournalsPage> {

  static final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://memories-in-frames-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

  // final FirebaseDatabase database = FirebaseDatabase.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Journals'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: database.reference().child('Users/$userId/journals').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            if (dataSnapshot.value != null) {
              Map<dynamic, dynamic> memories = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  childAspectRatio: 1.0, // Square-shaped cards
                  crossAxisSpacing: 10, // Horizontal space between cards
                  mainAxisSpacing: 10, // Vertical space between cards
                ),
                itemCount: memories.length,
                padding: EdgeInsets.all(10), // Padding around the grid
                itemBuilder: (context, index) {
                  String key = memories.keys.elementAt(index);
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            memories[key]['title'] ?? 'No title',
                            style: TextStyle(
                              fontSize: 18.0, // Larger font size for title
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.0), // Space between title and date
                          Text(
                            memories[key]['date'] ?? 'No date',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(height: 4.0), // Reduced space between date and description
                          Expanded(
                            child: Text(
                              memories[key]['description'] ?? 'No description',
                              style: TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return Center(child: Text('No memories found'));
        },
      ),
    );
  }



}