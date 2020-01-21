import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import'package:firebase_auth/firebase_auth.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dont panic Ngo'),
        centerTitle: true,
      ),
     body: Column(
       children: <Widget>[
         Image.asset('assets/namaste.gif',height: MediaQuery.of(context).size.height/2,),
         Card(
           child: InkWell(
             child: ListTile(
               title: Text('Record the update'),
               trailing: Icon(Icons.arrow_forward_ios),
             ),
             onTap: (){
               Navigator.pushNamed(context, '/recorder');
             },
           ),
         ),
         Card(
           child: InkWell(
             child: ListTile(
               title: Text('Fetch Location'),
               trailing: Icon(Icons.map),
             ),
             onTap: (){
               Navigator.pushNamed(context, '/locationFetch');
             },
           ),
         ),
         Card(
           child: InkWell(
             onTap: () async {
               _auth.signOut();
              Navigator.pushNamed(context, '/');
             },
             child: ListTile(
               title: Text('Log-Out'),
               trailing: Icon(Icons.exit_to_app,),
             ),
             
           ),
         )
       ],
     )
    );
  }
}
