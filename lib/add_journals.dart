import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class add_journals extends StatefulWidget {
  @override
  _add_journals createState() => _add_journals();
}

class _add_journals extends State<add_journals> {

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      _dateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }



  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }


  Future addMemory() async {


    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? currentUser = _auth.currentUser; // Get the current logged-in user
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user logged in")),
      );
      return;
    }

    final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://memories-in-frames-default-rtdb.asia-southeast1.firebasedatabase.app",
    );

    // Create a path for the user's memories
    final DatabaseReference dbRef = database.ref().child("Users/${currentUser.uid}/journals").push();

    await dbRef.set({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': _dateController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Memory added successfully")),
    );

    // Clear the text fields and reset the state
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
    });
  }




  String? selectedMealType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal upload',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0), // Added padding to the sides
        child: Column(
          children: <Widget>[
            SizedBox(height: 20), // Added some space before the form fields
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Select Date',
                hintText: 'Pick a date',
              ),
              readOnly: true,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode()); // to prevent opening of the keyboard
                _selectDate(context);
              },
            ),

            SizedBox(height: 20), // Added some space before the form fields
            buildTextFormField(
                _titleController, // Use the new controller here
                'Title', // Label text for the new field
                TextInputType.text // Set the keyboard type to text
            ),
            SizedBox(height: 5),
            Container(
              width: double.infinity, // Ensures the Container fills the width of its parent
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                minLines: 1, // Minimum lines for the input
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Memory Description',
                  border: OutlineInputBorder(), // Adds a border around the TextFormField
                  // Add more decoration as needed.
                ),
                style: TextStyle(
                  fontSize: 16.0, // Adjust the font size as needed.
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Add Memory', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // background
                onPrimary: Colors.white, // text color
              ),
              onPressed: addMemory,
            ),
            SizedBox(height: 20), // Added space at the bottom
          ],
        ),
      ),
    );
  }


  Widget buildTextFormField(TextEditingController controller, String label,
      TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        // Added padding inside the text field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Rounded corners for the input border
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 1.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
