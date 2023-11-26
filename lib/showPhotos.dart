import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ShowPhotoApp());
}

class ShowPhotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Memories',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowPhotoPage(),
    );
  }
}

class ShowPhotoPage extends StatefulWidget {
  @override
  _ShowPhotoPageState createState() => _ShowPhotoPageState();
}

class PhotoMemory {
  String title;
  String description;
  String imageUrl;

  PhotoMemory(this.title, this.description, this.imageUrl);
}



class _ShowPhotoPageState extends State<ShowPhotoPage> {

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
        title: Text('My Memories'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: database.reference().child('Users/$userId/memories').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            if (dataSnapshot.value != null) {
              Map<dynamic, dynamic> memories = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
              return ListView.builder(
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  String key = memories.keys.elementAt(index);
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.network(
                          memories[key]['image'],
                          fit: BoxFit.cover,
                          height: 200.0, // Set a fixed height for the image
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                memories[key]['title'] ?? 'No title',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0), // Space between title and subtitle
                              Text(
                                memories[key]['date'] ?? 'No date',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(height: 4.0), // Space between title and subtitle
                              Text(
                                memories[key]['description'] ?? 'No description',
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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