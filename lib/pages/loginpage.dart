import 'package:dont_panic_ngo_app/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email='';
  String password='';
  String uid='';
  final _auth = FirebaseAuth.instance;
  //final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don\'t\nPanic',style: TextStyle(
              color: Colors.white,
              fontSize: 70,
              fontFamily: 'Amarante',
            ),),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                elevation: 40.0,
                borderRadius: BorderRadius.circular(40.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      email=value;
                    });
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Email ID',
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0)))),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 40.0,
                borderRadius: BorderRadius.circular(40.0),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      password=value;
                    });
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'Password',
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0)))),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    buttonColor: Colors.white,
                    height: 45,
                    minWidth: 100,
                    child: RaisedButton(
                      child: Text('Sign Up'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ),
                  ButtonTheme(
                    height: 45,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    buttonColor: Colors.white,
                    child: RaisedButton(
                      child: Text('Login'),
                     onPressed: () async{
                  try {
                    print('email:'+email+"   "+password);
                    final firebaseUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                    if (firebaseUser != null) {
                    final currentFirebaseUser = await _auth.currentUser();
                    loggedInUser = currentFirebaseUser;
                    User.email = loggedInUser.email;
                    User.uid = loggedInUser.uid;
                    Navigator.pushNamed(context,'/homepage');
                      print(loggedInUser.email+' logged in!!');
                    }
                    } catch (e) {
                    print(e);
                    }

                  },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




    