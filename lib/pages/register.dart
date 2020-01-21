import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
final _firestore = Firestore.instance;
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email="";
  String name="";
  String phone="";
  String id="";
  String desc="";
  Uuid uuid=Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  labelText: "E-mail id",
                  contentPadding: EdgeInsets.only(top: 14.0, left: 44.0),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  labelText: "Name",
                  contentPadding: EdgeInsets.only(top: 14.0, left: 44.0),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  labelText: "Phone number",
                  contentPadding: EdgeInsets.only(top: 14.0, left: 44.0),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),

              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    desc = value;
                  });
                },
                maxLines: 3,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  labelText: "Description about the ngo",
                  contentPadding: EdgeInsets.only(top: 14.0, left: 44.0),
                ),
              ),
            ),

             RaisedButton(
              onPressed: () {
                _firestore.collection('newAccountRequests').document().setData({
                  'name': name,
                  'email':email,
                  'phone':phone,
                  'desc':desc,
                  'id':uuid.v1().split('-').join().toString(),
                },
                 
                );
                Navigator.pushNamed(context,'/');
              },
              child: Text('Submit'),
            )      
          ],
        ),
      )

    );
  }
}