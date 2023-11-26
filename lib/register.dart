import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://memories-in-frames-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

   final DatabaseReference _dbRef = database.ref().child("Users");

  // Controllers for input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildEmailField(),
              SizedBox(height: 20),
              buildNameField(),
              SizedBox(height: 20),
              buildPasswordField(),
              SizedBox(height: 20),
              buildConfirmPasswordField(),
              SizedBox(height: 20),
              buildRegisterButton(),
              SizedBox(height: 10),
              buildHaveAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Enter your name',
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password',
          ),
        ),
      ],
    );
  }

  Widget buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
          ),
        ),
      ],
    );
  }


  Widget buildRegisterButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (passwordController.text == confirmPasswordController.text) {
            try {
              UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );

              // If registration is successful, save additional user data to Firebase Realtime Database
              if (userCredential.user != null) {
                //  await _dbRef.child(userCredential.user!.uid).set({
                //   'name': nameController.text,
                //   'email': emailController.text,
                //   'height': heightController.text,
                //   'weight': weightController.text,
                //   'dob': DateTime(1990, 1, 1),
                // });
                print("database------------------------");
                try {
                  String uid = userCredential.user!.uid;
                  print("user id "+uid);
                  //final DatabaseReference _dbRef = database.ref().child("Users");

                  await _dbRef.child(uid).set({
                    'name': nameController.text,
                    'email': emailController.text,
                  });
                  // If the operation is successful, you can do something here
                  print("Data saved successfully");
                } catch (e) {
                  // If there is an error, it will be caught here
                  print("An error occurred: $e");
                  // You can also handle the error more specifically if you need to
                }

                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Registration'),
                      content: Text('Registration successful!'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );

                Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }
            } catch (e) {
              print(e); // Print the exception for debugging
              // Display an error message to the user
            }
          } else {
            // Display an error message if passwords don't match
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff3ba80b), // Button color
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget buildHaveAccountText() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text(
        'Already have an account?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}